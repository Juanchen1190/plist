defmodule Plist.Encoder do

  @indent "\t"

  def encode(data) do
    wrap(data)
  end

  def wrap(data) do
    content = plist_node(data, "", "")
    |> String.trim

    """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    #{content}
    </plist>\n
    """
  end

  # Map
  def plist_node(map, indent, total) when is_map(map) do
    if Enum.empty?(map) do
      total <> indent <> "<dict/>\n"
    else
      total <> break_tag("dict", indent, Enum.reduce(map, "", fn {key, value}, acc ->
            plist_node(value, indent <> @indent, acc <> tag("key", indent <> @indent, key, []))
          end), [])
    end
  end

  # List
  def plist_node([], indent, total) do
    total <> indent <> "<array/>\n"
  end

  def plist_node(list, indent, total) when is_list(list) do
    total <> break_tag("array", indent, Enum.reduce(list, "", fn item, acc ->
          plist_node(item, indent <> @indent, acc)
        end), [])
  end

  # String
  def plist_node(string, indent, total) when is_binary(string) do
    total <> tag("string", indent, string, [])
  end

  # Atom
  def plist_node(atom, indent, total) when is_atom(atom) do
    total <> tag("string", indent, to_string(atom), [])
  end

  # Boolean
  def plist_node(bool, indent, total) when is_boolean(bool) do
    total <> indent <> "<#{bool}/>\n"
  end

  # NaiveTime
  def plist_node(%DateTime{} = date, indent, total) do
    total <> tag("date", indent, DateTime.to_string(date), [])
  end

  def plist_node(%NaiveDateTime{} = date, indent, total) do
    total <> tag("date", indent, NaiveDateTime.to_string(date), [])
  end

  # Integer
  def plist_node(integer, indent, total) when is_integer(integer) do
    total <> tag("integer", indent, integer, [])
  end

  # Float
  def plist_node(float, indent, total) when is_float(float) do
    total <> tag("real", indent, float, [])
  end

  # --

  defp tag(type, indent, content, _options) do
    "#{indent}<#{type}>#{content |> to_string}</#{type}>\n"
  end

  defp break_tag(type, indent, content, _options) do
    "#{indent}<#{type}>\n#{content |> to_string}#{indent}</#{type}>\n"
  end
end
