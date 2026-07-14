local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local PlayerContextualMenuStore = require(ParentParent.Common.PlayerContextualMenuStore)
local PlayerContextMenuHeader = require(ParentParent.Components.Presentation.PlayerContextMenuHeader)
local MenuActionRow = require(ParentParent.Components.Presentation.MenuActionRow)
local t1 = {
	Transparency = 1,
	Color3 = Color3.new(0, 0, 0)
}
local t2 = {
	affordance = StateLayerAffordance.None
}

local function PlayerContextualMenuView(t3: {[any]: any}) -- line: 25
	-- upvalues: SignalsReact (copy), PlayerContextualMenuStore (copy), useTokens (copy), React (copy), PlayerContextMenuHeader (copy), Divider (copy), MenuActionRow (copy), View (copy), t1 (copy), t2 (copy)
	local v17 = SignalsReact.useSignalState(PlayerContextualMenuStore.getMenuData)
	local v18 = useTokens()
	local v19, v20 = React.useBinding(false)
	local v21 = React.useRef(false)
	local v22 = React.useRef(nil)
	local v23 = React.useRef(nil)

	React.useEffect(function() -- line: 36
		-- upvalues: v20 (copy), v21 (copy), v17 (copy), v22 (copy), v23 (copy)
		v20(false)
		v21.current = false

		if v17 == nil then
			return
		end

		local current = v22.current

		if current ~= nil and current.AbsoluteSize.Y > 0 then
			v20(true)
			v21.current = true

			return
		end

		if current == nil then
			return
		end

		v23.current = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 51
			-- upvalues: v22 (copy), v23 (copy), v21 (copy), v20 (copy)
			local current2 = v22.current

			if current2 ~= nil and current2.AbsoluteSize.Y > 0 then
				if v23.current then
					v23.current:Disconnect()
					v23.current = nil
				end

				if not v21.current then
					v21.current = true
					v20(true)
				end
			end
		end)

		return function() -- line: 64
			-- upvalues: v23 (copy)
			if v23.current then
				v23.current:Disconnect()
				v23.current = nil
			end
		end
	end, { v17 })

	if v17 == nil then
		return nil
	end

	local anchorPosition = v17.anchorPosition
	local vector2 = Vector2.new(0.5, 0.5)
	local uDim2 = UDim2.fromScale(0.5, 0.5)

	if not t3.isSmallTouchDevice and anchorPosition ~= nil then
		vector2 = Vector2.new(1, 0)
		uDim2 = UDim2.fromOffset(anchorPosition.X - 8, anchorPosition.Y)
	end

	local t4 = {
		Header = React.createElement(PlayerContextMenuHeader, {
			layoutOrder = 1,
			header = v17.header
		}),
		HeaderDivider = React.createElement(Divider, {
			LayoutOrder = 2
		})
	}

	for i, v in ipairs(v17.items) do
		t4[`Action_{ tostring(v.key) }`] = React.createElement(MenuActionRow, {
			item = v,
			layoutOrder = 2 + i
		})
	end

	return React.createElement(View, {
		ZIndex = 10,
		tag = "size-full",
		backgroundStyle = t1
	}, {
		Backdrop = React.createElement(View, {
			tag = "size-full",
			ZIndex = 1,
			backgroundStyle = if not t3.isSmallTouchDevice then t1 else v18.Color.Common.Scrim,
			onActivated = PlayerContextualMenuStore.closeContextMenu,
			stateLayer = t2
		}),
		Menu = React.createElement(View, {
			ZIndex = 2,
			tag = "col align-x-left gap-xxsmall auto-y padding-small stroke-standard stroke-default radius-large bg-over-media-100",
			AnchorPoint = vector2,
			Position = uDim2,
			Size = UDim2.fromOffset(260, 0),
			Visible = v19,
			ref = v22
		}, t4)
	})
end

return React.memo(PlayerContextualMenuView)
