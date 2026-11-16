local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")

local view = Foundation.View
local iconName = Foundation.Enums.IconName
local useLocalization = Localization.Hooks.useLocalization

local ScrollSection = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/ScrollSection")
local AssetPickerCarousel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerCarousel")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")
local ShopMoreCarouselTile = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/ShopMoreCarouselTile")
local getAssetPickerStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getAssetPickerStatus")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local useEditProfileImageActions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Context/EditProfileImageActionsContext").useEditProfileImageActions

local function CombinedCarouselsContent(props)
	local v5 = useEditProfileImageActions()
	local v6 = useLocalization({
		emotes = TextKeys.Emotes,
		frames = TextKeys.Frames,
		shopForMore = TextKeys.ShopForMore
	})

	local v7 = getAssetPickerStatus(props.emotesLoading, props.emotesError)
	local showFrames = props.showFrames
	local v8

	if v7 == "ready" then
		v8 = React.createElement(ShopMoreCarouselTile, {
			label = v6.shopForMore,
			tileSize = props.tileSize,
			layoutOrder = #props.emoteItems + 1,
			onActivated = v5.onShopForMoreEmotes
		})
	end

	local createElement = React.createElement
	local v10 = {
		layoutOrder = props.layoutOrder,
		pinHeader = false,
		useInternalScroll = props.useInternalScroll
	}

	local createElement2 = React.createElement

	local v14 = {
		Emotes = React.createElement(AssetPickerCarousel, {
			title = v6.emotes,
			status = v7,
			onRetry = props.onRetryEmotes,
			items = props.emoteItems,
			selectedId = props.selectedEmoteId,
			onSelect = props.onSelectEmote,
			onDetailsActivated = v5.onOpenEmoteDetails,
			onTitleActivated = props.onExpandEmotes,
			trailingCarouselComponent = v8,
			tileSize = props.tileSize,
			layoutOrder = 1
		}),
		Frames = 0
	}

	local v15 = if showFrames then React.createElement(AssetPickerCarousel, {
		title = v6.frames,
		titleLeadingIconName = iconName.RobloxPlus,
		status = getAssetPickerStatus(props.framesLoading, props.framesError),
		onRetry = props.onRetryFrames,
		bannerComponent = props.framesBannerComponent,
		items = props.frameItems,
		selectedId = props.selectedFrameId,
		onSelect = props.onSelectFrame,
		onTitleActivated = props.onExpandFrames,
		tileSize = props.tileSize,
		layoutOrder = 2
	}) else nil
	v14.Frames = v15
	return createElement(ScrollSection, v10, {
		Sections = createElement2(view, { tag = "col gap-xsmall size-full-0 auto-y" }, v14)
	})
end

return CombinedCarouselsContent
