module Id exposing
    ( Id
    , from, to
    , encode, decoder
    )

{-| An `Id` type that leverages the type system (thanks to [phantom types](https://wiki.haskell.org/Phantom_type))
to ensure that it refers to the right resource.

For example, if your application handles users with integer-based IDs, and articles with string-based IDs,
you could define them as such:

    type User
        = User
            { id : UserID
            , name : String
            }

    type Article
        = Article
            { id : ArticleID
            , title : String
            }

    type alias UserID =
        Id Int User

    type alias ArticleID =
        Id String Article


# The Id type

@docs Id


# Conversions

@docs from, to


# Serialization

@docs encode, decoder

-}

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)


{-| The `Id a resource` type handles IDs whose representation are of type `a`
that refers to resources of type `resource`.
-}
type Id a resource
    = Id a


{-| Make an `Id` from its representation.

    userID : Id Int User
    userID =
        Id.from 5

    articleID : Id String Article
    articleID =
        Id.from "e4edf8a"

-}
from : a -> Id a resource
from value =
    Id value


{-| Extract the raw representation from an `Id`.

    Id.to userID == 5

    Id.to articleID == "e4edf8a"

-}
to : Id a resource -> a
to (Id value) =
    value


{-| Encode an `Id`.

    encodeUserID : Id Int User -> Value
    encodeUserID =
        Id.encode Json.Encode.int

    encodeArticleID : Id String Article -> Value
    encodeArticleID =
        Id.encode Json.Encode.string

-}
encode : (a -> Value) -> Id a resource -> Value
encode encode_ (Id value) =
    encode_ value


{-| Decode an `Id`.

    userIDDecoder : Decoder (Id Int User)
    userIDDecoder =
        Id.decoder Json.Decode.int

    articleIDDecoder : Decoder (Id String Article)
    articleIDDecoder =
        Id.decoder Json.Decode.string

-}
decoder : Decoder a -> Decoder (Id a resource)
decoder decoder_ =
    Json.Decode.map Id decoder_
