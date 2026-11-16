local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local view = Foundation.View
local image = Foundation.Image
local skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
local fFlagLoadingScreenMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagLoadingScreenMilestones
local TILT_DEGREES = Constants.KEYART.TILT_DEGREES

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local v5 = {
	rotation = React.createBinding(TILT_DEGREES),
	sizeScale = React.createBinding(1),
	coverTransparency = React.createBinding(1)
}

local v6 = {
	rotation = React.createBinding(-TILT_DEGREES),
	sizeScale = React.createBinding(1),
	groupTransparency = React.createBinding(0)
}

local function TiltKeyart(props)
	local v7 = useTokens()
	local state, setState = React.useState(false)
	local keyart = props.keyart or v5
	local frame = props.frame or v6

	local v8 = v7.Size.Size_2400 * 2
	local v9 = v8 / (math.cos((math.rad(TILT_DEGREES))) + math.sin((math.rad(TILT_DEGREES))))

	local v10 = React.useCallback(function(p2)
		if p2 == Enum.AssetFetchStatus.Success then
			setState(true)
		end
	end, {})

	if fFlagLoadingScreenMilestones then
		React.useEffect(function()
			local onThumbnailLoaded = props.onThumbnailLoaded

			if not onThumbnailLoaded then
				return
			end

			if state and props.thumbnailUrl ~= "" then
				onThumbnailLoaded(props.thumbnailUrl)
			end

			return function()
				onThumbnailLoaded(nil)
			end
		end, { state, props.thumbnailUrl, props.onThumbnailLoaded })
	end

	local createElement = React.createElement
	local v12 = { Size = UDim2.fromOffset(v8, v8), testId = "tilt-keyart" }

	local v13 = {
		Square = React.createElement(view, {
			tag = "position-center-center anchor-center-center stroke-standard stroke-system-neutral",
			testId = "tilt-keyart-frame",
			Size = frame.sizeScale:map(function(p2)
				return UDim2.fromOffset(v9 * p2, v9 * p2)
			end),
			Rotation = frame.rotation,
			GroupTransparency = frame.groupTransparency,
			Visible = frame.groupTransparency:map(function(p2): boolean
				return p2 < 1
			end),
			ZIndex = 1
		}),
		Keyart = 0
	}

	local createElement2 = React.createElement
	local v15 = {
		tag = "position-center-center anchor-center-center",
		testId = "tilt-keyart-card",
		Size = keyart.sizeScale:map(function(p2)
			return UDim2.fromOffset(v9 * p2, v9 * p2)
		end),
		Rotation = keyart.rotation,
		ZIndex = 2
	}

	local v17 = if not state then React.createElement(skeleton, {
		tag = "size-full",
		ZIndex = 1,
		testId = "tilt-keyart-skeleton"
	}) else nil

	local v18 = if props.thumbnailUrl ~= "" then React.createElement(image, {
		tag = "size-full radius-small",
		Image = props.thumbnailUrl,
		ScaleType = Enum.ScaleType.Crop,
		ImageTransparency = state and 0 or 1,
		onLoaded = v10,
		ZIndex = 2,
		testId = "tilt-keyart-thumbnail"
	}) else nil
	v13.Keyart = createElement2(view, v15, {
		ThumbnailSkeleton = v17,
		Thumbnail = v18,
		RevealCover = React.createElement(view, {
			tag = "size-full",
			backgroundStyle = keyart.coverTransparency:map(function(p2)
				return {
					Color3 = v7.Color.Extended.Black.Black_100.Color3,
					Transparency = p2
				}
			end),
			ZIndex = 3
		})
	})
	return createElement(view, v12, v13)
end

return React.memo(TiltKeyart)
