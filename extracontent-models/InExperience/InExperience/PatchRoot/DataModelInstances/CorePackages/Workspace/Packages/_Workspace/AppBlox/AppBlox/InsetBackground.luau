local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function InsetBackground(props)
	local v = useSignalState(Display.GetDisplayStore().getGuiInset)
	local v2 = props.excludeGlobalGuiInset and { left = 0, top = 0, right = 0, bottom = 0 } or v

	local v3 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v4 = useTokens()

	local joined = Cryo.Dictionary.join(
		{
			BackgroundTransparency = v4.Color.Surface.Surface_0.Transparency,
			BackgroundColor3 = v4.Color.Surface.Surface_0.Color3,
			BorderSizePixel = 0
		},
		props.frameProps or {}
	)

	local v5 = v2.left + v3.left
	local v6 = v2.right + v3.right
	local v7 = v2.top + v3.top
	local v8 = v2.bottom + v3.bottom

	local joined2 = Cryo.Dictionary.join({
		Position = UDim2.new(0, not props.directions.left and 0 or -v5, 0, -v7),
		Size = UDim2.new(1, (not props.directions.left and 0 or v5) + (not props.directions.right and 0 or v6), 0, v7)
	}, Cryo.Dictionary.join(joined, props.topFrameProps or {}))
	local joined3 = Cryo.Dictionary.join({
		Position = UDim2.new(0, not props.directions.left and 0 or -v5, 1, 0),
		Size = UDim2.new(1, (not props.directions.left and 0 or v5) + (not props.directions.right and 0 or v6), 0, v8)
	}, Cryo.Dictionary.join(joined, props.bottomFrameProps or {}))
	local joined4 = Cryo.Dictionary.join({
		Position = UDim2.new(0, -v5, 0, not props.directions.top and 0 or -v7),
		Size = UDim2.new(0, v5, 1, (not props.directions.top and 0 or v7) + (not props.directions.bottom and 0 or v8))
	}, Cryo.Dictionary.join(joined, props.leftFrameProps or {}))
	local joined5 = Cryo.Dictionary.join({
		Position = UDim2.new(1, 0, 0, not props.directions.top and 0 or -v7),
		Size = UDim2.new(0, v6, 1, (not props.directions.top and 0 or v7) + (not props.directions.bottom and 0 or v8))
	}, Cryo.Dictionary.join(joined, props.rightFrameProps or {}))

	local createElement = React.createElement
	local fragment = React.Fragment
	local insetBackgroundTop

	if props.directions.top and v7 > 0 then
		insetBackgroundTop = React.createElement("Frame", joined2)
	end

	local insetBackgroundBottom

	if props.directions.bottom and v8 > 0 then
		insetBackgroundBottom = React.createElement("Frame", joined3)
	end

	local insetBackgroundLeft

	if props.directions.left and v5 > 0 then
		insetBackgroundLeft = React.createElement("Frame", joined4)
	end

	local insetBackgroundRight

	if props.directions.right and v6 > 0 then
		insetBackgroundRight = React.createElement("Frame", joined5)
	end

	return createElement(fragment, nil, {
		InsetBackgroundTop = insetBackgroundTop,
		InsetBackgroundBottom = insetBackgroundBottom,
		InsetBackgroundLeft = insetBackgroundLeft,
		InsetBackgroundRight = insetBackgroundRight
	})
end

return InsetBackground
