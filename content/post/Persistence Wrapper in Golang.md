---
title: Persistence Wrapper in Golang
date: 2021-04-04
lastmod: 2021-04-04
---

# Persistence Wrapper in Golang

When working with databases, there is typically a need to deal with record context information, required for persistence, in addition to the domain model entities' natural attributes.  For example, some databases require a synthetic key field and some database operations may require an optimistic concurrency token field.  This article discusses different approaches to address this need, focusing on Go but also including, for comparison, brief references to approaches used with JVM languages.

## Approaches

There are several general ways to address the need to handle such additional record context information required for persistence purposes.

1. Define a `RecCtx` data type that encapsulates the additional persistence context information.  Data access functions (***DAFs***) use this data type as a parameter and/or return types, together with normal domain entity data types.
2. Define a concrete data structure Pw[T] (using Go generics notation) that encapsulates both the persistence record context information and the domain entity type T (or its corresponding pointer type).  DAFs use this type as parameter and/or return types, instead of the normal domain entity data types.
3. Define a wrapper interface type Pw[T] that encapsulates both the persistence record context information and the domain entity type T.  This is similar to 3 above but uses an interface instead of a struct.
4. For each domain entity type Xyz, define an interface IXyz that is implemented by the domain entity type and define an augmented concrete type that also implements the interface IXyz and contains both the domain entity attributes and the persistence record context information.  DAFs use this type as parameter and/or return types, instead of the normal domain entity data types.
5. (This approach is not applicable to Go but is used in JVM languages.) Use bytecode weaving techniques to add persistence capabilities to existing domain model classes.  DAFs use the normal entity data types (augmented behind the scenes by bytecode weaving) as parameter and/or return types.
6. Include persistence context fields in the domain entity types.  DAFs use the domain entity types directly and business functions simply ignore the persistence information in the domain entity types.

This article will focus on approaches 1 and 2.  The other approaches will be briefly discussed at the end.

Approaches 1-4 are particularly important for systems where the same entity type may be accessed using multiple database technologies (polyglot persistence).  For example, one service may persist entity Xyz using Cosmos DB and another service may use MS SQL Server to store the same entity.  Approaches 5 and 6 cannot cope effectively with such polyglot persistence use cases.

## Approach 1

The use of approach 1 in Go looks like this:

```go
// RecCtx is a type that holds platform-specific database record context information,
// e.g., an optimistic locking token and/or a record ID.  DAFs may accept this type as
// a parameter or return this type, together with domain entity types.
type RecCtx interface{}

// Example A1 -- DAF signature
func ArticleUpdateDaf(article Article, rc RecCtx) (Article, RecCTx, error)

// Example A2 -- usage
// With separation of entity and RecCtx
article, recCtx, err := ArticleReadDaf(name)
if err != nil { return err }
article = SomeBusinessFunctionBf(article)
article, recCtx, err = ArticleUpdateDaf(article, recCtx)
```

This approach promotes code that is clear and reasonably concise.

## Approach 2

This approach uses the above described type `RecCtx` within a struct.  The use of approach 2 in Go looks like this:
```go
// PW wraps a domain entity and RecCtx together.  It can be returned or accepted by a 
// DAF as an alternative to using RecCtx and the entity type separately.  This is most
// useful when there are multiple entity objects involved as inputs or outputs of a DAF.
// The type parameter T can either be a domain entity type or the pointer type thereof,
// depending on whether the DAF returns / receives by value or by pointer.
type Pw[T any] struct {
    RecCtx
    Entity T
}

// Helper method
func (s Pw[T]) Copy(t T) Pw[T] {
    s.Entity = t
    return s
}

// Example B1 -- prefer the style of Example 1 above
func ArticleUpdateDaf(pwArticle Pw[Article]) (Pw[Article], error)

// Example B2 -- usage where separating entity and RecCtx (see A2 above) would be 
// preferable
pwArticle, err := ArticleReadDaf(name)
if err != nil { return err }
article := pwArticle.Entity
article = SomeBusinessFunctionBf(article)
pwArticle = pwArticle.Copy(article)
pwArticle, err = ArticleUpdateDaf(pwArticle)

// Example B3 -- here it makes sense to use Pw
func ReadRecentUsagesDaf() ([]Pw[Usage], error)
```

As the examples show, code using this approach can be more verbose.  This approach makes the most sense in situations where multiple records are returned.

#### *Side note on value versus pointer semantics*

*Our philosophy is to define entity types that are relatively cheap to pass by value and to use value semantics for all function parameters and method receivers.  Thus, most of our functions do not mutate their receivers or parameters.  This makes for code that is easier to understand and where mutations are localised to explicit assignments.  Not exactly pure functional programming, but a practical idiom for an imperative language like Go.  It also reduces garbage collection pressure, often resulting in faster execution.*

*In most cases, this is achievable.  In cases where the entity type has fields that can be large strings, we can either use slice fields or `*string` fields as alternatives, and thus keep the cost of passing the entity by value low.  There is no need to worry about slice and map fields as Go already takes care of making them cheap to copy.  In cases where there is no practical way to design the entity so that passing it by value is cheap, we can fall back on using pointers, e.g., a DAF can return a pointer and the type T in Pw[T] can be a pointer type.*

## Other approaches considered

#### Approach 3

This alternative approach looks like:

```go
type Pw[T any] interface {
    Entity() T       // equivalent to the Entity field in the above struct
    Copy(t T) Pw[T]  // creates a new instance with the same RecCtx and t as the T part
}
```

This alternative was tried and abandoned because:

- The resulting code at the point of usage is no cleaner than when using the struct version of Pw[T].
- The interface has to be implemented by some struct type S0 anyway and the code required to implement the required methods on S0 to implement the interface would be no easier than the code required to produce the struct version of Pw[T] from S0.

#### Approach 4

This approach is attractive in languages like Kotlin and Scala that support interfaces with properties and clean notation for interface overrides with minimal coding.  In the case of Go, it makes the code more unpleasant, with a proliferation of "entity.Field()" calls instead of "entity.Field".  In addition, copy methods have to be implemented for these interfaces and the business functions have to use the interface copy methods as well as the field methods.  In summary , approaches 1 and 2 are simpler in Go (and possibly in Kotlin and Scala too).

#### Approach 5

This approach is not applicable in Go.  For people who like ORMs (the author not among them), this approach can work fine, but there is quite a bit of bytecode manipulation and other "magic" involved.  This approach does not work well for systems where the same entity type may be accessed using multiple database technologies.

#### Approach 6

This quick-and-dirty approach ignores separation of concerns -- it conflates database and domain model concerns into a single data type.  This approach should be avoided for large, complex systems, but it can be effective for simple services/applications.  This approach does not work well for systems where the same entity type may be accessed using multiple database technologies.