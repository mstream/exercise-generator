let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/package.dhall sha256:eb693342eb769f782174157eba9b5924cf8ac6793897fc36a31ccbd6f56dafe2

let Random = ./random.dhall

let Operator = { aFactor : Natural, bFactor : Natural, symbol : Text }

let Arguments = { m : Natural, n : Natural }

let OperatorGenerationResult =
      { aPrior : Operator, bPrior : Operator, cPrior : Operator }

let TestGenerationResult =
      { aLevel : Text, bLevel : Text, cLevel : Text, dLevel : Text }

let calculate
    : Operator → Arguments → Natural
    = λ(operator : Operator) →
      λ(arguments : Arguments) →
        operator.aFactor * arguments.m + operator.bFactor * arguments.n

let showFormula
    : Operator → Text → Text → Text
    = λ(operator : Operator) →
      λ(mText : Text) →
      λ(nText : Text) →
        let aText = Prelude.Natural.show operator.aFactor

        let bText = Prelude.Natural.show operator.bFactor

        in  "${aText}${mText} + ${bText}${nText}"

let showOperation
    : Operator → Arguments → Text
    = λ(operator : Operator) →
      λ(arguments : Arguments) →
        let mText = Prelude.Natural.show arguments.m

        let nText = Prelude.Natural.show arguments.n

        in  showFormula operator (" * " ++ mText) (" * " ++ nText)

let generateTests =
      λ(seed : Natural) →
      λ(values : List Natural) →
      λ(aPriorOperator : Operator) →
      λ(bPriorOperator : Operator) →
      λ(cPriorOperator : Operator) →

        let aLevelValueARandRes = 
          Random.choose Natural seed 0 values
        let aLevelValueAText = 
          Prelude.Natural.show aLevelValueARandRes.chosenElement

        let bLevelValueARandRes = 
          Random.choose Natural aLevelValueARandRes.newSeed 0 aLevelValueARandRes.rest
        let bLevelValueAText = 
          Prelude.Natural.show bLevelValueARandRes.chosenElement

        let bLevelValueBRandRes = 
          Random.choose Natural bLevelValueARandRes.newSeed 0 bLevelValueARandRes.rest
        let bLevelValueBText = 
          Prelude.Natural.show bLevelValueBRandRes.chosenElement

        let bLevelValueCRandRes = 
          Random.choose Natural bLevelValueBRandRes.newSeed 0 bLevelValueBRandRes.rest
        let bLevelValueCText = 
          Prelude.Natural.show bLevelValueCRandRes.chosenElement

        let aLevel = "single value: " ++ "\n" ++ "${aLevelValueAText}" 

        let bLevel = "expression with one operator: " ++ "\n" 
          ++ "${bLevelValueAText} ${aPriorOperator.symbol} ${bLevelValueBText} ${aPriorOperator.symbol} ${bLevelValueCText}"

        let cLevel = "cLevel" ++ "\n" ++ "TODO - mixed operators"

        let dLevel = "dLevel" ++ "\n" ++ "TODO - mixes operators with parentheses"

        in  { aLevel, bLevel, cLevel, dLevel }

let generateOperators
    : Natural → List Text → List Natural → OperatorGenerationResult
    = λ(seed : Natural) →
      λ(symbols : List Text) →
      λ(factors : List Natural) →
        let aPriorSymRandRes = Random.choose Text seed "" symbols

        let bPriorSymRandRes =
              Random.choose
                Text
                aPriorSymRandRes.newSeed
                ""
                aPriorSymRandRes.rest

        let cPriorSymRandRes =
              Random.choose
                Text
                bPriorSymRandRes.newSeed
                ""
                bPriorSymRandRes.rest

        let aPriorAFactRandRes =
              Random.choose Natural cPriorSymRandRes.newSeed 0 factors

        let aPriorBFactRandRes =
              Random.choose
                Natural
                aPriorAFactRandRes.newSeed
                0
                aPriorAFactRandRes.rest

        let bPriorAFactRandRes =
              Random.choose
                Natural
                aPriorBFactRandRes.newSeed
                0
                aPriorBFactRandRes.rest

        let bPriorBFactRandRes =
              Random.choose
                Natural
                bPriorAFactRandRes.newSeed
                0
                bPriorAFactRandRes.rest

        let cPriorAFactRandRes =
              Random.choose
                Natural
                bPriorBFactRandRes.newSeed
                0
                bPriorBFactRandRes.rest

        let cPriorBFactRandRes =
              Random.choose
                Natural
                cPriorAFactRandRes.newSeed
                0
                cPriorAFactRandRes.rest

        in  { aPrior =
              { symbol = aPriorSymRandRes.chosenElement
              , aFactor = aPriorAFactRandRes.chosenElement
              , bFactor = aPriorBFactRandRes.chosenElement
              }
            , bPrior =
              { symbol = bPriorSymRandRes.chosenElement
              , aFactor = bPriorAFactRandRes.chosenElement
              , bFactor = bPriorBFactRandRes.chosenElement
              }
            , cPrior =
              { symbol = cPriorSymRandRes.chosenElement
              , aFactor = cPriorAFactRandRes.chosenElement
              , bFactor = cPriorBFactRandRes.chosenElement
              }
            }

let symbols
    : List Text
    = [ "@", "#", "\$", "&", "?" ]

let factors
    : List Natural
    = Prelude.List.drop 2 Natural (Prelude.Natural.enumerate 10)

let values
    : List Natural
    = Prelude.List.drop 2 Natural (Prelude.Natural.enumerate 100)

let seed
    : Natural
    = 663053

let operators
    : OperatorGenerationResult
    = generateOperators seed symbols factors

let tests
    : TestGenerationResult
    = generateTests
        seed
        values
        operators.aPrior
        operators.bPrior
        operators.cPrior

in  { Operator
    , Arguments
    , calculate
    , showFormula
    , showOperation
    , operators
    , tests
    }
