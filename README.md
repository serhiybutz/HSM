# HSM

A hierarchical state machine (statechart) framework implementation in Swift.


<p>
    <img src="https://img.shields.io/badge/Swift-5.1-orange" alt="Swift" />
    <img src="https://img.shields.io/badge/platform-macOS%20|%20iOS-orange.svg" alt="Platform" />
    <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-orange" alt="SPM" />
    <a href="https://github.com/SergeBouts/Mitra/blob/master/LICENSE">
        <img src="https://img.shields.io/badge/licence-MIT-orange" alt="License" />
    </a>
</p>



## Contents

- [Features](#features)
- [Usage](#usage)
- [Demos](#demos)
- [Installation](#installation)
- [License](#license)
- [Resources](#resources)



## Features:
- UML standard compliance

- Hierarchical states with full support for behavioral inheritance

- Orthogonal regions

- State entry and exit actions for initialization and cleanup and also transition actions

- Internal and external self-transitions

- Initial, fork and join pseudostates

- History mechanism (both shallow and deep history)

- Actor (active object) model

- Run-To-Completion model

- Extended state support, and etc
  
  

The framework was developed with the following aspirations:

- It should be simple to use and maintain. Defining state should be as easy as defining OOP classes.
- It should allow for easy changes in the state machine topology (state nesting and state transitions). No manual coding of transition chains should be required.
- It should provide good runtime efficiency and take up little memory. The cost of dispatching events in a state machine should be comparable to calling virtual functions in OOP.
- It should be as UML-compliant as possible.
- The verbosity of the code for using the state machine should be reduced as much as possible.

Note: These requirements often contradict each other, so this implementation strives to achieve a balanced implementation.



## Usage

An understanding of Harel's statecharts and their concepts is required for work with this framework. At the end of this page you will find some links to resources on this topic.

Consider the following statechart diagram:

![](statechart1.svg)

You can represent this diagram in the framework with the following code:

```swift
class MyTop: TopState<MyEvent> {
    class Substate1: State<MyTop, MyTop> {
        override func entry() { ... } // optional
        override func exit() { ... } // optional
        override func handle(_ event: MyEvent) -> Transition? { // optional
            switch event {
                case .evt1(let flag) where flag:
                    return Transition(to: superior.substate2)
                default:
                    return nil
            }
        }
    }
    let substate1 = Substate1()

    class Substate2: State<MyTop, MyTop> {
        override func entry() { ... } // optional
        override func exit() { ... } // optional
        override func handle(_ event: MyEvent) -> Transition? { ... } // optional
    }
    let substate2 = Substate2()

    override func initialize() {
        bind(substate1, substate2)
        initial = substate1 // optional
        historyMode = .shallow // optional
    }
}
```

Here we have a top state `MyTop`  which is a _composite_ state and it's parameterized by our event type `MyEvent`. The `MyTop` contains 2 sub-states `Substate1` and `Substate2`. All sub-states in the framework have the same structure. A substate must be explicitly parameterized with two types: (1) its immediate superior state, the immediate container (or parent), (2) and the top state (which is always the most superior state). This serves to bind all state types nested in the hierarchy of states, and to enable statically referring to the immediate superior and topmost state from event handlers and state reactions; for this each state has 2 properties `superior` and `top`.

Each state must bind its sub-states in the `initialize()` method, passing them as arguments in the `bind(...)` call. The `initialize()` method is also the method in which you configure _initial_ (or default) sub-state as well as the state _history mode_.



# Demos

Here are simple demo apps so that you can try and hands-on experiment with the framework yourself.

## [HSM-based running lights demo](https://github.com/SergeBouts/HSMRunningLightsDemo)

Statechart diagram:


![](https://github.com/SergeBouts/HSMRunningLightsDemo/blob/master/statechart.svg?raw=true)

Here's the source code of the HSM-based application controller for the above statechart diagram:


```swift
import Foundation
import HSM

/// HSM-based controller
class Controller: TopState<Event> {
    // MARK: - Substates

    class Lights: State<Controller, Controller> {
        class Red: State<Lights, Controller> {
            override func entry() {
                top.actions.turnOnRedLed()
            }
            override func exit() {
                top.actions.turnOffRedLed()
            }
            override func handle(_ event: Event) -> Transition? {
                switch event {
                case .timerTick: return Transition(to: superior.green)
                default: return nil
                }
            }
        }
        let red = Red()

        class Green: State<Lights, Controller> {
            override func entry() {
                top.actions.turnOnGreenLed()
            }
            override func exit() {
                top.actions.turnOffGreenLed()
            }
            override func handle(_ event: Event) -> Transition? {
                switch event {
                case .timerTick: return Transition(to: superior.blue)
                default: return nil
                }
            }
        }
        let green = Green()

        class Blue: State<Lights, Controller> {
            override func entry() {
                top.actions.turnOnBlueLed()
            }
            override func exit() {
                top.actions.turnOffBlueLed()
            }
            override func handle(_ event: Event) -> Transition? {
                switch event {
                case .timerTick: return Transition(to: superior.red)
                default: return nil
                }
            }
        }
        let blue = Blue()

        // MARK: - Initialization

        override func initialize() {
            bind(red, green, blue)
            initial = red
            historyMode = .shallow
        }

        // MARK: - Lifecycle

        override func entry() {
            top.actions.clear()
        }

        override func handle(_ event: Event) -> Transition? {
            switch event {
            case .buttonTap: return Transition(to: superior.paused)
            default: return nil
            }
        }
    }
    let lights = Lights()

    class Paused: State<Controller, Controller> {
        override func handle(_ event: Event) -> Transition? {
            switch event {
            case .buttonTap: return Transition(to: superior.lights)
            default: return nil
            }
        }
    }
    let paused = Paused()

    // MARK: - Properties

    let actions: Actions

    // MARK: - Initialization

    init(actions: Actions) {
        self.actions = actions
    }

    override func initialize() {
        bind(lights, paused)
        initial = lights
    }
}

```

## [HSM-based calculator demo](https://github.com/SergeBouts/HSMCalculatorDemo)

Statechart diagram:


![](https://github.com/SergeBouts/HSMCalculatorDemo/blob/master/statechart.svg?raw=true)

Examine the source code of the HSM-based application controller for the above statechart diagram [here](https://github.com/SergeBouts/HSMCalculatorDemo/blob/master/HSMCalculator/Controller.swift).

## Installation

### Swift Package as dependency in Xcode 11+

1. Go to "File" -> "Swift Packages" -> "Add Package Dependency"
2. Paste HSM repository URL into the search field:

```
https://github.com/SergeBouts/HSM.git
```

1. Click "Next"
2. Ensure that the "Rules" field is set to something like this: "Version: Up To Next Minor: 0.11.1"
3. Click "Next" to finish

For more info, check out [here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## License

This project is licensed under the MIT license.

## Resources

- [Wiki - UML State machine](https://en.wikipedia.org/wiki/UML_state_machine)
- [OMG - Unified Modeling Language (UML)](https://www.omg.org/spec/UML/2.5.1/PDF)
- [David Harel - Statecharts: A Visual Formalism for Complex Systems](https://www.wisdom.weizmann.ac.il/~dharel/SCANNED.PAPERS/Statecharts.pdf)
- [David Harel - Statecharts in the Making: A Personal Account](http://www.wisdom.weizmann.ac.il/~harel/papers/Statecharts.History.pdf)
- [The Statechart Perspective](http://homepage.cs.uiowa.edu/~fleck/181content/statecharts.pdf)
- [Statecharts](https://statecharts.dev/)
- [Awesome Finite State Machines](https://github.com/leonardomso/awesome-fsm)

