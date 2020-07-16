#FallingWords
Here are some documentation and comments for the solution of Option #1 (Falling Words) of the technical challenge.

## How to run the project
Open *FallingWords.xcodeproj* and just run the project.

## Architecture and Design
HR mentioned that *MVVM + Combine* is a plus. I've never used it in production, but I can see that it is a global trend, especially with the release of Combine. So I've decided to show my willingness to learn it and picked an MVVM as an architecture pattern.

It seems that MVVM implementation differs from company to company, so there may be small inconveniences. With better reference, I can do better :)

Because of time limitations:
protocols only on objects which require it for tests
force unwraps on @IBOutlet and architecture objects (ViewModel, GameEngine, etc.)

If I had more time, I would:
remove words property from GameEngine
fix the dark mode :)
load words from the internet

## Tests
Because of time limitations, I've made *tests only for the GameEngine*. I've picked only a couple of tests mostly to show my level in general.

I've used a manual DI to avoid dependencies.

If I had more time, I would:
move CADisplayLink from GameViewModel to make it testable
make tests for GameViewModel
write more tests on GameEngine (correct/wrong answers, score calculation, etc.)
write UI-tests for view

## Time
The whole challenge took *~7 hours*

Detalisation:
setup and UI *2h*
diving into the Combine *2h*
game logic *2h*
tests and related refactoring *1h*
documentation *30m*