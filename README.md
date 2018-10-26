# Elm ID

[![Build Status](https://travis-ci.org/Punie/elm-id.svg?branch=master)](https://travis-ci.org/Punie/elm-id)

## Why?

Different resources may have different representation for an ID (such as `String` or `Int` or even a custom data type representing an hexadecimal string of fixed length), but two very different resources may also both use a single representation.

This package provides an `Id` type that leverages the type system to reference your resources in the most type-safe way possible.

## An example

Imagine an application that handles three types of resources:

- users
- articles
- comments

Users are referenced by string-based IDs and both articles and comments are referenced by integer-based IDs. However, using the raw `Int` type to identify articles and comments would be a major foot-gun as an ID of `5` might represent either some article or some totally unrelated comment and there is nothing you can do to prevent developers (including yourself from the future) to misuse an article ID to try to index a comment.

With this package, the solution becomes quite simple and elegant.

```elm
type User =
    User
        { id : UserID
        , name : String
        }


type Article =
    Article
        { id : ArticleID
        , title : String
        , comments : List Comment
        }


type Comment =
    Comment
        { id : CommentID
        , content : String
        }


type alias UserID =
    Id String User


type alias ArticleID =
    Id Int Article


type alias CommentID =
    Id Int Comment
```

It would them become impossible to try to index any of those types based on the wrong IDs.

```elm
articleId : ArticleID
articleId = Id.from 5


commentId : CommentID
commentId = Id.from 5


{- Let's imagine our Comment API exposes the following function and list of comments:

    getComment : CommentID -> List Comment -> Maybe Comment
    comments : List Comment

-}


getComment articleId comments -- Would **NOT** compile
getComment commentId comments -- Would compile without issue even though the underlying ID value is the same
```

## Disclaimer

Please note that our resource types `User`, `Article` and `Comment` are **NOT** `type aliase`s but custom data types in their own rights. This is a requirement! Should you try to define your `User` type as such :

```elm
type alias User =
    { id : UserID
    , name : String
    }
```

the compiler will complain that you have a circular definition between your `User` record and your `UserID` definition.

This is very much intentional! This API was designed to enforce best practices when it comes to resources which most likely originate from outside your Elm application.

I firmly believe that record types should be `type alias`ed **only** when your Elm application has full, exclusive control on those types (grouping configuration values for a `view` function for example).
On the other hand, data that your application do not have exclusive ownership should be guarded behind an opaque data constructor and moved to its own module. Said module should then expose a set of helper functions for manipulating this data (accessing fields, mutating fields, rendering, validation, and so on).

## Contributing

Feedback on this API and the patterns it enforces are very much welcome! Feel free to open an issue for discussing your use case and I would gladly considerate any potential improvement.

## Licence

[BSD-3-Clause](LICENSE) © Hugo Saracino
