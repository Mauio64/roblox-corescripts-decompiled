local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Constants = require(AppChat.Constants)
local RoundedVariant = require(AppChat.Enums.RoundedVariant)

local Text = Foundation.Text
local Skeleton = Foundation.Skeleton
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local Localization = require(parent.Localization)
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization

local GameCardThumbnail = require(script.Parent.GameCardThumbnail)

local v = {
	thumbnailAspectRatio = 16 / 9,
	thumbnailRoundedVariant = RoundedVariant.Top,
	isRepliedTo = false,
	isIncoming = false,
	isPending = false
}

function GameCardGroupable(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useTokens()
	local text = useAbbreviatedNumberLocalization(union.gamePlayerCount)
	local size_1600 = v2.Size.Size_1600
	local udim = UDim2.fromOffset(
		useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH),
		useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT)
	)

	local udim2 = UDim2.new(1, 0, 0, size_1600)
	local textStyle

	if union.isRepliedTo then
		textStyle = v2.Color.Content.Default
	else
		textStyle = v2.Color.Content.Emphasis
	end

	local createElement = React.createElement
	local v3 = { tag = "col auto-xy", LayoutOrder = union.LayoutOrder }
	local v4 = {
		ThumbnailContainer = React.createElement(View, { Size = udim, LayoutOrder = 1 }, {
			Thumbnail = React.createElement(GameCardThumbnail, {
				LayoutOrder = 1,
				gameThumbnail = union.gameThumbnail,
				roundedVariant = union.thumbnailRoundedVariant,
				aspectRatio = union.thumbnailAspectRatio,
				onActivated = union.onThumbnailActivated,
				Visible = not union.isLoading
			})
		}),
		Footer = 0
	}

	local createElement2 = React.createElement

	local v5 = {
		Skeleton = React.createElement(View, {
			tag = "col size-full-full gap-xsmall",
			Visible = union.isLoading
		}, {
			TitleSkeleton = React.createElement(
				View,
				{ tag = "grow-4", Size = UDim2.new(0.9, 0, 0, 0), LayoutOrder = 1 },
				{ React.createElement(Skeleton, {
						tag = "size-full-full",
						radius = Foundation.Enums.Radius.Small
					}) }
			),
			MetadataSkeleton = React.createElement(
				View,
				{ tag = "grow-3", Size = UDim2.new(0.5, 0, 0, 0), LayoutOrder = 2 },
				{ React.createElement(Skeleton, {
						tag = "size-full-full",
						radius = Foundation.Enums.Radius.Small
					}) }
			)
		}),
		Content = 0
	}

	local createElement3 = React.createElement
	local v6 = {
		tag = "row size-full-full gap-small items-center align-y-center flex-between",
		Visible = not union.isLoading
	}

	local createElement4 = React.createElement
	local v7 = {
		tag = "col size-0-full fill align-y-center radius-small",
		LayoutOrder = 1,
		onActivated = union.onMetadataActivated,
		Selectable = union.onMetadataActivated ~= nil
	}
	local title

	if union.gameName then
		title = React.createElement(Text, {
			tag = "auto-y size-full-500 text-title-medium text-align-x-left text-truncate-split",
			Text = union.gameName,
			textStyle = textStyle,
			LayoutOrder = 1
		})
	end

	local metadata

	if union.gameRating or text then
		local createElement5 = React.createElement
		local ratingContainer

		if union.gameRating then
			ratingContainer = React.createElement(
				View,
				{ tag = "auto-xy row gap-xsmall align-y-center", LayoutOrder = 1 },
				{
					RatingIcon = React.createElement(Icon, {
						name = IconName.ThumbUp,
						size = IconSize.Small,
						LayoutOrder = 1
					}),
					Rating = React.createElement(Text, {
						tag = "auto-xy text-body-small content-default text-truncate-split",
						Text = union.gameRating,
						LayoutOrder = 2
					})
				}
			)
		end

		local playerCountContainer

		if text then
			playerCountContainer = React.createElement(
				View,
				{ tag = "auto-xy row gap-xsmall align-y-center", LayoutOrder = 2 },
				{
					PlayerCountIcon = React.createElement(Icon, {
						name = IconName.PersonPlay,
						size = IconSize.Small,
						LayoutOrder = 1
					}),
					PlayerCount = React.createElement(Text, {
						tag = "auto-xy text-body-small content-default text-truncate-split",
						Text = text,
						LayoutOrder = 2
					})
				}
			)
		end

		metadata = createElement5(
			View,
			{ tag = "row auto-y size-full-500 gap-medium align-y-center", LayoutOrder = 2 },
			{ RatingContainer = ratingContainer, PlayerCountContainer = playerCountContainer }
		)
	end

	local v8 = {
		TextContainer = createElement4(View, v7, { Title = title, Metadata = metadata }),
		PlayButton = 0
	}
	local playButton

	if union.onPlayButtonActivated and union.playButtonLabel then
		playButton = React.createElement(Foundation.Button, {
			text = union.playButtonLabel,
			variant = Foundation.Enums.ButtonVariant.SubEmphasis,
			size = Foundation.Enums.InputSize.Small,
			onActivated = union.onPlayButtonActivated,
			LayoutOrder = 2
		})
	elseif union.onPlayButtonActivated then
		playButton = React.createElement(Foundation.IconButton, {
			icon = IconName.PlayLarge,
			isCircular = true,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = union.onPlayButtonActivated,
			LayoutOrder = 2
		})
	end

	v8.PlayButton = playButton
	v5.Content = createElement3(View, v6, v8)
	v4.Footer = createElement2(View, { tag = "padding-medium", Size = udim2, LayoutOrder = 2 }, v5)
	return createElement(View, v3, v4)
end

return React.memo(GameCardGroupable)
