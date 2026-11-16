local parent = script.Parent.Parent
local parent2 = parent.Parent

local ContentProvider = game:GetService("ContentProvider")

local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local Skeleton = Foundation.Skeleton
local View = Foundation.View

local getCropSize = require(parent.Utils.getCropSize)
local getFitSize = require(parent.Utils.getFitSize)
local LoadingState = require(parent.Enums.LoadingState)

local FFlagUseRbxStorageInCapturesCommon = require(parent.Flags.FFlagUseRbxStorageInCapturesCommon)

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(LoadingState.Loading)
	local state3, setState3 = React.useState(Vector2.new(0, 0))

	React.useEffect(function()
		if props.Video == nil or props.Video == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(props.Video):Connect(function(p)
			if p == Enum.AssetFetchStatus.Failure then
				setState2(LoadingState.Failed)
			end
		end)

		return function()
			connection:Disconnect()
			setState2(LoadingState.Loading)
		end
	end, { props.Video })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, { setState })

	local v = React.useCallback(function(p)
		local resolution = p.Resolution
		setState3(resolution)

		if props.onResolutionChanged then
			props.onResolutionChanged(resolution)
		end
	end, { props.onResolutionChanged, setState3 })

	local v2 = React.useCallback(function(p)
		if state2 == LoadingState.Loading then
			setState2(LoadingState.Finished)
		end

		props.onLoaded(p)
	end, { state2, props.onLoaded })

	if state2 == LoadingState.Failed then
		return props.renderOnFailed()
	end

	local createElement = React.createElement
	local v3 = {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = props.BackgroundTransparency,
		ClipsDescendants = true,
		isDisabled = true,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		Position = props.Position,
		Size = props.Size,
		ZIndex = props.ZIndex
	}

	local createElement2 = React.createElement
	local v4 = {}
	v4.AnchorPoint = Vector2.new(0.5, 0.5)
	v4.BackgroundTransparency = 1
	v4.Looped = props.Looped == nil or props.Looped
	v4.Playing = props.Playing
	v4.Position = UDim2.fromScale(0.5, 0.5)
	v4.ref = props.videoRef
	local size

	if props.scaleType == Enum.ScaleType.Fit then
		size = getFitSize(state, state3)
	elseif props.scaleType == Enum.ScaleType.Crop then
		size = getCropSize(state, state3)
	else
		size = UDim2.fromScale(1, 1)
	end

	v4.Size = size

	v4.Video = props.Video
	local videoContent

	if FFlagUseRbxStorageInCapturesCommon then
		videoContent = props.VideoContent
	end

	v4.VideoContent = videoContent
	v4.Visible = state3.X > 0 and state3.Y > 0
	v4[React.Change.Resolution] = v
	v4[React.Event.Loaded] = v2
	local corner

	if props.cornerRadius then
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	local v5 = {
		VideoFrame = createElement2("VideoFrame", v4, { Corner = corner }),
		Shimmer = 0
	}
	local shimmer

	if state2 ~= LoadingState.Finished then
		shimmer = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1), ZIndex = 2 })
	end

	v5.Shimmer = shimmer
	return createElement(View, v3, v5)
end
