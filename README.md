# Plist

An Elixir library to parse files in Apple's binary property list format.

## Installation

Add plist to your list of dependencies in `mix.exs`:

    def deps do
      [{:plist, git: "https://github.com/Juanchen1190/plist.git"}]
    end

## Usage

### Decoding

    ```elixir
    plist = File.read!(path) |> Plist.decode()
    ```

### Encoding

    ``` elixir
    "string data" |> Plist.encode()
    3 |> Plist.encode()
    4.0 |> Plist.encode()
    [1,2,3] |> Plist.encode()
    %{key: "value"} |> Plist.encode()
    ```
