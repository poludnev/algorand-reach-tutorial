'reach 0.1'

const Player = {
  getHand: Fun([], UInt),
  seeOutcome: Fun([UInt], Null)
}

export const main = Reach.App(() => {
  const Alice = Participant('Alice', {
    ...Player,
    wager: UInt,
  });
  const Bob = Participant('Bob', {
    ...Player,
    acceptWager: Fun([UInt], Null)
  });
  init();

  Alice.only(() => {
    const wager = declassify(interact.wager);
    const handAlice = declassify(interact.getHand());
  })
  Alice.publish(wager, handAlice)
    .pay(wager);
  commit();

  unknowable(Bob, Alice(handAlice));
  Bob.only(() => {
    interact.acceptWager(wager);
    const handBob = declassify(interact.getHand());
    //  const handBob = (handAlice + 1) % 3;
  })
  Bob.publish(handBob)
    .pay(wager);

  const outcome = (handAlice + (4 - handBob)) % 3;
  // require(handBob == (handAlice + 1) % 3);
  // assert(outcome == 0);
  const [forAlice, forBob] =
    outcome == 2 ? [2, 0] :
      outcome == 0 ? [0, 2] :
        [1, 1];
  transfer(forAlice * wager).to(Alice);
  transfer(forBob * wager).to(Bob);
  commit();

  each([Alice, Bob], () => {
    interact.seeOutcome(outcome);
  })
})
