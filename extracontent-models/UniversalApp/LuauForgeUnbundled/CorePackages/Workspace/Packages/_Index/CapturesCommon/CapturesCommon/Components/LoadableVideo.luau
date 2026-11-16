local ContentProvider = game:GetService("ContentProvider")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local skeleton = Foundation.Skeleton
local view = Foundation.View

local getCropSize = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Utils/getCropSize")
local getFitSize = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Utils/getFitSize")
local LoadingState = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/LoadingState")

local FFlagUseRbxStorageInCapturesCommon = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Flags/FFlagUseRbxStorageInCapturesCommon")

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(LoadingState.Loading)
	local state3, setState3 = React.useState(Vector2.new(0, 0))

	React.useEffect(function()
		if props.Video == nil or props.Video == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(props.Video):Connect(function(p2)
			if p2 == Enum.AssetFetchStatus.Failure then
				setState2(LoadingState.Failed)
			end
		end)

		return function()
			connection:Disconnect()
			setState2(LoadingState.Loading)
		end
	end, { props.Video })

	local v5 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, { setState })

	local v6 = React.useCallback(function(p2)
		local resolution = p2.Resolution
		setState3(resolution)

		if props.onResolutionChanged then
			props.onResolutionChanged(resolution)
		end
	end, { props.onResolutionChanged, setState3 })

	local v7 = React.useCallback(function(p2)
		if state2 == LoadingState.Loading then
			setState2(LoadingState.Finished)
		end

		props.onLoaded(p2)
	end, { state2, props.onLoaded })

	if state2 == LoadingState.Failed then
		return props.renderOnFailed()
	end

	local createElement = React.createElement
	local v9 = {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = props.BackgroundTransparency,
		ClipsDescendants = true,
		isDisabled = true,
		onAbsoluteSizeChanged = v5,
		Position = props.Position,
		Size = props.Size,
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v12 = {}
	v12.AnchorPoint = Vector2.new(0.5, 0.5)
	v12.BackgroundTransparency = 1
	v12.Looped = props.Looped == nil or props.Looped
	v12.Playing = props.Playing
	v12.Position = UDim2.fromScale(0.5, 0.5)
	v12.ref = props.videoRef
	local v13

	if props.scaleType == Enum.ScaleType.Fit then
		v13 = getFitSize(state, state3)
	elseif props.scaleType == Enum.ScaleType.Crop then
		v13 = getCropSize(state, state3)
	else
		v13 = UDim2.fromScale(1, 1)
	end

	v12.Size = v13

	v12.Video = props.Video
	local v14 = if FFlagUseRbxStorageInCapturesCommon then props.VideoContent else nil
	v12.VideoContent = v14
	v12.Visible = state3.X > 0 and state3.Y > 0
	v12[React.Change.Resolution] = v6
	v12[React.Event.Loaded] = v7

	local v17 = if props.cornerRadius then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, props.cornerRadius)
	}) else nil
	local v10 = {
		VideoFrame = createElement2("VideoFrame", v12, { Corner = v17 }),
		Shimmer = 0
	}

	local v18 = if state2 ~= LoadingState.Finished then React.createElement(skeleton, {
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2
	}) else nil
	v10.Shimmer = v18
	return createElement(view, v9, v10)
end
