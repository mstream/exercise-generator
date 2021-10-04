let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/package.dhall

let Operators = ./operators.dhall

let operators = Operators.operators
let tests = Operators.tests

let showOperator
    : Operators.Operator → Text
    = λ(operator : Operators.Operator) →
        let arguments
            : Operators.Arguments
            = { m = 11, n = 22 }

        let mText
            : Text
            = Prelude.Natural.show arguments.m

        let nText
            : Text
            = Prelude.Natural.show arguments.n

        let operationExplanation
            : Text
            = Operators.showOperation operator arguments

        let resultText
            : Text
            = Prelude.Natural.show (Operators.calculate operator arguments)

        let formula
            : Text
            = Operators.showFormula operator "m" "n"

        in      "m ${operator.symbol} n = ${formula}"
            ++  "\n"
            ++  "eg. ${mText} ${operator.symbol} ${nText}"
            ++  " = ${operationExplanation}"
            ++  " = ${resultText}"

let aPriorOperatorDesc = showOperator operators.aPrior

let bPriorOperatorDesc = showOperator operators.bPrior

let cPriorOperatorDesc = showOperator operators.cPrior

let priorityDesc =
          "()"
      ++  " > ${operators.aPrior.symbol}"
      ++  " > ${operators.bPrior.symbol}"
      ++  " > ${operators.cPrior.symbol}"

in  "\n\n\n" 
    ++ "${aPriorOperatorDesc}"
    ++ "\n\n"
    ++ "${bPriorOperatorDesc}"
    ++ "\n\n"
    ++ "${cPriorOperatorDesc}"
    ++ "\n\n\n"
    ++ "${priorityDesc}"
    ++ "\n\n\n"
    ++ "${tests.aLevel}"
    ++ "\n\n"
    ++ "${tests.bLevel}"
    ++ "\n\n"
    ++ "${tests.cLevel}"
    ++ "\n\n"
    ++ "${tests.dLevel}"
    ++ "\n\n\n"
