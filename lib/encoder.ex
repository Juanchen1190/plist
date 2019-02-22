defmodule Plist.Encoder do

  @indent "\t"

  def encode(data) do
    wrap(data)
  end

  def wrap(data) do
    """
    <?xml version="1.0" encoding="UTF-8"?>\n
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n
    <plist version="1.0">\n
    #{plist_node(data, "")}
    </plist>\n
    """
  end

  # Map
  def plist_node(map, indent) when is_map(map) do
    if Enum.empty?(map) do
      indent <> "<dict/>\n"
    else
      break_tag("dict", indent, Enum.reduce(map, "", fn {key, value}, acc ->
            acc <> tag("key", indent <> @indent, key, []) <> plist_node(value, indent <> @indent)
          end), [])
    end
  end

  # List
  def plist_node([], indent) do
    indent <> "<array/>\n"
  end

  def plist_node(list, indent) when is_list(list) do
    break_tag("array", indent, Enum.reduce(list, "", fn item, acc ->
          acc <> plist_node(item, indent <> @indent)
        end), [])
  end

  # String
  def plist_node(string, indent) when is_binary(string) do
    tag("string", indent, string, [])
  end

  # Atom
  def plist_node(atom, indent) when is_atom(atom) do
    tag("string", indent, to_string(atom), [])
  end

  # Boolean
  def plist_node(bool, indent) when is_boolean(bool) do
    indent <> "<#{bool}/>\n"
  end

  # NaiveTime
  def plist_node(%DateTime{} = date, indent) do
    tag("date", indent, DateTime.to_string(date), [])
  end

  def plist_node(%NaiveDateTime{} = date, indent) do
    tag("date", indent, NaiveDateTime.to_string(date), [])
  end

  # Integer
  def plist_node(integer, indent) when is_integer(integer) do
    tag("integer", indent, integer, [])
  end

  # Float
  def plist_node(float, indent) when is_float(float) do
    tag("real", indent, float, [])
  end

  # --

  defp tag(type, indent, content, options) do
    "#{indent}<#{type}>#{content |> to_string}</#{type}>\n"
  end

  defp break_tag(type, indent, content, options) do
    "#{indent}<#{type}>\n#{content |> to_string}#{indent}</#{type}>\n"
  end
end
