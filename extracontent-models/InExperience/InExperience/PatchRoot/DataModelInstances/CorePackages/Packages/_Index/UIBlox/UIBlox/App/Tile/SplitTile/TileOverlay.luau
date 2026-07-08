local ParentParent = script.Parent.Parent.Parent.Parent
local Core = ParentParent.Core
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Interactable = require(Core.Control.Interactable)
local useControlState = require(Core.Control.useControlState)
local useStyle = require(Core.Style.useStyle)
local ControlState = require(Core.Control.Enum.ControlState)
local setDefault = require(ParentParent.Utility.setDefault)
local uDim = UDim.new(0, 8)

local function TileOverlay(t1: {[any]: any}) -- line: 33
	-- upvalues: setDefault (copy), useControlState (copy), useStyle (copy), ControlState (copy), React (copy), uDim (copy), Interactable (copy)
	local onActivated = t1.onActivated
	local v14 = setDefault(t1.isVisible, true)
	local v15 = setDefault(t1.isActive, true)
	local v16 = t1.reservedBottomHeight or 0
	local v17 = v16 > 0

	if not v14 and not v15 then
		return nil
	end

	local v18, v19 = useControlState()
	local Theme = useStyle().Theme
	local BackgroundOnPressColor = nil
	local n1 = 1

	if v14 and v15 then
		if v18 == ControlState.Pressed then
			BackgroundOnPressColor = Theme.BackgroundOnPress.Color
			n1 = Theme.BackgroundOnPress.Transparency
		elseif v18 == ControlState.Hover then
			BackgroundOnPressColor = Theme.BackgroundOnHover.Color
			n1 = Theme.BackgroundOnHover.Transparency
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = t1.zIndex
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		ClippingFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 1, not v17 and 0 or -v16)
		}, {
			Interactable = React.createElement(Interactable, {
				Size = UDim2.new(1, 0, 1, not v17 and 0 or uDim.Offset),
				BackgroundColor3 = BackgroundOnPressColor,
				BackgroundTransparency = n1,
				AutoButtonColor = false,
				onStateChanged = v19,
				[React.Event.Activated] = if not v15 then nil else onActivated,
				ZIndex = 3
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				})
			})
		})
	})
end

return TileOverlay
