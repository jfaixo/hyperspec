#!/usr/bin/env node
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

function runGit(args) {
  try {
    return execFileSync("git", args, { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] });
  } catch {
    return null;
  }
}

function loadIgnoredPaths(ignoreFile = ".hyperspec/specignore") {
  if (!fs.existsSync(ignoreFile)) return new Set();
  const lines = fs.readFileSync(ignoreFile, "utf8").split("\n");
  const ignored = new Set();
  for (const raw of lines) {
    const line = raw.trim();
    if (line && !line.startsWith("#")) {
      ignored.add(line.replace(/^\.?\//, ""));
    }
  }
  return ignored;
}

function isIgnored(filePath, ignoredPaths) {
  const normalized = filePath.replace(/^\.?\//, "");
  const basename = path.basename(normalized);
  return ignoredPaths.has(normalized) || ignoredPaths.has(basename);
}

function getSpecFiles(dir = "specs", ignoredPaths = new Set()) {
  if (!fs.existsSync(dir)) return [];
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  return entries
    .flatMap((entry) => {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) return getSpecFiles(fullPath, ignoredPaths);
      return entry.isFile() && entry.name.endsWith(".md") && !isIgnored(fullPath, ignoredPaths)
        ? [fullPath]
        : [];
    })
    .sort();
}

function extractStatus(content) {
  const match = content.match(/^status:\s*([A-Za-z_-]+)/m);
  return match ? match[1].trim().toUpperCase() : "UNKNOWN";
}

function findLastAlignedCommit(specPath) {
  const commits = runGit(["log", "--follow", "--format=%H", "--", specPath]);
  if (!commits) return null;

  for (const commit of commits.trim().split("\n")) {
    if (!commit) continue;
    const content = runGit(["show", `${commit}:${specPath}`]);
    if (content !== null && extractStatus(content) === "ALIGNED") {
      return commit;
    }
  }
  return null;
}

function main() {
  const ignoredPaths = loadIgnoredPaths();
  const specs = getSpecFiles("specs", ignoredPaths);
  const unaligned_specs = [];

  for (const specPath of specs) {
    let content;
    try {
      content = fs.readFileSync(specPath, "utf8");
    } catch {
      continue;
    }

    const status = extractStatus(content);
    if (status === "ALIGNED") continue;

    const lastAligned = findLastAlignedCommit(specPath);
    const diff = lastAligned
      ? (runGit(["diff", `${lastAligned}..HEAD`, "--", specPath]) ?? "")
      : content;

    unaligned_specs.push({
      path: specPath,
      status,
      last_aligned_commit: lastAligned,
      delta: diff.trim(),
    });
  }

  console.log(JSON.stringify({ unaligned_specs }, null, 2));
}

main();
