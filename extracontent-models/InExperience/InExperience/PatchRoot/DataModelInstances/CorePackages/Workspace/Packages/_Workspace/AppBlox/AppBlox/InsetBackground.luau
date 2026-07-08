local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Display = require(Parent.Display)
local useSignalState = require(Parent.SignalsReact).useSignalState
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function InsetBackground(t1: {[any]: any}) -- line: 30
	-- upvalues: useSignalState (copy), Display (copy), useTokens (copy), Cryo (copy), React (copy)
	local v9 = useSignalState(Display.GetDisplayStore().getGuiInset)
	local v10 = if not t1.excludeGlobalGuiInset then v9 else {
		left = 0,
		top = 0,
		right = 0,
		bottom = 0
	}
	local v11 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v12 = useTokens()
	local v13 = Cryo.Dictionary.join({
		BorderSizePixel = 0,
		BackgroundTransparency = v12.Color.Surface.Surface_0.Transparency,
		BackgroundColor3 = v12.Color.Surface.Surface_0.Color3
	}, t1.frameProps or {})
	local v14 = v10.left + v11.left
	local v15 = v10.right + v11.right
	local v16 = v10.top + v11.top
	local v17 = v10.bottom + v11.bottom
	local v18 = Cryo.Dictionary.join({
		Position = UDim2.new(0, not t1.directions.left and 0 or -v14, 0, -v16),
		Size = UDim2.new(1, (not t1.directions.left and 0 or v14) + (not t1.directions.right and 0 or v15), 0, v16)
	}, Cryo.Dictionary.join(v13, t1.topFrameProps or {}))
	local v19 = Cryo.Dictionary.join({
		Position = UDim2.new(0, not t1.directions.left and 0 or -v14, 1, 0),
		Size = UDim2.new(1, (not t1.directions.left and 0 or v14) + (not t1.directions.right and 0 or v15), 0, v17)
	}, Cryo.Dictionary.join(v13, t1.bottomFrameProps or {}))
	local v20 = Cryo.Dictionary.join({
		Position = UDim2.new(0, -v14, 0, not t1.directions.top and 0 or -v16),
		Size = UDim2.new(0, v14, 1, (not t1.directions.top and 0 or v16) + (not t1.directions.bottom and 0 or v17))
	}, Cryo.Dictionary.join(v13, t1.leftFrameProps or {}))
	local v21 = Cryo.Dictionary.join({
		Position = UDim2.new(1, 0, 0, not t1.directions.top and 0 or -v16),
		Size = UDim2.new(0, v15, 1, (not t1.directions.top and 0 or v16) + (not t1.directions.bottom and 0 or v17))
	}, Cryo.Dictionary.join(v13, t1.rightFrameProps or {}))

	return React.createElement(React.Fragment, nil, {
		InsetBackgroundTop = if not t1.directions.top or not (v16 > 0) then nil else React.createElement("Frame", v18),
		InsetBackgroundBottom = if not t1.directions.bottom or not (v17 > 0) then nil else React.createElement("Frame", v19),
		InsetBackgroundLeft = if not t1.directions.left or not (v14 > 0) then nil else React.createElement("Frame", v20),
		InsetBackgroundRight = if not t1.directions.right or not (v15 > 0) then nil else React.createElement("Frame", v21)
	})
end

return InsetBackground
