local parent = script.Parent.Parent.Parent.Parent
local core = parent.Core
local parent2 = parent.Parent

local React = require(parent2.React)

local Interactable = require(core.Control.Interactable)
local useControlState = require(core.Control.useControlState)
local useStyle = require(core.Style.useStyle)
local ControlState = require(core.Control.Enum.ControlState)

local setDefault = require(parent.Utility.setDefault)

local udim = UDim.new(0, 8)

local function TileOverlay(props)
	local onActivated = props.onActivated
	local v = setDefault(props.isVisible, true)
	local v2 = setDefault(props.isActive, true)
	local reservedBottomHeight = props.reservedBottomHeight or 0
	local v3 = reservedBottomHeight > 0

	if not (v or v2) then
		return nil
	end

	local v4, onStateChanged = useControlState()
	local theme = useStyle().Theme
	local color = nil
	local backgroundTransparency = 1

	if v and v2 then
		if v4 == ControlState.Pressed then
			color = theme.BackgroundOnPress.Color
			backgroundTransparency = theme.BackgroundOnPress.Transparency
		elseif v4 == ControlState.Hover then
			color = theme.BackgroundOnHover.Color
			backgroundTransparency = theme.BackgroundOnHover.Transparency
		end
	end

	local createElement = React.createElement
	local v5 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = props.zIndex }
	local v6 = {
		UICorner = React.createElement("UICorner", { CornerRadius = udim }),
		ClippingFrame = 0
	}

	local createElement2 = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 1, not v3 and 0 or -reservedBottomHeight),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local createElement3 = React.createElement
	local onActivatedsByActivated = {
		["Size"] = UDim2.new(1, 0, 1, not v3 and 0 or udim.Offset),
		BackgroundColor3 = color,
		BackgroundTransparency = backgroundTransparency,
		AutoButtonColor = false,
		onStateChanged = onStateChanged
	}

	local activated = React.Event.Activated

	if not v2 then
		onActivated = nil
	end

	onActivatedsByActivated[activated] = onActivated
	onActivatedsByActivated.ZIndex = 3
	v6.ClippingFrame = createElement2("Frame", v7, {
		Interactable = createElement3(Interactable, onActivatedsByActivated, {
			UICorner = React.createElement("UICorner", { CornerRadius = udim })
		})
	})
	return createElement("Frame", v5, v6)
end

return TileOverlay
