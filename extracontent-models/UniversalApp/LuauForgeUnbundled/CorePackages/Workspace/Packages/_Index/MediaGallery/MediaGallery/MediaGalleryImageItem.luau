local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Foundation")
local useTokens = Foundation.Hooks.useTokens
local iconButton = Foundation.IconButton
local inputSize = Foundation.Enums.InputSize
local buttonVariant = Foundation.Enums.ButtonVariant

local image = Foundation.Image

require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryTypes")

local getImageUri = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/getImageUri")

local function MediaGalleryImageItem(props)
	local v5 = useTokens()

	local v6 = props.imageId

	if props.isYouTubeVideo and (v6 == nil or v6 == "") and props.videoHash then
		v6 = string.format("https://img.youtube.com/vi/%s/hqdefault.jpg", props.videoHash)
	end

	local udim = UDim.new(0, props.cornerRadius or v5.Radius.Medium)

	React.useEffect(function()
		if v6 then
			task.spawn(function()
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Image = getImageUri(v6)
				local ContentProvider = game:GetService("ContentProvider")
				ContentProvider:PreloadAsync({ imageLabel })
				imageLabel:Destroy()
			end)
		end
	end, { v6 })

	local v7 = React.useCallback(function(p2)
		if props.onMediaResolved then
			props.onMediaResolved(p2 == Enum.AssetFetchStatus.Success)
		end
	end, { props.onMediaResolved })

	local v8 = React.useCallback(function()
		if not props.onYouTubeVideoPlay then
			return
		end

		props.onYouTubeVideoPlay({
			index = props.itemIndex,
			imageId = v6,
			videoHash = props.videoHash or "",
			videoTitle = props.videoTitle
		})
	end, {
		props.videoHash,
		props.videoTitle,
		v6,
		props.onYouTubeVideoPlay,
		props.itemIndex
	})

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.itemIndex,
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		cornerRadius = udim,
		Size = UDim2.fromScale(1, 1),
		Image = getImageUri(v6),
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = 1,
		onLoaded = 0
	}

	if not props.onMediaResolved then
		v7 = nil
	end

	v13.onLoaded = v7
	local v11 = {
		Image = createElement2(image, v13),
		GradientOverlay = 0,
		PlayButton = 0,
		ItemOverlay = 0
	}

	local v14 = if props.showGradient ~= false and not not props.gradientOverlayHeight then React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, props.gradientOverlayHeight),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 2
	}, {
		Gradient = React.createElement("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0.2)
			})
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = udim })
	}) else nil
	v11.GradientOverlay = v14

	local v15 = if props.isYouTubeVideo then React.createElement(iconButton, {
		icon = { name = Foundation.Enums.IconName.PlayLarge },
		size = inputSize.Large,
		variant = buttonVariant.OverMedia,
		isCircular = true,
		onActivated = v8,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -v5.Size.Size_500, 1, -v5.Size.Size_500),
		ZIndex = 3
	}) else nil
	v11.PlayButton = v15

	local v16 = if props.overlay then React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5 },
		{ Overlay = props.overlay }
	) else nil
	v11.ItemOverlay = v16
	return createElement("Frame", v10, v11)
end

return React.memo(MediaGalleryImageItem)
