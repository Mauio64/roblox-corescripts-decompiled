local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local useTokens = Foundation.Hooks.useTokens
local PlayerContextualMenuStore = require(ParentParent.Common.PlayerContextualMenuStore)
local PlayerContextMenuHeader = require(ParentParent.Components.Presentation.PlayerContextMenuHeader)
local MenuActionRow = require(ParentParent.Components.Presentation.MenuActionRow)

local function PlayerContextualMenuView(t1: {[any]: any}) -- line: 28
	-- upvalues: SignalsReact (copy), PlayerContextualMenuStore (copy), useTokens (copy), React (copy), PlayerContextMenuHeader (copy), Divider (copy), MenuActionRow (copy), View (copy)
	local v14 = SignalsReact.useSignalState(PlayerContextualMenuStore.getMenuData)
	local v15 = useTokens()

	if v14 == nil then
		return nil
	end

	local anchorPosition = v14.anchorPosition
	local vector2 = Vector2.new(0.5, 0.5)
	local uDim2 = UDim2.fromScale(0.5, 0.5)

	if not t1.isSmallTouchDevice and anchorPosition ~= nil then
		vector2 = Vector2.new(1, 0)
		uDim2 = UDim2.fromOffset(anchorPosition.X - 8, anchorPosition.Y)
	end

	local t2 = {
		Header = React.createElement(PlayerContextMenuHeader, {
			layoutOrder = 1,
			header = v14.header
		}),
		HeaderDivider = React.createElement(Divider, {
			LayoutOrder = 2
		})
	}

	for i, v in ipairs(v14.items) do
		t2[`Action_{ tostring(v.key) }`] = React.createElement(MenuActionRow, {
			label = v.label,
			icon = v.icon,
			onActivated = v.onActivated,
			layoutOrder = 2 + i
		})
	end

	return React.createElement(View, {
		ZIndex = 10,
		tag = "size-full"
	}, {
		Backdrop = React.createElement(View, {
			tag = "size-full",
			ZIndex = 1,
			backgroundStyle = if not t1.isSmallTouchDevice then nil else v15.Color.Common.Scrim,
			onActivated = PlayerContextualMenuStore.closeContextMenu
		}),
		Menu = React.createElement(View, {
			ZIndex = 2,
			tag = "col align-x-left gap-xxsmall auto-y padding-small stroke-standard stroke-default radius-large bg-over-media-100",
			AnchorPoint = vector2,
			Position = uDim2,
			Size = UDim2.fromOffset(260, 0)
		}, t2)
	})
end

return React.memo(PlayerContextualMenuView)
