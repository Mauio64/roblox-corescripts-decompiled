local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local React = require(parent4.React)
local Cryo = require(parent4.Cryo)

local useStyle = require(parent2.Style.useStyle)
local useCursor = require(parent3.App.SelectionCursor.useCursor)
local Interactable = require(parent.Interactable)
local ControlState = require(parent.Enum.ControlState)

local v = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.fromScale(0.5, 0.5),
	size = UDim2.fromScale(1, 1),
	isDisabled = false,
	selectable = true,
	affordance = "Background",
	stateStyle = "Standard",
	outset = {
		top = UDim.new(0, 0),
		right = UDim.new(0, 0),
		bottom = UDim.new(0, 0),
		left = UDim.new(0, 0)
	}
}

local rawValue = ControlState.Initialize.rawValue()

local v2 = {
	[ControlState.Initialize.rawValue()] = "Idle",
	[ControlState.Default.rawValue()] = "Idle",
	[ControlState.Pressed.rawValue()] = "Press",
	[ControlState.Hover.rawValue()] = "Hover",
	[ControlState.Selected.rawValue()] = "Idle",
	[ControlState.SelectedPressed.rawValue()] = "Press",
	[ControlState.Disabled.rawValue()] = "Idle"
}

local function getStateTokens(tokens, stateStyle: string) -- 1 equivalent call inferred from this helper
	if stateStyle == "Standard" then
		return tokens.Color.State
	elseif stateStyle == "Inverse" then
		return tokens.Inverse.State
	elseif stateStyle == "Lighten" then
		return tokens.DarkMode.State
	end

	return tokens.LightMode.State
end

local forwardRef = React.forwardRef(function(p, ref)
	local joined = Cryo.Dictionary.join(v, p)

	local tokens = useStyle().Tokens
	local stateTokens = getStateTokens(tokens, joined.stateStyle) -- inferred equivalent call
	local stateToken = stateTokens[v2[rawValue]]
	local v3, v4 = React.useBinding(stateToken.Color3)
	local v5, v6 = React.useBinding(stateToken.Transparency)
	local selectionImageObject = useCursor(joined.cornerRadius)

	local v7 = {
		ref = ref,
		AnchorPoint = joined.anchorPoint,
		Position = joined.position,
		Size = joined.size,
		LayoutOrder = joined.layoutOrder,
		ZIndex = joined.zIndex,
		BackgroundTransparency = 1
	}

	local children = {}

	if joined.cornerRadius ~= nil then
		children.UICorner = React.createElement("UICorner", { CornerRadius = joined.cornerRadius })
	end

	if joined.affordance == "Border" then
		children.UIStroke = React.createElement("UIStroke", {
			Thickness = tokens.Stroke.Standard,
			Color = v3,
			Transparency = v5
		})

		v7.BackgroundTransparency = 1
	elseif joined.affordance == "Background" then
		v7.BackgroundColor3 = v3
		v7.BackgroundTransparency = v5
	end

	local outset = joined.outset
	local udim = UDim2.new(
		1 + outset.left.Scale + outset.right.Scale,
		outset.left.Offset + outset.right.Offset,
		1 + outset.top.Scale + outset.bottom.Scale,
		outset.top.Offset + outset.bottom.Offset
	)

	local udim2 = UDim2.new(-outset.left.Scale, -outset.left.Offset, -outset.top.Scale, -outset.top.Offset)
	local onStateChanged = React.useCallback(function(p2, p3)
		local stateToken2 = stateTokens[v2[p3.rawValue()]]
		v4(stateToken2.Color3)
		v6(stateToken2.Transparency)

		if joined.onStateChanged then
			joined.onStateChanged(p2, p3)
		end
	end, { stateTokens, v4, v6, joined.onStateChanged })
	children.Button = React.createElement(Interactable, {
		Size = udim,
		Position = udim2,
		BackgroundTransparency = 1,
		Selectable = not joined.isDisabled and joined.selectable,
		SelectionImageObject = selectionImageObject,
		[React.Event.Activated] = joined.onActivated,
		onStateChanged = onStateChanged,
		isDisabled = joined.isDisabled,
		userInteractionEnabled = not joined.isDisabled
	})

	return React.createElement("Frame", v7, children)
end)

return React.memo(forwardRef)
