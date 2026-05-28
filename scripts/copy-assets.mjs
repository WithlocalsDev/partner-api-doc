import { existsSync, cpSync } from "node:fs";

if (existsSync("assets")) {
  cpSync("assets", "dist/api-reference/assets", { recursive: true });
  console.log("copied assets/ -> dist/api-reference/assets/");
}
