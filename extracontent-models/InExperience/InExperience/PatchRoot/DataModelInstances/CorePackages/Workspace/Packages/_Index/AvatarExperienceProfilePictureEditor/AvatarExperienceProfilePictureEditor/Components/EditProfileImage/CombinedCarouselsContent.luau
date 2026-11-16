local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local View = Foundation.View
local IconName = Foundation.Enums.IconName
local useLocalization = Localization.Hooks.useLocalization

local ScrollSection = require(AvatarExperienceProfilePictureEditor.Components.ScrollSection)
local AssetPickerCarousel = require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.AssetPickerCarousel)
require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.AssetPickerTile)
local ShopMoreCarouselTile = require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.ShopMoreCarouselTile)
local getAssetPickerStatus = require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local EditProfileImageActionsContext = require(AvatarExperienceProfilePictureEditor.Context.EditProfileImageActionsContext)
local useEditProfileImageActions = EditProfileImageActionsContext.useEditProfileImageActions

local function CombinedCarouselsContent(props)
	local v = useEditProfileImageActions()
	local v2 = useLocalization({
		emotes = TextKeys.Emotes,
		frames = TextKeys.Frames,
		shopForMore = TextKeys.ShopForMore
	})

	local assetPickerStatus = getAssetPickerStatus(props.emotesLoading, props.emotesError)
	local showFrames = props.showFrames
	local trailingCarouselComponent

	if assetPickerStatus == "ready" then
		trailingCarouselComponent = React.createElement(ShopMoreCarouselTile, {
			label = v2.shopForMore,
			tileSize = props.tileSize,
			layoutOrder = #props.emoteItems + 1,
			onActivated = v.onShopForMoreEmotes
		})
	end

	local createElement = React.createElement
	local v3 = {
		layoutOrder = props.layoutOrder,
		pinHeader = false,
		useInternalScroll = props.useInternalScroll
	}

	local createElement2 = React.createElement

	local v4 = {
		Emotes = React.createElement(AssetPickerCarousel, {
			title = v2.emotes,
			status = assetPickerStatus,
			onRetry = props.onRetryEmotes,
			items = props.emoteItems,
			selectedId = props.selectedEmoteId,
			onSelect = props.onSelectEmote,
			onDetailsActivated = v.onOpenEmoteDetails,
			onTitleActivated = props.onExpandEmotes,
			trailingCarouselComponent = trailingCarouselComponent,
			tileSize = props.tileSize,
			layoutOrder = 1
		}),
		Frames = 0
	}
	local frames

	if showFrames then
		frames = React.createElement(AssetPickerCarousel, {
			title = v2.frames,
			titleLeadingIconName = IconName.RobloxPlus,
			status = getAssetPickerStatus(props.framesLoading, props.framesError),
			onRetry = props.onRetryFrames,
			bannerComponent = props.framesBannerComponent,
			items = props.frameItems,
			selectedId = props.selectedFrameId,
			onSelect = props.onSelectFrame,
			onTitleActivated = props.onExpandFrames,
			tileSize = props.tileSize,
			layoutOrder = 2
		})
	end

	v4.Frames = frames
	return createElement(ScrollSection, v3, {
		Sections = createElement2(View, { tag = "col gap-xsmall size-full-0 auto-y" }, v4)
	})
end

return CombinedCarouselsContent
