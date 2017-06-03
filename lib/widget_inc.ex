defmodule Result do
  @type t :: {:ok, term} | {:error, term}
end

defmodule ValidationError do
  defstruct [:property_name, :error_description]

  @type t :: %{
    property_name: String.t,
    error_description: String.t
  }
end

defmodule WidgetInc do
  defmodule OrderTaking.Domain do

    # Product code related
    @type widget_code :: String.t
      # constraint: starting with "W" then 4 digits
    @type gizmo_code :: String.t
      # constraint: starting with "G" then 3 digits
    @type product_code :: widget_code | gizmo_code

    # Order Quantity related
    @type unit_quantity :: integer
    @type kilogram_quantity :: integer
    @type order_quantity :: unit_quantity | kilogram_quantity

    @type order_id :: :undefined

    @type customer_info :: :undefined
    @type shipping_address :: :undefined
    @type billing_address :: :undefined
    @type price :: :undefined
  end
end

defmodule WidgetInc.OrderTaking.Domain.PlacedOrder do
  import WidgetInc.OrderTaking.Domain

  @type t :: %{
    order_id: Domain.order_id,
    customer_info: Domain.order_info,
    shipping_address: Domain.shipping_address,
    billing_address: Domain.billing_address,
    order_lines: [OrderLine.t],
    total_price: Domain.price
  }

  defmodule OrderLine do
    import WidgetInc.OrderTaking.Domain

    @type t :: %{
      product_code: Domain.product_code,
      order_quantity: Domain.order_quantity,
      price: Domain.price
    }
  end
end

defmodule WidgetInc.OrderTaking.Domain.OrderForm do
  @type t :: %{
    order_id: integer,
    customer_info: :undefined,
    shipping_address: :undefined,
    billing_address: :undefined,
    order_lines: OrderLine.t,
    total_price: :undefined
  }

  defmodule OrderLine do
    @type t :: %{
      product_code: String.t,
      order_quantity: :integer,
      price: :undefined
    }
  end
end

defmodule WidgetInc.OrderTaking.Domain.Behaviour do
  import WidgetInc.OrderTaking.Domain

  defmodule PlacedOrderAcknowledgement do
    @type t :: %{
      order: Domain.PlacedOrder.t,
      letter: AcknowledgementLetter.t
    }
  end

  defmodule AcknowledgementLetter do
    @type t :: %{}
  end

  defmodule PlacedOrderError, do: @type t :: [ValidationError.t]

  # @spec place_order(Domain.OrderForm) ::
  #       {:ok, PlacedOrderAcknowledgement} | {:error, PlacedOrderError}
end
