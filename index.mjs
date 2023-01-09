import { loadStdlib, ask } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';
const stdlib = loadStdlib();

const isAlice = await ask.ask(
  'Are you Alice?',
  ask.yesno
);
const who = isAlice ? 'Alice' : 'Bob';

console.log(`Starting Rock, Paper, Scissors! as ${who}`);

let acc = null;
const createAcc = await ask.ask(
  'Would you like to creat an account? (only possible on devnet)',
  ask.yesno
);
if (createAcc) {
  acc = await stdlib.newTestAccount(stdlib.parseCurrency(1000));
} else {
  const secret = await ask.ask(
    'What is you account secret?',
    (x => x)
  );
  acc = await stdlib.newAccountFromSecret(secret);
}
