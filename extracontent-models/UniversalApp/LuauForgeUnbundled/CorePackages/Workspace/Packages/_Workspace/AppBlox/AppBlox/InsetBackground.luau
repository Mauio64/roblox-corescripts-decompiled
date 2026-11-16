local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Display")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SignalsReact").useSignalState
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").Hooks.useTokens

local function InsetBackground(props)
	local v5 = useSignalState(Display.GetDisplayStore().getGuiInset)
	local v6 = props.excludeGlobalGuiInset and {
		left = 0,
		top = 0,
		right = 0,
		bottom = 0
	} or v5

	local v7 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v8 = useTokens()

	local joined = Cryo.Dictionary.join(
		{
			BackgroundTransparency = v8.Color.Surface.Surface_0.Transparency,
			BackgroundColor3 = v8.Color.Surface.Surface_0.Color3,
			BorderSizePixel = 0
		},
		props.frameProps or {}
	)

	local v9 = v6.left + v7.left
	local v10 = v6.right + v7.right
	local v11 = v6.top + v7.top
	local v12 = v6.bottom + v7.bottom

	local joined2 = Cryo.Dictionary.join({
		Position = UDim2.new(0, not props.directions.left and 0 or -v9, 0, -v11),
		Size = UDim2.new(
			1,
			(not props.directions.left and 0 or v9) + (not props.directions.right and 0 or v10),
			0,
			v11
		)
	}, Cryo.Dictionary.join(joined, props.topFrameProps or {}))
	local joined3 = Cryo.Dictionary.join({
		Position = UDim2.new(0, not props.directions.left and 0 or -v9, 1, 0),
		Size = UDim2.new(
			1,
			(not props.directions.left and 0 or v9) + (not props.directions.right and 0 or v10),
			0,
			v12
		)
	}, Cryo.Dictionary.join(joined, props.bottomFrameProps or {}))
	local joined4 = Cryo.Dictionary.join({
		Position = UDim2.new(0, -v9, 0, not props.directions.top and 0 or -v11),
		Size = UDim2.new(
			0,
			v9,
			1,
			(not props.directions.top and 0 or v11) + (not props.directions.bottom and 0 or v12)
		)
	}, Cryo.Dictionary.join(joined, props.leftFrameProps or {}))
	local joined5 = Cryo.Dictionary.join({
		Position = UDim2.new(1, 0, 0, not props.directions.top and 0 or -v11),
		Size = UDim2.new(
			0,
			v10,
			1,
			(not props.directions.top and 0 or v11) + (not props.directions.bottom and 0 or v12)
		)
	}, Cryo.Dictionary.join(joined, props.rightFrameProps or {}))

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = if props.directions.top and v11 > 0 then React.createElement("Frame", joined2) else nil

	local v16 = if props.directions.bottom and v12 > 0 then React.createElement("Frame", joined3) else nil

	local v17 = if props.directions.left and v9 > 0 then React.createElement("Frame", joined4) else nil

	local v18 = if props.directions.right and v10 > 0 then React.createElement("Frame", joined5) else nil
	return createElement(fragment, nil, {
		InsetBackgroundTop = v15,
		InsetBackgroundBottom = v16,
		InsetBackgroundLeft = v17,
		InsetBackgroundRight = v18
	})
end

return InsetBackground
