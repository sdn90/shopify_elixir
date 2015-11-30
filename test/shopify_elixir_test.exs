defmodule ShopifyElixirTest do
  use ExUnit.Case
  doctest Shopify

  test "it should validate requests from Shopify" do

    config = %{ "shop": "shop-some.myshopify.com", "secret": "hush" }
    params = %{
      "shop": "some-shop.myshopify.com",
      "code": "a94a110d86d2452eb3e2af4cfb8a3828",
      "timestamp": "1337178173",
      "signature": "6e39a2ea9e497af6cb806720da1f1bf3",
      "hmac": "2cb1a277650a659f1b11e92a4a64275b128e037f2c3390e3c8fd2d8721dac9e2",
    }

    assert Shopify.signature_valid?(config, params) == true
  end

  test "it should validate webhook requests" do
    config = %{ "shop": "shop-some.myshopify.com", "secret": "hush" }
    body = "{}"

    assert Shopify.webhook_valid? == true
  end

  test "it should validate proxy requests" do
    config = %{ "shop": "shop-some.myshopify.com", "secret": "hush" }
    params = %{
      "extra": ["1", "2"],
      "shop": "shop-name.myshopify.com",
      "path_prefix": "/apps/awesome_reviews",
      "timestamp": "1317327555",
      "signature": "a9718877bea71c2484f91608a7eaea1532bdf71f5c56825065fa4ccabe549ef3"
    }
    assert Shopify.proxy_signature_valid?(config, params) == true
  end
end
