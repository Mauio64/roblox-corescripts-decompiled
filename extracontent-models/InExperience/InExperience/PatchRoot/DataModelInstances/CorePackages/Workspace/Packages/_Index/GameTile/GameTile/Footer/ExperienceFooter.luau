local GameTile = script:FindFirstAncestor("GameTile")
local CoPlayFooter = require(GameTile.Footer.CoPlayFooter)
local usePlayerCountText = require(GameTile.Footer.usePlayerCountText)
require(GameTile.GameTileTypes)

local parent = GameTile.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local StatGroup = UIBlox.App.Indicator.StatGroup
local TextFooter = UIBlox.App.Tile.ExperienceTileMetadata.TextFooter
local coPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local SocialProofFooter = UIBlox.App.Tile.ExperienceTileMetadata.SocialProofFooter
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(parent.Style)
local Colors = Style.Colors
local Style2 = require(parent.Style)
local useDesignTokens = Style2.useDesignTokens
local Ads = require(parent.Ads)
local SponsoredTooltipHover = Ads.SponsoredTooltipHover
local ArgCheck = require(parent.ArgCheck)
local getUserInputIsSelectionOnly = require(GameTile.Footer.getUserInputIsSelectionOnly)

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

	local playingText = usePlayerCountText(playingCount)

	local v = useStyle()
	local font = v.Font
	local theme = v.Theme

	local size = useDesignTokens().Size

	local v2 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		notPlayableText = "Feature.ExperienceDetails.Label.NotPlayable",
		ageRatingText = ageRatingTextLabel or nil,
		friendsText = useExperienceTileMetadata and "CommonUI.Features.Label.Friends" or nil
	})

	if not isStatsOnly then
		if isShowSponsoredLabel then
			local userInputIsSelectionOnly = getUserInputIsSelectionOnly()

			local element = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0 },
				{
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 4)
					}),
					SponsoredText = React.createElement(StyledTextLabel, {
						colorStyle = theme.TextEmphasis,
						fontStyle = font.CaptionHeader,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Center,
						automaticSize = Enum.AutomaticSize.X,
						size = UDim2.new(0, 0, 1, 0),
						lineHeight = 1,
						text = v2.sponsoredText,
						textTruncate = Enum.TextTruncate.AtEnd,
						richText = false,
						layoutOrder = 1
					}),
					SponsoredTooltip = React.createElement(SponsoredTooltipHover, {
						tooltipOrientation = TooltipOrientation.Bottom,
						onActivateTooltip = onActivateSponsoredTooltip,
						size = UDim2.new(0, 16, 0, 16),
						color = theme.TextEmphasis.Color,
						layoutOrder = 2,
						selectable = userInputIsSelectionOnly
					})
				}
			)

			if useExperienceTileMetadata then
				return (React.createElement(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = v.Tokens.Color.Shift.Shift_200.Color3,
						BackgroundTransparency = v.Tokens.Color.Shift.Shift_200.Transparency,
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
						Text = React.createElement("TextLabel", {
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Text = v2.sponsoredText,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							FontFace = normalizeFontFace(v.Tokens.Typography.CaptionLarge.Font),
							TextSize = v.Font.BaseSize * v.Font.CaptionHeader.RelativeSize,
							TextColor3 = v.Tokens.Color.Content.Emphasis.Color3,
							TextTransparency = v.Tokens.Color.Content.Emphasis.Transparency,
							LayoutOrder = 1
						}),
						SponsoredTooltip = React.createElement(SponsoredTooltipHover, {
							tooltipOrientation = TooltipOrientation.Bottom,
							onActivateTooltip = onActivateSponsoredTooltip,
							size = UDim2.new(0, 16, 0, 16),
							color = v.Tokens.Color.Content.Emphasis.Color3,
							layoutOrder = 2,
							selectable = userInputIsSelectionOnly,
							supportTenFootUi = true
						})
					},
					{
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v.Tokens.Radius.Small)
						})
					}
				))
			end

			return React.createElement("Frame", {
				Size = props.size or udim,
				Position = props.position,
				AnchorPoint = props.anchorPoint,
				LayoutOrder = props.layoutOrder,
				BackgroundTransparency = theme.UIDefault.Transparency,
				BackgroundColor3 = theme.UIDefault.Color,
				AutomaticSize = props.automaticSize
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
				SponsoredLabel = element
			})
		elseif coPlayFriends and next(coPlayFriends) then
			if useExperienceTileMetadata then
				return React.createElement(coPlayFooter, {
					users = coPlayFriends,
					labelText = v2.friendsText,
					showEmphasisBorder = true,
					faceGroupCount = 2,
					styleProps = {
						faceWidth = size.Size_500,
						faceHeight = size.Size_500,
						faceGroupGap = -size.Size_150,
						containerGap = size.Size_100,
						badgeBorderWidth = 3,
						badgeHeight = size.Size_500,
						fontStyle = v.Font.CaptionHeader,
						badgeSpacingLeading = size.Size_100,
						badgeSpacingTrailing = size.Size_100,
						badgeBackgroundColor = { Color = Colors.Smoke, Transparency = 0 },
						badgeContentColor = { Color = Colors.White, Transparency = 0 }
					}
				})
			end

			local element = React.createElement(CoPlayFooter, { friends = coPlayFriends })

			return React.createElement("Frame", {
				Size = props.size or udim,
				Position = props.position,
				AnchorPoint = props.anchorPoint,
				LayoutOrder = props.layoutOrder,
				BackgroundTransparency = 1,
				AutomaticSize = props.automaticSize
			}, { CoPlayFooter = element })
		elseif showAgeRating then
			local text

			if props.localizedAgeRatingTextLabel then
				text = props.localizedAgeRatingTextLabel
			else
				text = v2.ageRatingText
			end

			if useExperienceTileMetadata then
				return React.createElement(TextFooter, { text = text })
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
				AgeRatingLabel = React.createElement(StyledTextLabel, {
					colorStyle = theme.TextEmphasis,
					fontStyle = font.CaptionHeader,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					size = UDim2.new(1, 0, 2, 0),
					lineHeight = 1,
					text = text,
					textTruncate = Enum.TextTruncate.AtEnd,
					richText = false
				})
			})
		else
			if props.showFriendActivity and not useExperienceTileMetadata then
				local textSize = font.BaseSize * font.Body.RelativeSize

				return React.createElement("TextLabel", {
					Size = props.size or udim,
					TextColor3 = theme.TextMuted.Color,
					FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Text = props.friendActivityTitle,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextSize = textSize,
					TextTransparency = theme.TextMuted.Transparency,
					BackgroundTransparency = 1
				})
			end

			if isPlayable == false and not requiresPurchase then
				if useExperienceTileMetadata then
					return React.createElement(TextFooter, { text = v2.notPlayableText })
				end

				return React.createElement("Frame", {
					Size = props.size or udim,
					Position = props.position,
					AnchorPoint = props.anchorPoint,
					LayoutOrder = props.layoutOrder,
					BackgroundTransparency = 1,
					AutomaticSize = props.automaticSize
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
					PlayabilityLabel = React.createElement(StyledTextLabel, {
						colorStyle = theme.TextMuted,
						fontStyle = font.CaptionHeader,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						lineHeight = 1,
						text = v2.notPlayableText,
						textTruncate = Enum.TextTruncate.AtEnd,
						richText = false
					})
				})
			end
		end
	end

	if useExperienceTileMetadata then
		return React.createElement(SocialProofFooter, {
			ratingText = rating,
			playingText = playingText
		})
	end

	local element = React.createElement(StatGroup, {
		ratingText = rating,
		playingText = playingText
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
