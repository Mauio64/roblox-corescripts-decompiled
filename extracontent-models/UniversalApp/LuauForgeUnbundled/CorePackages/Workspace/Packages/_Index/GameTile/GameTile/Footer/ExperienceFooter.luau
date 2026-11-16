local module = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/CoPlayFooter")
local usePlayerCountText = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/usePlayerCountText")
require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local statGroup = UIBlox.App.Indicator.StatGroup
local textFooter = UIBlox.App.Tile.ExperienceTileMetadata.TextFooter
local coPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local socialProofFooter = UIBlox.App.Tile.ExperienceTileMetadata.SocialProofFooter
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useLocalization
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").Colors
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").useDesignTokens
local sponsoredTooltipHover = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Ads").SponsoredTooltipHover
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/ArgCheck")
local getUserInputIsSelectionOnly = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getUserInputIsSelectionOnly")

local udim = UDim2.fromScale(1, 1)

return function(props)
	if props.automaticSize then
		ArgCheck.isNotNil(
			props.size,
			"If props.automaticSize is defined, props.size should also be defined.  Otherwise size falls back to a 1, 1 scale for this component."
		)
	end

	local isShowSponsoredLabel = props.isSponsored and props.isShowSponsoredLabel

	local isStatsOnly = props.isStatsOnly
	local isPlayable = props.isPlayable
	local requiresPurchase = props.requiresPurchase
	local rating = props.rating or ""
	local playingCount = props.playingCount or 0
	local coPlayFriends = props.coPlayFriends
	local showAgeRating = props.showAgeRating
	local ageRatingTextLabel = props.ageRatingTextLabel
	local useExperienceTileMetadata = props.useExperienceTileMetadata
	local onActivateSponsoredTooltip = props.onActivateSponsoredTooltip

	local v5 = usePlayerCountText(playingCount)

	local v6 = useStyle()
	local font = v6.Font
	local theme = v6.Theme

	local size = useDesignTokens().Size

	local v7 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		notPlayableText = "Feature.ExperienceDetails.Label.NotPlayable",
		ageRatingText = ageRatingTextLabel or nil,
		friendsText = useExperienceTileMetadata and "CommonUI.Features.Label.Friends" or nil
	})

	if not isStatsOnly then
		if isShowSponsoredLabel then
			local v8 = getUserInputIsSelectionOnly()

			local element = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				},
				{
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 4)
					}),
					SponsoredText = React.createElement(styledTextLabel, {
						colorStyle = theme.TextEmphasis,
						fontStyle = font.CaptionHeader,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Center,
						automaticSize = Enum.AutomaticSize.X,
						size = UDim2.new(0, 0, 1, 0),
						lineHeight = 1,
						text = v7.sponsoredText,
						textTruncate = Enum.TextTruncate.AtEnd,
						richText = false,
						layoutOrder = 1
					}),
					SponsoredTooltip = React.createElement(sponsoredTooltipHover, {
						tooltipOrientation = tooltipOrientation.Bottom,
						onActivateTooltip = onActivateSponsoredTooltip,
						size = UDim2.new(0, 16, 0, 16),
						color = theme.TextEmphasis.Color,
						layoutOrder = 2,
						selectable = v8
					})
				}
			)

			if not useExperienceTileMetadata then
				return React.createElement("Frame", {
					Size = props.size or udim,
					Position = props.position,
					AnchorPoint = props.anchorPoint,
					LayoutOrder = props.layoutOrder,
					BackgroundTransparency = theme.UIDefault.Transparency,
					BackgroundColor3 = theme.UIDefault.Color,
					AutomaticSize = props.automaticSize
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 4)
					}),
					SponsoredLabel = element
				})
			end

			local createElement = React.createElement
			local v10 = {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v6.Tokens.Color.Shift.Shift_200.Color3,
				BackgroundTransparency = v6.Tokens.Color.Shift.Shift_200.Transparency,
				BorderSizePixel = 0
			}

			local children = {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 4)
				}),
				Text = 0,
				SponsoredTooltip = 0
			}

			local createElement2 = React.createElement
			local v12 = {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = v7.sponsoredText,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				LayoutOrder = 1
			}
			local v13 = if not foundationFontFaceMigration then v6.Font.CaptionHeader.Font else nil
			v12.Font = v13

			local v14 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.CaptionLarge.Font) else nil
			v12.FontFace = v14

			v12.TextSize = v6.Font.BaseSize * v6.Font.CaptionHeader.RelativeSize
			v12.TextColor3 = v6.Tokens.Color.Content.Emphasis.Color3
			v12.TextTransparency = v6.Tokens.Color.Content.Emphasis.Transparency
			children.Text = createElement2("TextLabel", v12)

			children.SponsoredTooltip = React.createElement(sponsoredTooltipHover, {
				tooltipOrientation = tooltipOrientation.Bottom,
				onActivateTooltip = onActivateSponsoredTooltip,
				size = UDim2.new(0, 16, 0, 16),
				color = v6.Tokens.Color.Content.Emphasis.Color3,
				layoutOrder = 2,
				selectable = v8,
				supportTenFootUi = true
			})
			return (createElement("Frame", v10, children, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v6.Tokens.Radius.Small)
				})
			}))
		elseif coPlayFriends and next(coPlayFriends) then
			if useExperienceTileMetadata then
				return React.createElement(coPlayFooter, {
					users = coPlayFriends,
					labelText = v7.friendsText,
					showEmphasisBorder = true,
					faceGroupCount = 2,
					styleProps = {
						faceWidth = size.Size_500,
						faceHeight = size.Size_500,
						faceGroupGap = -size.Size_150,
						containerGap = size.Size_100,
						badgeBorderWidth = 3,
						badgeHeight = size.Size_500,
						fontStyle = v6.Font.CaptionHeader,
						badgeSpacingLeading = size.Size_100,
						badgeSpacingTrailing = size.Size_100,
						badgeBackgroundColor = {
							Color = colors.Smoke,
							Transparency = 0
						},
						badgeContentColor = { Color = colors.White, Transparency = 0 }
					}
				})
			end

			local element = React.createElement(module, { friends = coPlayFriends })

			return React.createElement("Frame", {
				Size = props.size or udim,
				Position = props.position,
				AnchorPoint = props.anchorPoint,
				LayoutOrder = props.layoutOrder,
				BackgroundTransparency = 1,
				AutomaticSize = props.automaticSize
			}, { CoPlayFooter = element })
		elseif showAgeRating then
			local v8

			if props.localizedAgeRatingTextLabel then
				v8 = props.localizedAgeRatingTextLabel
			else
				v8 = v7.ageRatingText
			end

			if useExperienceTileMetadata then
				return React.createElement(textFooter, { text = v8 })
			end

			return React.createElement("Frame", {
				Size = props.size or udim,
				Position = props.position,
				AnchorPoint = props.anchorPoint,
				LayoutOrder = props.layoutOrder,
				BackgroundTransparency = 1,
				AutomaticSize = props.automaticSize
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 0),
					PaddingBottom = UDim.new(0, 2),
					PaddingLeft = UDim.new(0, 0)
				}),
				AgeRatingLabel = React.createElement(styledTextLabel, {
					colorStyle = theme.TextEmphasis,
					fontStyle = font.CaptionHeader,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					size = UDim2.new(1, 0, 2, 0),
					lineHeight = 1,
					text = v8,
					textTruncate = Enum.TextTruncate.AtEnd,
					richText = false
				})
			})
		elseif props.showFriendActivity and not useExperienceTileMetadata then
			local font2 = font.Body.Font
			local v8 = font.BaseSize * font.Body.RelativeSize

			local createElement = React.createElement
			local v10 = {
				Size = props.size or udim,
				TextColor3 = theme.TextMuted.Color,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextYAlignment = 0,
				Text = 0,
				TextTruncate = 0,
				TextSize = 0,
				TextTransparency = 0,
				BackgroundTransparency = 1
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v10.Font = font2

			local v11 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
			v10.FontFace = v11

			v10.TextXAlignment = Enum.TextXAlignment.Left
			v10.TextYAlignment = Enum.TextYAlignment.Center
			v10.Text = props.friendActivityTitle
			v10.TextTruncate = Enum.TextTruncate.AtEnd
			v10.TextSize = v8
			v10.TextTransparency = theme.TextMuted.Transparency
			return createElement("TextLabel", v10)
		elseif isPlayable == false and not requiresPurchase then
			if useExperienceTileMetadata then
				return React.createElement(textFooter, { text = v7.notPlayableText })
			end

			return React.createElement("Frame", {
				Size = props.size or udim,
				Position = props.position,
				AnchorPoint = props.anchorPoint,
				LayoutOrder = props.layoutOrder,
				BackgroundTransparency = 1,
				AutomaticSize = props.automaticSize
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 4)
				}),
				PlayabilityLabel = React.createElement(styledTextLabel, {
					colorStyle = theme.TextMuted,
					fontStyle = font.CaptionHeader,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					size = UDim2.new(1, 0, 1, 0),
					lineHeight = 1,
					text = v7.notPlayableText,
					textTruncate = Enum.TextTruncate.AtEnd,
					richText = false
				})
			})
		end
	end

	if useExperienceTileMetadata then
		return React.createElement(socialProofFooter, {
			ratingText = rating,
			playingText = v5
		})
	end

	local element = React.createElement(statGroup, {
		ratingText = rating,
		playingText = v5
	})

	return React.createElement("Frame", {
		Size = props.size or udim,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		AutomaticSize = props.automaticSize
	}, { ExperienceStats = element })
end
