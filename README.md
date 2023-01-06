# mini-state

This is a SQL like abstraction on top of a JSON file.

I use it to build haskell programs whose state is one or more list of Aeson objects.


```
data Loader a b c = ...
```

The loader represents how to load a "table" of type `a`, using a linker of type `a b c`.

```
type Linker a b c =
```

The linker is useful when your haskell in-memory when you have less normalized sql data. If your type `FullType` references on an ID in another table `SimpleType`, the linker will be used to specify which ID depending on the partial type `PartialType`.
e.g.

```
someLinker :: Linker SimpleType PartialType FullType
```

The written out type declaration of Linker looks like

```
type Linker a b c = Maybe [a] -> b -> Either String c
```

To contruct a linker, you need a list of all objects of type `SimpleType`
(probably from your previous query), and a partial object `PartialType`
which which references `FullType`. A minimal implementation could look like this:

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
