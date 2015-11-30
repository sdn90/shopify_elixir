defmodule Shopify do
  @doc """
  Validate requests from Shopify

  Compares the HMAC digest generated using the query parameters with
  the HMAC given in the query parameters.
  """
  def signature_valid?(config, params) do
    sorted_params = params
      |> Map.drop([:hmac, :signature])
      |> Map.to_list
      |> List.keysort(0)
      |> Enum.map_join("&", fn({k, v}) -> "#{k}=#{v}" end)

    sha = :crypto.hmac(:sha256, config[:secret], sorted_params)
      |> Base.encode16
      |> String.downcase

    params[:hmac] == sha
  end

  @doc """
  Validate Webhook requests

  Compares the HMAC generated from the raw JSON body with the given HMAC
  """
  def webhook_valid?(config, json, hmac) do
    digest = :crypto.hmac(:sha256, config[:secret], json)
      |> Base.encode64

    digest == hmac
  end

  @doc """
  Validate Application Proxy requests

  Compares the HMAC digest generated using the query parameters with
  the HMAC given in the query parameters.
  """
  def proxy_signature_valid?(config, params) do
    sorted_params = params
      |> Map.drop([:signature])
      |> Map.to_list
      |> List.keysort(0)
      |> Enum.map_join("", fn({k, v}) ->
        if Kernel.is_list(v) do
          "#{k}=#{Enum.join(v, ",")}"
        else
          "#{k}=#{v}"
        end
      end)

      digest = :crypto.hmac(:sha256, config[:secret], sorted_params)
        |> Base.encode16
        |> String.downcase

      digest == params[:signature]
    end
end
