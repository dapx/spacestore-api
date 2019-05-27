
defmodule SpacestoreWeb.StoreImagesResolver do
  alias Spacestore.Business
  alias SpacestoreWeb.ErrorHelpers

  def create(args,  %{context: %{current_user: current_user}}) do
    store = Business.get_store(args.store_id)
    cond do
      store == nil -> {:error, "Store not found"}
      store.owner_id == current_user.id -> create_store_image(args, current_user)
      true -> {:error, "User doesn't have this resource associated"}
    end
  end

  def create(_args, _info) do
    {:error, "Not Authorized"}
  end

  defp create_store_image(args, current_user) do
    case Business.create_store_images(args) do
      {:ok, store_images} -> {:ok, store_images}
      {:error, error} ->
        {:error, ErrorHelpers.error_from_changeset_to_string(error)}
      error ->
        {:error, "Could not create image"}
    end
  end
end