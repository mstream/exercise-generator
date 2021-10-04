let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/package.dhall sha256:eb693342eb769f782174157eba9b5924cf8ac6793897fc36a31ccbd6f56dafe2

let quotient =
      https://github.com/jcaesar/dhall-div/releases/download/1/quotient.dhall sha256:d6a994f4b431081e877a0beac02f5dcc98f3ea5b027986114487578056cb3db9

let div
    : Natural → Natural → Natural
    = λ(n : Natural) → λ(m : Natural) → (quotient n m).q

let modulo
    : Natural → Natural → Natural
    = λ(a : Natural) → λ(b : Natural) → Prelude.Natural.subtract (b * div a b) a

let rollSeed
    : Natural → Natural
    = λ(seed : Natural) → modulo (seed + 31) 1000000

let choose
    : ∀(a : Type) →
      Natural →
      a →
      List a →
        { chosenElement : a, newSeed : Natural, rest : List a }
    = λ(a : Type) →
      λ(seed : Natural) →
      λ(default : a) →
      λ(list : List a) →
        let listLength = Prelude.List.length a list

        let index = modulo seed listLength

        let chosenElement =
              Prelude.Optional.default
                a
                default
                (Prelude.List.index index a list)

        let elementsBefore = Prelude.List.take index a list

        let elementsAfter = Prelude.List.drop (index + 1) a list

        in  { chosenElement
            , newSeed = listLength + rollSeed seed
            , rest = elementsBefore # elementsAfter
            }

in  { choose }
