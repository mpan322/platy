{ pkgs ? import <nixpkgs> { } }: 
pkgs.mkShell {
  packages = with pkgs; [
    gleam 
    erlang
    rebar3
  ];
}
