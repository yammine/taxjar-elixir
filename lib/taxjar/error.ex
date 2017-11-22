defmodule Taxjar.Error do
  defstruct [:code, :message]

  @type t :: %__MODULE__{}
end
