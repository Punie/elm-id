module Tests.Id exposing (suite)

import Expect
import Fuzz exposing (Fuzzer, int, string)
import Id
import Test exposing (Test, describe, fuzz)


suite : Test
suite =
    describe "Id"
        [ fuzz int "[Int] from << to" <|
            \n ->
                n
                    |> Id.from
                    |> Id.to
                    |> Expect.equal n
        , fuzz string "[String] from << to" <|
            \str ->
                str
                    |> Id.from
                    |> Id.to
                    |> Expect.equal str
        ]
