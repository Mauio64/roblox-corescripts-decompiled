local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local ContentProvider = game:GetService("ContentProvider")
local Foundation = require(ProfilePlatformParent.Foundation)
local React = require(ProfilePlatformParent.React)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local LoadingState = require(ProfilePlatform.Common.Enums).LoadingState

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), LoadingState (copy), ContentProvider (copy), View (copy), Skeleton (copy)
	local v10, v11 = React.useState(LoadingState.Loading)
	local v12, v13 = React.useState(Vector2.new(0, 0))

	React.useEffect(function() -- line: 32
		-- upvalues: t1 (copy), ContentProvider (copy), v11 (copy), LoadingState (copy)
		if t1.Video == nil or t1.Video == "" then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(t1.Video):Connect(function(p1) -- line: 38
			-- upvalues: v11 (copy), LoadingState (copy)
			if p1 == Enum.AssetFetchStatus.Failure then
				v11(LoadingState.Failed)
			end
		end)

		return function() -- line: 44
			-- upvalues: connection (copy), v11 (copy), LoadingState (copy)
			connection:Disconnect()
			v11(LoadingState.Loading)
		end
	end, { t1.Video })

	local v14 = React.useCallback(function(p2) -- line: 50
		-- upvalues: v13 (copy), t1 (copy)
		local Resolution = p2.Resolution

		v13(Resolution)

		if t1.onResolutionChanged then
			t1.onResolutionChanged(Resolution)
		end
	end, {
		t1.onResolutionChanged,
		v13
	})
	local v15 = React.useCallback(function(p3) -- line: 59
		-- upvalues: v10 (copy), LoadingState (copy), v11 (copy), t1 (copy)
		if v10 == LoadingState.Loading then
			v11(LoadingState.Finished)
		end

		if t1.onLoaded then
			t1.onLoaded(p3)
		end
	end, {
		v10,
		t1.onLoaded
	})

	if v10 == LoadingState.Failed then
		return t1.renderOnFailed()
	end

	return React.createElement(View, {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		isDisabled = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
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
			Size = UDim2.fromScale(1, 1),
			Video = t1.Video,
			Visible = v12.X > 0 and v12.Y > 0,
			[React.Change.Resolution] = v14,
			[React.Event.Loaded] = v15
		}, {
			Corner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t1.cornerRadius)
			})
		}),
		Shimmer = if v10 == LoadingState.Finished then nil else React.createElement(Skeleton, {
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1)
		})
	})
end
