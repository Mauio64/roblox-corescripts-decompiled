local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local RoundedVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Enums/RoundedVariant")

local text = Foundation.Text
local skeleton = Foundation.Skeleton
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local useAbbreviatedNumberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useAbbreviatedNumberLocalization

local GameCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardThumbnail")

local v5 = {
	thumbnailAspectRatio = 16 / 9,
	thumbnailRoundedVariant = RoundedVariant.Top,
	isRepliedTo = false,
	isIncoming = false,
	isPending = false
}

function LUAUFORGE_MODULE_GLOBALS_hwp_GameCardGroupable(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = useTokens()
	local v7 = useAbbreviatedNumberLocalization(union.gamePlayerCount)
	local size_1600 = v6.Size.Size_1600
	local udim = UDim2.fromOffset(
		useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH),
		useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT)
	)

	local udim2 = UDim2.new(1, 0, 0, size_1600)

	local v8 = if union.isRepliedTo then v6.Color.Content.Default else v6.Color.Content.Emphasis

	local createElement = React.createElement
	local v10 = { tag = "col auto-xy", LayoutOrder = union.LayoutOrder }
	local v11 = {
		ThumbnailContainer = React.createElement(view, { Size = udim, LayoutOrder = 1 }, {
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

	local v14 = {
		Skeleton = React.createElement(
			view,
			{ tag = "col size-full-full gap-xsmall", Visible = union.isLoading },
			{
				TitleSkeleton = React.createElement(
					view,
					{ tag = "grow-4", Size = UDim2.new(0.9, 0, 0, 0), LayoutOrder = 1 },
					{ React.createElement(skeleton, {
							tag = "size-full-full",
							radius = Foundation.Enums.Radius.Small
						}) }
				),
				MetadataSkeleton = React.createElement(
					view,
					{ tag = "grow-3", Size = UDim2.new(0.5, 0, 0, 0), LayoutOrder = 2 },
					{ React.createElement(skeleton, {
							tag = "size-full-full",
							radius = Foundation.Enums.Radius.Small
						}) }
				)
			}
		),
		Content = 0
	}

	local createElement3 = React.createElement
	local v16 = {
		tag = "row size-full-full gap-small items-center align-y-center flex-between",
		Visible = not union.isLoading
	}

	local createElement4 = React.createElement
	local v19 = {
		tag = "col size-0-full fill align-y-center radius-small",
		LayoutOrder = 1,
		onActivated = union.onMetadataActivated,
		Selectable = union.onMetadataActivated ~= nil
	}

	local v21 = if union.gameName then React.createElement(text, {
		tag = "auto-y size-full-500 text-title-medium text-align-x-left text-truncate-split",
		Text = union.gameName,
		textStyle = v8,
		LayoutOrder = 1
	}) else nil
	local v22

	if union.gameRating or v7 then
		local createElement5 = React.createElement

		local v26 = if union.gameRating then React.createElement(
			view,
			{ tag = "auto-xy row gap-xsmall align-y-center", LayoutOrder = 1 },
			{
				RatingIcon = React.createElement(icon, {
					name = iconName.ThumbUp,
					size = iconSize.Small,
					LayoutOrder = 1
				}),
				Rating = React.createElement(text, {
					tag = "auto-xy text-body-small content-default text-truncate-split",
					Text = union.gameRating,
					LayoutOrder = 2
				})
			}
		) else nil

		local v27 = if v7 then React.createElement(
			view,
			{ tag = "auto-xy row gap-xsmall align-y-center", LayoutOrder = 2 },
			{
				PlayerCountIcon = React.createElement(icon, {
					name = iconName.PersonPlay,
					size = iconSize.Small,
					LayoutOrder = 1
				}),
				PlayerCount = React.createElement(text, {
					tag = "auto-xy text-body-small content-default text-truncate-split",
					Text = v7,
					LayoutOrder = 2
				})
			}
		) else nil
		v22 = createElement5(
			view,
			{
				tag = "row auto-y size-full-500 gap-medium align-y-center",
				LayoutOrder = 2
			},
			{ RatingContainer = v26, PlayerCountContainer = v27 }
		)
	end

	local v17 = {
		TextContainer = createElement4(view, v19, { Title = v21, Metadata = v22 }),
		PlayButton = 0
	}
	local v23

	if union.onPlayButtonActivated and union.playButtonLabel then
		v23 = React.createElement(Foundation.Button, {
			text = union.playButtonLabel,
			variant = Foundation.Enums.ButtonVariant.SubEmphasis,
			size = Foundation.Enums.InputSize.Small,
			onActivated = union.onPlayButtonActivated,
			LayoutOrder = 2
		})
	elseif union.onPlayButtonActivated then
		v23 = React.createElement(Foundation.IconButton, {
			icon = iconName.PlayLarge,
			isCircular = true,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = union.onPlayButtonActivated,
			LayoutOrder = 2
		})
	end

	v17.PlayButton = v23
	v14.Content = createElement3(view, v16, v17)
	v11.Footer = createElement2(view, {
		tag = "padding-medium",
		Size = udim2,
		LayoutOrder = 2
	}, v14)
	return createElement(view, v10, v11)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hwp_GameCardGroupable)
