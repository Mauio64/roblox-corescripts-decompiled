local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local Image = Foundation.Image

require(MediaGallery.MediaGalleryTypes)

local getImageUri = require(MediaGallery.getImageUri)

local function MediaGalleryImageItem(props)
	local v = useTokens()

	local imageId = props.imageId

	if props.isYouTubeVideo and (imageId == nil or imageId == "") and props.videoHash then
		imageId = string.format("https://img.youtube.com/vi/%s/hqdefault.jpg", props.videoHash)
	end

	local udim = UDim.new(0, props.cornerRadius or v.Radius.Medium)

	React.useEffect(function()
		if imageId then
			task.spawn(function()
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Image = getImageUri(imageId)
				local ContentProvider = game:GetService("ContentProvider")
				ContentProvider:PreloadAsync({ imageLabel })
				imageLabel:Destroy()
			end)
		end
	end, { imageId })

	local onLoaded = React.useCallback(function(p)
		if props.onMediaResolved then
			props.onMediaResolved(p == Enum.AssetFetchStatus.Success)
		end
	end, { props.onMediaResolved })

	local onActivated = React.useCallback(function()
		if not props.onYouTubeVideoPlay then
			return
		end

		props.onYouTubeVideoPlay({
			index = props.itemIndex,
			imageId = imageId,
			videoHash = props.videoHash or "",
			videoTitle = props.videoTitle
		})
	end, { props.videoHash, props.videoTitle, imageId, props.onYouTubeVideoPlay, props.itemIndex })

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.itemIndex,
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local v3 = {
		cornerRadius = udim,
		Size = UDim2.fromScale(1, 1),
		Image = getImageUri(imageId),
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = 1,
		onLoaded = 0
	}

	if not props.onMediaResolved then
		onLoaded = nil
	end

	v3.onLoaded = onLoaded
	local v4 = {
		Image = createElement2(Image, v3),
		GradientOverlay = 0,
		PlayButton = 0,
		ItemOverlay = 0
	}
	local gradientOverlay

	if not (props.showGradient == false or not props.gradientOverlayHeight) then
		gradientOverlay = React.createElement("Frame", {
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
		})
	end

	v4.GradientOverlay = gradientOverlay
	local playButton

	if props.isYouTubeVideo then
		playButton = React.createElement(IconButton, {
			icon = { name = Foundation.Enums.IconName.PlayLarge },
			size = InputSize.Large,
			variant = ButtonVariant.OverMedia,
			isCircular = true,
			onActivated = onActivated,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -v.Size.Size_500, 1, -v.Size.Size_500),
			ZIndex = 3
		})
	end

	v4.PlayButton = playButton
	local itemOverlay

	if props.overlay then
		itemOverlay = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5 },
			{ Overlay = props.overlay }
		)
	end

	v4.ItemOverlay = itemOverlay
	return createElement("Frame", v2, v4)
end

return React.memo(MediaGalleryImageItem)
