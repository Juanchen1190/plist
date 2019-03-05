defmodule Plist do
  @moduledoc """
  The entry point for encode/decode plist data.
  """

  @type plist_data :: any

  @doc """
  Parse the data provided as an XML or binary format plist,
  depending on the header.
  """
  @spec decode(String.t()) :: plist_data
  def decode(data) do
    case String.slice(data, 0, 8) do
      "bplist00" -> Plist.Binary.decode(data)
      "<?xml ve" -> Plist.XML.decode(data)
      _ -> raise "Unknown plist format"
    end
  end

  @doc """
  Encode data into XML format plist.
  """
  @spec encode(plist_data, Keyword.t()) :: String.t()
  def encode(data, config \\ []) when is_list(config) do
    Plist.Encoder.encode(data, config)
  end

  @doc false
  @deprecated "Use decode/1 instead"
  @since "0.0.6"
  def parse(data) do
    decode(data)
  end
end
