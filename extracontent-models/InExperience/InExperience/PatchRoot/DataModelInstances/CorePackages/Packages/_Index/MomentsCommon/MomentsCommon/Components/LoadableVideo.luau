local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local ContentProvider = game:GetService("ContentProvider")
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local LoadingState = require(MomentsCommon.Enums.LoadingState)
local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)

return function(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), LoadingState (copy), ContentProvider (copy), View (copy), getFitSize (copy), getCropSize (copy), Skeleton (copy)
	local v12, v13 = React.useState(Vector2.new(0, 0))
	local v14, v15 = React.useState(LoadingState.Loading)
	local v16, v17 = React.useState(Vector2.new(0, 0))

	React.useEffect(function() -- line: 43
		-- upvalues: t1 (copy), ContentProvider (copy), v15 (copy), LoadingState (copy)
		if t1.Video == nil or t1.Video == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(t1.Video):Connect(function(p1) -- line: 49
			-- upvalues: v15 (copy), LoadingState (copy)
			if p1 == Enum.AssetFetchStatus.Failure then
				v15(LoadingState.Failed)
			end
		end)

		return function() -- line: 55
			-- upvalues: connection (copy), v15 (copy), LoadingState (copy)
			connection:Disconnect()
			v15(LoadingState.Loading)
		end
	end, { t1.Video })

	local v18 = React.useCallback(function(p2) -- line: 61
		-- upvalues: v13 (copy), t1 (copy)
		v13(p2.AbsoluteSize)

		if t1.onAbsoluteSizeChanged then
			t1.onAbsoluteSizeChanged(p2)
		end
	end, {
		t1.onAbsoluteSizeChanged,
		v13
	})
	local v19 = React.useCallback(function(p3) -- line: 69
		-- upvalues: v17 (copy), t1 (copy)
		local Resolution = p3.Resolution

		v17(Resolution)

		if t1.onResolutionChanged then
			t1.onResolutionChanged(Resolution)
		end
	end, {
		t1.onResolutionChanged,
		v17
	})
	local v20 = React.useCallback(function(p4) -- line: 78
		-- upvalues: v14 (copy), LoadingState (copy), v15 (copy), t1 (copy)
		if v14 == LoadingState.Loading then
			v15(LoadingState.Finished)
		end

		t1.onLoaded(p4)
	end, {
		v14,
		t1.onLoaded
	})

	if v14 == LoadingState.Failed then
		return t1.renderOnFailed()
	end

	return React.createElement(View, {
		isDisabled = true,
		AnchorPoint = t1.AnchorPoint,
		BackgroundTransparency = t1.BackgroundTransparency,
		ClipsDescendants = t1.ClipsDescendants ~= false,
		onAbsoluteSizeChanged = v18,
		Position = t1.Position,
		Size = t1.Size,
		ZIndex = t1.ZIndex
	}, {
		VideoFrame = React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Looped = t1.Looped == nil or t1.Looped,
			Playing = t1.Playing,
			Position = UDim2.fromScale(0.5, 0.5),
			ref = t1.videoRef,
			Size = if t1.scaleType ~= Enum.ScaleType.Fit then getCropSize(v12, v16) else getFitSize(v12, v16),
			Video = t1.Video,
			VideoContent = t1.VideoContent,
			Visible = v16.X > 0 and v16.Y > 0,
			[React.Change.Resolution] = v19,
			[React.Event.Loaded] = v20
		}, {
			Corner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		}),
		Shimmer = if v14 == LoadingState.Finished then nil else React.createElement(Skeleton, {
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1)
		})
	})
end
