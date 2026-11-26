local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/gSk")
local module2 = require("@luauforge/bundled/gxM")
local module3 = require("@luauforge/bundled/dPU")
require("@luauforge/bundled/dPs")

local module4 = require("@luauforge/deferred/gOY")

return (React.forwardRef(function(props, ref)
	local v5 = useStyle()

	local v6 = module2({
		itemsOnSaleHeading = "Feature.Catalog.Heading.ItemsOnSale",
		availableItemsHeading = "Feature.Catalog.Heading.AvailableItems",
		cannotBeResold = "Feature.Catalog.Message.CannotBeResold"
	})

	local v7 = RoactGamepad.useRefCache()
	local children = {}

	for k, item in props.items do
		local id = item.id
		local createElement = React.createElement
		local v9 = {
			itemId = props.itemId,
			itemType = props.itemType,
			title = item.title,
			buyPrice = item.buyPrice,
			salePrice = item.salePrice,
			isOnHold = item.isOnHold,
			resaleRestriction = props.resaleRestriction,
			isOnSale = item.isOnSale,
			restrictionTypes = props.restrictionTypes,
			layoutOrder = k,
			onActivated = function()
				props.onItemActivated(item.id, item.isOnSale)
			end,
			ref = 0,
			NextSelectionUp = 0,
			NextSelectionDown = 0
		}

		local v10 = if module4() then v7[k] else nil
		v9.ref = v10
		local v11 = if module4() and k > 1 then v7[k - 1] else nil
		v9.NextSelectionUp = v11
		local v12 = if module4() and k < #props.items then v7[k + 1] else nil
		v9.NextSelectionDown = v12
		children[id] = createElement(module, v9)
	end

	local createElement = React.createElement
	local v8 = not module4() and "Frame" or focusable.Frame
	local v9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ref = 0,
		defaultChild = 0,
		restorePreviousChildFocus = 0
	}

	if not module4() then
		ref = nil
	end

	v9.ref = ref
	local v10 = if module4() then v7[1] else nil
	v9.defaultChild = v10
	v9.restorePreviousChildFocus = module4() and true or nil
	return createElement(v8, v9, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ResaleRestrictionLabel = props.resaleRestriction == module3.ResaleRestriction.Disabled and React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v6.cannotBeResold,
			FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
			TextSize = v5.Font.BaseSize * v5.Font.Header2.RelativeSize,
			TextColor3 = v5.Theme.TextEmphasis.Color,
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}),
		Rows = React.createElement(React.Fragment, nil, children)
	})
end))
