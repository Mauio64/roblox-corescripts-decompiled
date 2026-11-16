local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local ScrollSection = require(AvatarExperienceProfilePictureEditor.Components.ScrollSection)
local SectionHeader = require(AvatarExperienceProfilePictureEditor.Components.SectionTitle.SectionHeader)
local AssetPickerGrid = require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.AssetPickerGrid)
local VirtualizedFeedContainer = require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.VirtualizedFeedContainer)
local getAssetPickerStatus = require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local EditProfileImageActionsContext = require(AvatarExperienceProfilePictureEditor.Context.EditProfileImageActionsContext)
local useEditProfileImageActions = EditProfileImageActionsContext.useEditProfileImageActions

local function ExpandedEmotesGridContent(props)
	local v = useTokens()
	local v2 = useEditProfileImageActions()
	local v3 = useLocalization({
		emotes = TextKeys.Emotes,
		details = TextKeys.DetailsButton,
		recommendations = TextKeys.Recommendations,
		shopForMore = TextKeys.ShopForMore
	})

	local labels = React.useMemo(function()
		return { details = v3.details }
	end, { v3.details })
	local assetPickerStatus = getAssetPickerStatus(props.emotesLoading, props.emotesError)
	local v4 = assetPickerStatus ~= "ready" or props.useInternalScroll
	local element = React.createElement(View, {
		tag = {
			["auto-xy padding-x-xlarge"] = v4,
			["auto-xy padding-x-xlarge padding-bottom-medium"] = not v4
		}
	}, {
		Title = React.createElement(SectionHeader, { title = v3.emotes, onBack = props.onTitleBack })
	})

	if assetPickerStatus ~= "ready" then
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
					status = assetPickerStatus,
					items = props.ownedEmoteItems,
					onRetry = props.onRetryEmotes,
					selectedId = props.selectedEmoteId,
					onSelect = props.onSelectEmote,
					onDetailsActivated = v2.onOpenEmoteDetails,
					tileSize = props.tileSize,
					containerWidth = props.containerWidth,
					layoutOrder = 1
				})
			}
		)
	end

	local listFooterComponent

	if not (props.hasMoreEmotes or props.isLoadingMoreEmotes or props.hasLoadMoreEmotesError) then
		listFooterComponent = React.createElement(View, {
			tag = "col size-full-0 auto-y padding-top-xlarge"
		}, {
			Recommendations = React.createElement(AssetPickerGrid, {
				title = v3.recommendations,
				items = props.recommendedEmoteItems,
				selectedId = props.selectedEmoteId,
				onSelect = props.onSelectEmote,
				onDetailsActivated = v2.onOpenEmoteDetails,
				footerComponent = React.createElement(Button, {
					text = v3.shopForMore,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium,
					fillBehavior = FillBehavior.Fill,
					onActivated = v2.onShopForMoreEmotes
				}),
				tileSize = props.tileSize,
				containerWidth = props.containerWidth,
				layoutOrder = 2
			})
		})
	end

	local createElement = React.createElement
	local v5 = {
		tag = {
			["col grow gap-medium size-full-0 padding-top-xlarge"] = v4,
			["col grow size-full-0 padding-top-xlarge"] = not v4
		},
		LayoutOrder = props.layoutOrder
	}
	local header

	if v4 then
		header = element
	end

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v6 = {
		items = props.ownedEmoteItems,
		selectedId = props.selectedEmoteId,
		onSelect = props.onSelectEmote,
		onDetailsActivated = v2.onOpenEmoteDetails,
		labels = labels,
		minTileSize = props.tileSize,
		initialContainerWidth = props.containerWidth,
		gap = v.Gap.Medium,
		horizontalPadding = v.Padding.XLarge,
		strokeInset = v.Padding.XSmall,
		onMoreItems = props.onMoreEmotes,
		hasMoreItems = props.hasMoreEmotes,
		isLoadingMore = props.isLoadingMoreEmotes,
		hasLoadMoreError = props.hasLoadMoreEmotesError,
		onRetryLoadMore = props.onMoreEmotes,
		listHeaderComponent = 0,
		listFooterComponent = 0
	}

	if v4 then
		element = nil
	end

	v6.listHeaderComponent = element
	v6.listFooterComponent = listFooterComponent
	return createElement(View, v5, {
		Header = header,
		FeedContainer = createElement2(View, {
			tag = "grow size-full-0",
			LayoutOrder = v4 and 2 or 1
		}, {
			Feed = createElement3(VirtualizedFeedContainer, v6)
		})
	})
end

return ExpandedEmotesGridContent
