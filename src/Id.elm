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
        Id String User

    type alias ArticleID =
        Id Int Article


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

    userID : Id String User
    userID =
        Id.from "e4edf8a"

    articleID : Id Int Article
    articleID =
        Id.from 5

-}
from : a -> Id a resource
from value =
    Id value


{-| Extract the raw representation from an `Id`.

    Id.to userID == "e4edf8a"

    Id.to articleID == 5

-}
to : Id a resource -> a
to (Id value) =
    value


{-| Encode an `Id`.

    encodeUserID : Id String User -> Value
    encodeUserID =
        Id.encode Json.Encode.string

    encodeArticleID : Id Int Article -> Value
    encodeArticleID =
        Id.encode Json.Encode.int

-}
encode : (a -> Value) -> Id a resource -> Value
encode encode_ (Id value) =
    encode_ value


{-| Decode an `Id`.

    userIDDecoder : Decoder (Id String User)
    userIDDecoder =
        Id.decoder Json.Decode.string

    articleIDDecoder : Decoder (Id Int Article)
    articleIDDecoder =
        Id.decoder Json.Decode.int

-}
decoder : Decoder a -> Decoder (Id a resource)
decoder decoder_ =
    Json.Decode.map Id decoder_
