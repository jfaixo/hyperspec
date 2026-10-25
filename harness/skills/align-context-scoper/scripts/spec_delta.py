#!/usr/bin/env python3
"""
Compute specification delta for non-ALIGNED specs against their last ALIGNED git commit.
"""
import json
import os
import re
import subprocess
import sys

def run_git(args):
    result = subprocess.run(["git"] + args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return result.returncode, result.stdout, result.stderr

def get_spec_files():
    specs = []
    if not os.path.exists("specs"):
        return specs
    for root, _, files in os.walk("specs"):
        for f in files:
            if f.endswith(".md"):
                specs.append(os.path.join(root, f))
    return sorted(specs)

def extract_status(content):
    match = re.search(r"^status:\s*([A-Za-z_-]+)", content, re.MULTILINE)
    if match:
        return match.group(1).strip().upper()
    return "UNKNOWN"

def find_last_aligned_commit(spec_path):
    rc, commits_out, _ = run_git(["log", "--follow", "--format=%H", "--", spec_path])
    if rc != 0 or not commits_out.strip():
        return None
    for commit in commits_out.strip().splitlines():
        rc, file_content, _ = run_git(["show", f"{commit}:{spec_path}"])
        if rc == 0 and extract_status(file_content) == "ALIGNED":
            return commit
    return None

def main():
    specs = get_spec_files()
    report = {
        "unaligned_specs": []
    }

    for spec_path in specs:
        try:
            with open(spec_path, "r", encoding="utf-8") as f:
                content = f.read()
        except Exception as e:
            continue

        status = extract_status(content)
        if status == "ALIGNED":
            continue

        last_aligned = find_last_aligned_commit(spec_path)
        if last_aligned:
            _, diff_out, _ = run_git(["diff", f"{last_aligned}..HEAD", "--", spec_path])
        else:
            diff_out = content

        report["unaligned_specs"].append({
            "path": spec_path,
            "status": status,
            "last_aligned_commit": last_aligned,
            "delta": diff_out.strip()
        })

    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
