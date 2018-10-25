# Elm ID

[![Build Status](https://travis-ci.org/Punie/elm-id.svg?branch=master)](https://travis-ci.org/Punie/elm-id)

## Why?

Different resources may have different representation for an ID (such as `String` or `Int`), but two very different
resources may also both use a single representation.

This package provides an `Id` type that leverages the type system to reference your resources in the most type-safe way
imaginable.

## Example

Imagine an application that handles three types of resources: users, articles and comments. Users are referenced
by string-based IDs and both articles and comments are referenced by integer-based IDs. However, using the raw Int type to
identify articles and comments would be a major foot-gun as an ID of `5` might represent an article or a comment and there is
nothing you can do to prevent developers to misuse an article ID to reference a comment.

With this package, the solution becomes quite simple and elegant:

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

## Licence

[BSD-3-Clause](LICENSE) © Hugo Saracino
