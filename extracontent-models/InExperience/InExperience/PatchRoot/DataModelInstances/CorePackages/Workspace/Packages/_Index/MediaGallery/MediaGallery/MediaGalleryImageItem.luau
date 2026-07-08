local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local Foundation = require(MediaGalleryParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FoundationImage = Foundation.Image

require(MediaGallery.MediaGalleryTypes)

local getImageUri = require(MediaGallery.getImageUri)
local FFlagSduiExperienceDetailsSupport = require(MediaGalleryParent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function MediaGalleryImageItem(t1: {[any]: any}) -- line: 37
	-- upvalues: useTokens (copy), React (copy), getImageUri (copy), FFlagSduiExperienceDetailsSupport (copy), FoundationImage (copy), IconButton (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy)
	local v14 = useTokens()
	local imageId = t1.imageId

	if t1.isYouTubeVideo and ((imageId == nil or imageId == "") and t1.videoHash) then
		imageId = string.format("https://img.youtube.com/vi/%s/hqdefault.jpg", t1.videoHash)
	end

	local uDim = UDim.new(0, t1.cornerRadius or v14.Radius.Medium)

	React.useEffect(function() -- line: 46
		-- upvalues: imageId (ref), getImageUri (copy)
		if imageId then
			task.spawn(function() -- line: 48
				-- upvalues: getImageUri (copy), imageId (ref)
				local ImageLabel = Instance.new("ImageLabel")

				ImageLabel.Image = getImageUri(imageId)
				game:GetService("ContentProvider"):PreloadAsync({ ImageLabel })
				ImageLabel:Destroy()
			end)
		end
	end, { imageId })

	local v17 = nil

	if FFlagSduiExperienceDetailsSupport then
		v17 = React.useCallback(function(p1) -- line: 59
			-- upvalues: t1 (copy)
			if t1.onMediaResolved then
				t1.onMediaResolved(p1 == Enum.AssetFetchStatus.Success)
			end
		end, { t1.onMediaResolved })
	end

	local v18 = React.useCallback(function() -- line: 66
		-- upvalues: t1 (copy), imageId (ref)
		if not t1.onYouTubeVideoPlay then
			return
		end

		t1.onYouTubeVideoPlay({
			index = t1.itemIndex,
			imageId = imageId,
			videoHash = t1.videoHash or "",
			videoTitle = t1.videoTitle
		})
	end, {
		t1.videoHash,
		t1.videoTitle,
		imageId,
		t1.onYouTubeVideoPlay,
		t1.itemIndex
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.itemIndex,
		Size = t1.Size
	}, {
		Image = React.createElement(FoundationImage, {
			ZIndex = 1,
			cornerRadius = uDim,
			Size = UDim2.fromScale(1, 1),
			Image = getImageUri(imageId),
			ScaleType = Enum.ScaleType.Crop,
			onLoaded = if not FFlagSduiExperienceDetailsSupport or not t1.onMediaResolved then nil else v17
		}),
		GradientOverlay = if t1.showGradient == false or not t1.gradientOverlayHeight then nil else React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, t1.gradientOverlayHeight),
			BackgroundColor3 = Color3.new(0, 0, 0)
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.2)
				})
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = uDim
			})
		}),
		PlayButton = if not t1.isYouTubeVideo then nil else React.createElement(IconButton, {
			isCircular = true,
			ZIndex = 3,
			icon = {
				name = Foundation.Enums.IconName.PlayLarge
			},
			size = InputSize.Large,
			variant = ButtonVariant.OverMedia,
			onActivated = v18,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -v14.Size.Size_500, 1, -v14.Size.Size_500)
		}),
		ItemOverlay = if not t1.overlay then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 5,
			Size = UDim2.fromScale(1, 1)
		}, {
			Overlay = t1.overlay
		})
	})
end

return React.memo(MediaGalleryImageItem)
