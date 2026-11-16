local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local parent = TiltLoadingScreen.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

local Constants = require(TiltLoadingScreen.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags.FFlagLoadingScreenMilestones
local TILT_DEGREES = Constants.KEYART.TILT_DEGREES

require(TiltLoadingScreen.Types)

local v = {
	rotation = React.createBinding(TILT_DEGREES),
	sizeScale = React.createBinding(1),
	coverTransparency = React.createBinding(1)
}

local v2 = {
	rotation = React.createBinding(-TILT_DEGREES),
	sizeScale = React.createBinding(1),
	groupTransparency = React.createBinding(0)
}

local function TiltKeyart(props)
	local v3 = useTokens()
	local state, setState = React.useState(false)
	local keyart = props.keyart or v
	local frame = props.frame or v2

	local v4 = v3.Size.Size_2400 * 2
	local v5 = v4 / (math.cos((math.rad(TILT_DEGREES))) + math.sin((math.rad(TILT_DEGREES))))

	local onLoaded = React.useCallback(function(p)
		if p == Enum.AssetFetchStatus.Success then
			setState(true)
		end
	end, {})

	if FFlagLoadingScreenMilestones then
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
	local v6 = { Size = UDim2.fromOffset(v4, v4), testId = "tilt-keyart" }

	local v7 = {
		Square = React.createElement(View, {
			tag = "position-center-center anchor-center-center stroke-standard stroke-system-neutral",
			testId = "tilt-keyart-frame",
			Size = frame.sizeScale:map(function(p)
				return UDim2.fromOffset(v5 * p, v5 * p)
			end),
			Rotation = frame.rotation,
			GroupTransparency = frame.groupTransparency,
			Visible = frame.groupTransparency:map(function(p): boolean
				return p < 1
			end),
			ZIndex = 1
		}),
		Keyart = 0
	}

	local createElement2 = React.createElement
	local v8 = {
		tag = "position-center-center anchor-center-center",
		testId = "tilt-keyart-card",
		Size = keyart.sizeScale:map(function(p)
			return UDim2.fromOffset(v5 * p, v5 * p)
		end),
		Rotation = keyart.rotation,
		ZIndex = 2
	}
	local thumbnailSkeleton

	if not state then
		thumbnailSkeleton = React.createElement(Skeleton, {
			tag = "size-full",
			ZIndex = 1,
			testId = "tilt-keyart-skeleton"
		})
	end

	local thumbnail

	if props.thumbnailUrl ~= "" then
		thumbnail = React.createElement(Image, {
			tag = "size-full radius-small",
			Image = props.thumbnailUrl,
			ScaleType = Enum.ScaleType.Crop,
			ImageTransparency = state and 0 or 1,
			onLoaded = onLoaded,
			ZIndex = 2,
			testId = "tilt-keyart-thumbnail"
		})
	end

	v7.Keyart = createElement2(View, v8, {
		ThumbnailSkeleton = thumbnailSkeleton,
		Thumbnail = thumbnail,
		RevealCover = React.createElement(View, {
			tag = "size-full",
			backgroundStyle = keyart.coverTransparency:map(function(transparency)
				return {
					Color3 = v3.Color.Extended.Black.Black_100.Color3,
					Transparency = transparency
				}
			end),
			ZIndex = 3
		})
	})
	return createElement(View, v6, v7)
end

return React.memo(TiltKeyart)
