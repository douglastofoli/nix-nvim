{ lib, ... }:
let
  inherit (builtins) readDir attrNames;
  inherit (lib) hasSuffix;

  root = ../modules;

  recurse =
    dir:
    let
      entries = readDir dir;
      names = attrNames entries;
    in
    builtins.concatLists (
      map
        (name:
          let
            path = dir + "/${name}";
            kind = entries.${name};
          in
          if kind == "directory" then
            recurse path
          else if kind == "regular" && hasSuffix ".nix" name then
            [ path ]
          else
            [ ]
        )
        names
    );
in
{
  imports = map import (recurse root);
}
