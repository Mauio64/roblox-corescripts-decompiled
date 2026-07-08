local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local React = require(scriptParentParentParentParent.React)
local Cryo = require(scriptParentParentParentParent.Cryo)
local useStyle = require(scriptParentParent.Style.useStyle)
local useCursor = require(scriptParentParentParent.App.SelectionCursor.useCursor)
local Interactable = require(scriptParent.Interactable)
local ControlState = require(scriptParent.Enum.ControlState)
local t1 = {
	isDisabled = false,
	selectable = true,
	affordance = "Background",
	stateStyle = "Standard",
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.fromScale(0.5, 0.5),
	size = UDim2.fromScale(1, 1),
	outset = {
		top = UDim.new(0, 0),
		right = UDim.new(0, 0),
		bottom = UDim.new(0, 0),
		left = UDim.new(0, 0)
	}
}
local v12 = ControlState.Initialize.rawValue()
local v13 = React.forwardRef(function(t2: {[any]: any}, p1) -- line: 76
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), v12 (copy), React (copy), useCursor (copy), Interactable (copy)
	local v16 = Cryo.Dictionary.join(t1, t2)
	local StateLayer = useStyle().Tokens.Component.StateLayer
	local Color = StateLayer[v16.stateStyle][v12].Color
	local v19, v20 = React.useBinding(Color.Color3)
	local v21, v22 = React.useBinding(Color.Transparency)
	local v23 = useCursor(v16.cornerRadius)
	local t3 = {
		BackgroundTransparency = 1,
		ref = p1,
		AnchorPoint = v16.anchorPoint,
		Position = v16.position,
		Size = v16.size,
		LayoutOrder = v16.layoutOrder,
		ZIndex = v16.zIndex
	}
	local t4 = {}

	if v16.cornerRadius ~= nil then
		t4.UICorner = React.createElement("UICorner", {
			CornerRadius = v16.cornerRadius
		})
	end

	if v16.affordance == "Border" then
		t4.UIStroke = React.createElement("UIStroke", {
			Thickness = StateLayer.Base.BorderWidth,
			Color = v19,
			Transparency = v21
		})
		t3.BackgroundTransparency = 1
	elseif v16.affordance == "Background" then
		t3.BackgroundColor3 = v19
		t3.BackgroundTransparency = v21
	end

	local outset = v16.outset
	local uDim2 = UDim2.new(1 + outset.left.Scale + outset.right.Scale, outset.left.Offset + outset.right.Offset, 1 + outset.top.Scale + outset.bottom.Scale, outset.top.Offset + outset.bottom.Offset)
	local uDim2_2 = UDim2.new(-outset.left.Scale, -outset.left.Offset, -outset.top.Scale, -outset.top.Offset)
	local v29 = React.useCallback(function(p2, p3) -- line: 122
		-- upvalues: StateLayer (copy), v16 (copy), v20 (copy), v22 (copy)
		local Color2 = StateLayer[v16.stateStyle][p3.rawValue()].Color

		v20(Color2.Color3)
		v22(Color2.Transparency)

		if v16.onStateChanged then
			v16.onStateChanged(p2, p3)
		end
	end, {
		StateLayer,
		v20,
		v22,
		v16.stateStyle,
		v16.onStateChanged
	})

	t4.Button = React.createElement(Interactable, {
		Size = uDim2,
		Position = uDim2_2,
		BackgroundTransparency = 1,
		Selectable = not v16.isDisabled and v16.selectable,
		SelectionImageObject = v23,
		[React.Event.Activated] = v16.onActivated,
		onStateChanged = v29,
		isDisabled = v16.isDisabled,
		userInteractionEnabled = not v16.isDisabled
	})

	return React.createElement("Frame", t3, t4)
end)

return React.memo(v13)
