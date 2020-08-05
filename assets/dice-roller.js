const readline = require("readline");
const { DiceRoller } = require("rpg-dice-roller/lib/umd/bundle");

const roller = new DiceRoller();

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
});

rl.on("line", (line) => {
  const result = roller.roll(line.trim());
  process.stdout.write(Buffer.from(JSON.stringify(result), "utf8"));
  process.stdout.write(Buffer.from("\n"));
  process.exit(0);
});
