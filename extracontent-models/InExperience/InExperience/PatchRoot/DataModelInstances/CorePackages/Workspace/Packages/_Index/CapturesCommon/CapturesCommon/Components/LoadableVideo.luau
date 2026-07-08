local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ContentProvider = game:GetService("ContentProvider")
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local getCropSize = require(ParentParent.Utils.getCropSize)
local getFitSize = require(ParentParent.Utils.getFitSize)
local LoadingState = require(ParentParent.Enums.LoadingState)
local FFlagUseRbxStorageInCapturesCommon = require(ParentParent.Flags.FFlagUseRbxStorageInCapturesCommon)

return function(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), LoadingState (copy), ContentProvider (copy), View (copy), getFitSize (copy), getCropSize (copy), FFlagUseRbxStorageInCapturesCommon (copy), Skeleton (copy)
	local v13, v14 = React.useState(Vector2.new(0, 0))
	local v15, v16 = React.useState(LoadingState.Loading)
	local v17, v18 = React.useState(Vector2.new(0, 0))

	React.useEffect(function() -- line: 41
		-- upvalues: t1 (copy), ContentProvider (copy), v16 (copy), LoadingState (copy)
		if t1.Video == nil or t1.Video == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(t1.Video):Connect(function(p1) -- line: 47
			-- upvalues: v16 (copy), LoadingState (copy)
			if p1 == Enum.AssetFetchStatus.Failure then
				v16(LoadingState.Failed)
			end
		end)

		return function() -- line: 53
			-- upvalues: connection (copy), v16 (copy), LoadingState (copy)
			connection:Disconnect()
			v16(LoadingState.Loading)
		end
	end, { t1.Video })

	local v19 = React.useCallback(function(p2) -- line: 59
		-- upvalues: v14 (copy)
		v14(p2.AbsoluteSize)
	end, { v14 })
	local v20 = React.useCallback(function(p3) -- line: 63
		-- upvalues: v18 (copy), t1 (copy)
		local Resolution = p3.Resolution

		v18(Resolution)

		if t1.onResolutionChanged then
			t1.onResolutionChanged(Resolution)
		end
	end, {
		t1.onResolutionChanged,
		v18
	})
	local v21 = React.useCallback(function(p4) -- line: 72
		-- upvalues: v15 (copy), LoadingState (copy), v16 (copy), t1 (copy)
		if v15 == LoadingState.Loading then
			v16(LoadingState.Finished)
		end

		t1.onLoaded(p4)
	end, {
		v15,
		t1.onLoaded
	})

	if v15 == LoadingState.Failed then
		return t1.renderOnFailed()
	end

	return React.createElement(View, {
		ClipsDescendants = true,
		isDisabled = true,
		AnchorPoint = t1.AnchorPoint,
		BackgroundTransparency = t1.BackgroundTransparency,
		onAbsoluteSizeChanged = v19,
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
			Size = if t1.scaleType ~= Enum.ScaleType.Fit then if t1.scaleType ~= Enum.ScaleType.Crop then UDim2.fromScale(1, 1) else getCropSize(v13, v17) else getFitSize(v13, v17),
			Video = t1.Video,
			VideoContent = if not FFlagUseRbxStorageInCapturesCommon then nil else t1.VideoContent,
			Visible = v17.X > 0 and v17.Y > 0,
			[React.Change.Resolution] = v20,
			[React.Event.Loaded] = v21
		}, {
			Corner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		}),
		Shimmer = if v15 == LoadingState.Finished then nil else React.createElement(Skeleton, {
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1)
		})
	})
end
