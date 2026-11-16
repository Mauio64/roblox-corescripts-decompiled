local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")

local view = Foundation.View
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local ScrollSection = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/ScrollSection")
local SectionHeader = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/SectionTitle/SectionHeader")
local AssetPickerGrid = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerGrid")
local VirtualizedFeedContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/VirtualizedFeedContainer")
local getAssetPickerStatus = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getAssetPickerStatus")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local useEditProfileImageActions = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Context/EditProfileImageActionsContext").useEditProfileImageActions

local function ExpandedEmotesGridContent(props)
	local v5 = useTokens()
	local v6 = useEditProfileImageActions()
	local v7 = useLocalization({
		emotes = TextKeys.Emotes,
		details = TextKeys.DetailsButton,
		recommendations = TextKeys.Recommendations,
		shopForMore = TextKeys.ShopForMore
	})

	local v8 = React.useMemo(function()
		return { details = v7.details }
	end, { v7.details })
	local v9 = getAssetPickerStatus(props.emotesLoading, props.emotesError)
	local v10 = v9 ~= "ready" or props.useInternalScroll
	local element = React.createElement(view, {
		tag = {
			["auto-xy padding-x-xlarge"] = v10,
			["auto-xy padding-x-xlarge padding-bottom-medium"] = not v10
		}
	}, {
		Title = React.createElement(SectionHeader, {
			title = v7.emotes,
			onBack = props.onTitleBack
		})
	})

	if v9 ~= "ready" then
		return React.createElement(
			ScrollSection,
			{
				layoutOrder = props.layoutOrder,
				pinHeader = true,
				useInternalScroll = true,
				header = element
			},
			{
				OwnedEmotes = React.createElement(AssetPickerGrid, {
					status = v9,
					items = props.ownedEmoteItems,
					onRetry = props.onRetryEmotes,
					selectedId = props.selectedEmoteId,
					onSelect = props.onSelectEmote,
					onDetailsActivated = v6.onOpenEmoteDetails,
					tileSize = props.tileSize,
					containerWidth = props.containerWidth,
					layoutOrder = 1
				})
			}
		)
	end

	local v11

	if not (props.hasMoreEmotes or props.isLoadingMoreEmotes or props.hasLoadMoreEmotesError) then
		v11 = React.createElement(view, {
			tag = "col size-full-0 auto-y padding-top-xlarge"
		}, {
			Recommendations = React.createElement(AssetPickerGrid, {
				title = v7.recommendations,
				items = props.recommendedEmoteItems,
				selectedId = props.selectedEmoteId,
				onSelect = props.onSelectEmote,
				onDetailsActivated = v6.onOpenEmoteDetails,
				footerComponent = React.createElement(button, {
					text = v7.shopForMore,
					variant = buttonVariant.Standard,
					size = inputSize.Medium,
					fillBehavior = fillBehavior.Fill,
					onActivated = v6.onShopForMoreEmotes
				}),
				tileSize = props.tileSize,
				containerWidth = props.containerWidth,
				layoutOrder = 2
			})
		})
	end

	local createElement = React.createElement
	local v13 = {
		tag = {
			["col grow gap-medium size-full-0 padding-top-xlarge"] = v10,
			["col grow size-full-0 padding-top-xlarge"] = not v10
		},
		LayoutOrder = props.layoutOrder
	}
	local v14 = {
		Header = if v10 then element else nil,
		FeedContainer = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v20 = {
		items = props.ownedEmoteItems,
		selectedId = props.selectedEmoteId,
		onSelect = props.onSelectEmote,
		onDetailsActivated = v6.onOpenEmoteDetails,
		labels = v8,
		minTileSize = props.tileSize,
		initialContainerWidth = props.containerWidth,
		gap = v5.Gap.Medium,
		horizontalPadding = v5.Padding.XLarge,
		strokeInset = v5.Padding.XSmall,
		onMoreItems = props.onMoreEmotes,
		hasMoreItems = props.hasMoreEmotes,
		isLoadingMore = props.isLoadingMoreEmotes,
		hasLoadMoreError = props.hasLoadMoreEmotesError,
		onRetryLoadMore = props.onMoreEmotes,
		listHeaderComponent = 0,
		listFooterComponent = 0
	}

	if v10 then
		element = nil
	end

	v20.listHeaderComponent = element
	v20.listFooterComponent = v11
	v14.FeedContainer = createElement2(view, {
		tag = "grow size-full-0",
		LayoutOrder = v10 and 2 or 1
	}, { Feed = createElement3(VirtualizedFeedContainer, v20) })
	return createElement(view, v13, v14)
end

return ExpandedEmotesGridContent
