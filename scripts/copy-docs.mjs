import { mkdirSync, copyFileSync } from "node:fs";

mkdirSync("dist/api-reference", { recursive: true });

copyFileSync("index.html", "dist/api-reference/index.html");
console.log("copied index.html -> dist/api-reference/index.html");

copyFileSync("redirect.html", "dist/index.html");
console.log("copied redirect.html -> dist/index.html");
