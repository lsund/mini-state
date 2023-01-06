# mini-state

This is a SQL like abstraction on top of a JSON file.

I use it to build haskell programs whose state is one or more list of Aeson
objects.

```
data Loader a b c = ...
```

The loader represents how to load a "table" of type `c`, based on table `b` and
table `a`.

```
type Linker a b c =
```

The linker represents the reference between two tables. If your type `FullType`
references tables `SimpleType` and `PartialType`, then the type declaration
would be:

```
someLinker :: Linker SimpleType PartialType FullType
```

You implement the linker by specifying how to create `FullType` based
on the full list of `SimpleType` and a single `PartialType`. Consider the
full type Linker:

```
type Linker a b c = Maybe [a] -> b -> Either String c
```

 A minimal implementation could look like this:

```

data SimpleType = { _name :: String, _meta :: String }

data PartialType = { _value :: Int, _ref :: String }

data FullType = { _description :: String, _simpleType :: SimpleType }

someLinker :: Linker SimpleType PartialType FullType
someLinker (Just all_simple_objects) partial_type =
  let chosen_one = find (\simple_obj -> name simple_obj == ref partial) all_simple_objects
  Right $ FullType "Some description" chosen_one
```

## TODO

extractor

-- A specification how to unload a table of type `b`.
-- `b` is generated from `a` by specifying an extractor
