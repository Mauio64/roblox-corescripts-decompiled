local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local Constants = require(AppChat.Constants)
local RoundedVariant = require(AppChat.Enums.RoundedVariant)
local FoundationText = Foundation.Text
local Skeleton = Foundation.Skeleton
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local useAbbreviatedNumberLocalization = require(AppChatParent.Localization).Hooks.useAbbreviatedNumberLocalization
local GameCardThumbnail = require(script.Parent.GameCardThumbnail)
local t1 = {
	thumbnailAspectRatio = 1.7777777777777777,
	cornerRadius = 20,
	isRepliedTo = false,
	isIncoming = false,
	isPending = false,
	thumbnailRoundedVariant = RoundedVariant.Top
}

function GameCardGroupable(t2: {[any]: any}) -- line: 62
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useAbbreviatedNumberLocalization (copy), useScaledValue (copy), Constants (copy), React (copy), View (copy), GameCardThumbnail (copy), Skeleton (copy), Foundation (copy), FoundationText (copy), Icon (copy), IconName (copy), IconSize (copy)
	local v20 = Cryo.Dictionary.union(t1, t2)
	local v21 = useTokens()
	local v22 = useAbbreviatedNumberLocalization(v20.gamePlayerCount)
	local Size_1600 = v21.Size.Size_1600
	local uDim2 = UDim2.fromOffset(useScaledValue(Constants.GameCard.THUMBNAIL_WIDTH), useScaledValue(Constants.GameCard.THUMBNAIL_HEIGHT))
	local uDim2_2 = UDim2.new(1, 0, 0, Size_1600)
	local v26 = if not v20.isRepliedTo then v21.Color.Content.Emphasis else v21.Color.Content.Default

	return React.createElement(View, {
		tag = "col auto-xy",
		LayoutOrder = v20.LayoutOrder
	}, {
		ThumbnailContainer = React.createElement(View, {
			LayoutOrder = 1,
			Size = uDim2
		}, {
			Thumbnail = React.createElement(GameCardThumbnail, {
				LayoutOrder = 1,
				gameThumbnail = v20.gameThumbnail,
				cornerRadius = v20.cornerRadius,
				roundedVariant = v20.thumbnailRoundedVariant,
				aspectRatio = v20.thumbnailAspectRatio,
				onActivated = v20.onThumbnailActivated,
				Visible = not v20.isLoading
			})
		}),
		Footer = React.createElement(View, {
			tag = "padding-medium",
			LayoutOrder = 2,
			Size = uDim2_2
		}, {
			Skeleton = React.createElement(View, {
				tag = "col size-full-full gap-xsmall",
				Visible = v20.isLoading
			}, {
				TitleSkeleton = React.createElement(View, {
					tag = "grow-4",
					LayoutOrder = 1,
					Size = UDim2.new(0.9, 0, 0, 0)
				}, { React.createElement(Skeleton, {
					tag = "size-full-full",
					radius = Foundation.Enums.Radius.Small
				}) }),
				MetadataSkeleton = React.createElement(View, {
					tag = "grow-3",
					LayoutOrder = 2,
					Size = UDim2.new(0.5, 0, 0, 0)
				}, { React.createElement(Skeleton, {
					tag = "size-full-full",
					radius = Foundation.Enums.Radius.Small
				}) })
			}),
			Content = React.createElement(View, {
				tag = "row size-full-full gap-small items-center align-y-center flex-between",
				Visible = not v20.isLoading
			}, {
				TextContainer = React.createElement(View, {
					tag = "col size-0-full fill align-y-center radius-small",
					LayoutOrder = 1,
					onActivated = v20.onMetadataActivated,
					Selectable = v20.onMetadataActivated ~= nil
				}, {
					Title = if not v20.gameName then nil else React.createElement(FoundationText, {
						tag = "auto-y size-full-500 text-title-medium text-align-x-left text-truncate-split",
						LayoutOrder = 1,
						Text = v20.gameName,
						textStyle = v26
					}),
					Metadata = if not v20.gameRating and not v22 then nil else React.createElement(View, {
						tag = "row auto-y size-full-500 gap-medium align-y-center",
						LayoutOrder = 2
					}, {
						RatingContainer = if not v20.gameRating then nil else React.createElement(View, {
							tag = "auto-xy row gap-xsmall align-y-center",
							LayoutOrder = 1
						}, {
							RatingIcon = React.createElement(Icon, {
								LayoutOrder = 1,
								name = IconName.ThumbUp,
								size = IconSize.Small
							}),
							Rating = React.createElement(FoundationText, {
								tag = "auto-xy text-body-small content-default text-truncate-split",
								LayoutOrder = 2,
								Text = v20.gameRating
							})
						}),
						PlayerCountContainer = if not v22 then nil else React.createElement(View, {
							tag = "auto-xy row gap-xsmall align-y-center",
							LayoutOrder = 2
						}, {
							PlayerCountIcon = React.createElement(Icon, {
								LayoutOrder = 1,
								name = IconName.PersonPlay,
								size = IconSize.Small
							}),
							PlayerCount = React.createElement(FoundationText, {
								tag = "auto-xy text-body-small content-default text-truncate-split",
								LayoutOrder = 2,
								Text = v22
							})
						})
					})
				}),
				PlayButton = if not v20.onPlayButtonActivated then nil else React.createElement(Foundation.IconButton, {
					isCircular = true,
					LayoutOrder = 2,
					icon = IconName.PlayLarge,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = v20.onPlayButtonActivated
				})
			})
		})
	})
end

return React.memo(GameCardGroupable)
