defmodule Mazes.VnuHTMLMessageFilter do
  @behaviour Vnu.MessageFilter

  @impl Vnu.MessageFilter
  def exclude_message?(%Vnu.Message{message: message}) do
    # Those errors are caused by the CSRF meta tag (`csrf_meta_tag()`) present in the layout
    patterns_to_ignore = [
      ~r/A document must not include more than one “meta” element with a “charset” attribute./,
      ~r/Attribute “(.)*” not allowed on element “meta” at this point./
    ]

    Enum.any?(patterns_to_ignore, &Regex.match?(&1, message))
  end
end
