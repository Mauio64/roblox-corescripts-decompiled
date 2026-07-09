local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local Modules = CoreGui.RobloxGui.Modules
local OwnedItemRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemOwnershipPage.OwnedItemRow)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

require(Modules.AvatarExperience.Common.Types)

local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 45
	-- upvalues: useStyle (copy), useLocalization (copy), RoactGamepad (copy), React (copy), OwnedItemRow (copy), GetFFlagL2ControllerSupport (copy), Focusable (copy), CatalogConstants (copy)
	local v14 = useStyle()
	local v15 = useLocalization({
		itemsOnSaleHeading = "Feature.Catalog.Heading.ItemsOnSale",
		availableItemsHeading = "Feature.Catalog.Heading.AvailableItems",
		cannotBeResold = "Feature.Catalog.Message.CannotBeResold"
	})
	local v16 = RoactGamepad.useRefCache()
	local t2 = {}

	for v18, v19 in t1.items do
		t2[v19.id] = React.createElement(OwnedItemRow, {
			itemId = t1.itemId,
			itemType = t1.itemType,
			title = v19.title,
			buyPrice = v19.buyPrice,
			salePrice = v19.salePrice,
			isOnHold = v19.isOnHold,
			resaleRestriction = t1.resaleRestriction,
			isOnSale = v19.isOnSale,
			restrictionTypes = t1.restrictionTypes,
			layoutOrder = v18,
			onActivated = function() -- line: 68
				-- upvalues: t1 (copy), v19 (copy)
				t1.onItemActivated(v19.id, v19.isOnSale)
			end,
			ref = if not GetFFlagL2ControllerSupport() then nil else v16[v18],
			NextSelectionUp = if not GetFFlagL2ControllerSupport() or not (v18 > 1) then nil else v16[v18 - 1],
			NextSelectionDown = if not GetFFlagL2ControllerSupport() or not (v18 < #t1.items) then nil else v16[v18 + 1]
		})
	end

	return React.createElement(not GetFFlagL2ControllerSupport() and "Frame" or Focusable.Frame, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = t1.layoutOrder,
		ref = if not GetFFlagL2ControllerSupport() then nil else p1,
		defaultChild = if not GetFFlagL2ControllerSupport() then nil else v16[1],
		restorePreviousChildFocus = not not GetFFlagL2ControllerSupport() or nil
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 24),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ResaleRestrictionLabel = t1.resaleRestriction == CatalogConstants.ResaleRestriction.Disabled and React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v15.cannotBeResold,
			Font = v14.Font.Header2.Font,
			TextSize = v14.Font.BaseSize * v14.Font.Header2.RelativeSize,
			TextColor3 = v14.Theme.TextEmphasis.Color
		}),
		Rows = React.createElement(React.Fragment, nil, t2)
	})
end))
