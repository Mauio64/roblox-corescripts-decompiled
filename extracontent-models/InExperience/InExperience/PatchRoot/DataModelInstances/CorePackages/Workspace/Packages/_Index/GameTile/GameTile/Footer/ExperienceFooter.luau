local GameTile = script:FindFirstAncestor("GameTile")
local CoPlayFooter = require(GameTile.Footer.CoPlayFooter)
local usePlayerCountText = require(GameTile.Footer.usePlayerCountText)

require(GameTile.GameTileTypes)

local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local UIBlox = require(GameTileParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local StatGroup = UIBlox.App.Indicator.StatGroup
local TextFooter = UIBlox.App.Tile.ExperienceTileMetadata.TextFooter
local CoPlayFooter2 = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local SocialProofFooter = UIBlox.App.Tile.ExperienceTileMetadata.SocialProofFooter
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local Colors = require(GameTileParent.Style).Colors
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local SponsoredTooltipHover = require(GameTileParent.Ads).SponsoredTooltipHover
local ArgCheck = require(GameTileParent.ArgCheck)
local getUserInputIsSelectionOnly = require(GameTile.Footer.getUserInputIsSelectionOnly)
local uDim2 = UDim2.fromScale(1, 1)

return function(p1) -- line: 28
	-- upvalues: ArgCheck (copy), usePlayerCountText (copy), useStyle (copy), useDesignTokens (copy), useLocalization (copy), getUserInputIsSelectionOnly (copy), React (copy), StyledTextLabel (copy), SponsoredTooltipHover (copy), TooltipOrientation (copy), uDim2 (copy), CoPlayFooter2 (copy), Colors (copy), CoPlayFooter (copy), TextFooter (copy), SocialProofFooter (copy), StatGroup (copy)
	if p1.automaticSize then
		ArgCheck.isNotNil(p1.size, "If props.automaticSize is defined, props.size should also be defined.  Otherwise size falls back to a 1, 1 scale for this component.")
	end

	local v22 = p1.isSponsored and p1.isShowSponsoredLabel
	local isStatsOnly = p1.isStatsOnly
	local isPlayable = p1.isPlayable
	local requiresPurchase = p1.requiresPurchase
	local v26 = p1.rating or ""
	local v27 = p1.playingCount or 0
	local coPlayFriends = p1.coPlayFriends
	local showAgeRating = p1.showAgeRating
	local ageRatingTextLabel = p1.ageRatingTextLabel
	local useExperienceTileMetadata = p1.useExperienceTileMetadata
	local onActivateSponsoredTooltip = p1.onActivateSponsoredTooltip
	local v33 = usePlayerCountText(v27)
	local v34 = useStyle()
	local Font = v34.Font
	local Theme = v34.Theme
	local Global = useDesignTokens().Global
	local v38 = useLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored",
		notPlayableText = "Feature.ExperienceDetails.Label.NotPlayable",
		ageRatingText = ageRatingTextLabel or nil,
		friendsText = if not useExperienceTileMetadata then nil else "CommonUI.Features.Label.Friends"
	})

	if not isStatsOnly then
		if v22 then
			local v39 = getUserInputIsSelectionOnly()
			local v40 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 4)
				}),
				SponsoredText = React.createElement(StyledTextLabel, {
					lineHeight = 1,
					richText = false,
					layoutOrder = 1,
					colorStyle = Theme.TextEmphasis,
					fontStyle = Font.CaptionHeader,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center,
					automaticSize = Enum.AutomaticSize.X,
					size = UDim2.new(0, 0, 1, 0),
					text = v38.sponsoredText,
					textTruncate = Enum.TextTruncate.AtEnd
				}),
				SponsoredTooltip = React.createElement(SponsoredTooltipHover, {
					layoutOrder = 2,
					tooltipOrientation = TooltipOrientation.Bottom,
					onActivateTooltip = onActivateSponsoredTooltip,
					size = UDim2.new(0, 16, 0, 16),
					color = Theme.TextEmphasis.Color,
					selectable = v39
				})
			})

			if useExperienceTileMetadata then
				return (React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = v34.Tokens.Color.Shift.Shift_200.Color3,
					BackgroundTransparency = v34.Tokens.Color.Shift.Shift_200.Transparency
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 4)
					}),
					Text = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X,
						Text = v38.sponsoredText,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = v34.Font.CaptionHeader.Font,
						TextSize = v34.Font.BaseSize * v34.Font.CaptionHeader.RelativeSize,
						TextColor3 = v34.Tokens.Color.Content.Emphasis.Color3,
						TextTransparency = v34.Tokens.Color.Content.Emphasis.Transparency
					}),
					SponsoredTooltip = React.createElement(SponsoredTooltipHover, {
						layoutOrder = 2,
						supportTenFootUi = true,
						tooltipOrientation = TooltipOrientation.Bottom,
						onActivateTooltip = onActivateSponsoredTooltip,
						size = UDim2.new(0, 16, 0, 16),
						color = v34.Tokens.Color.Content.Emphasis.Color3,
						selectable = v39
					})
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v34.Tokens.Radius.Small)
					})
				}))
			end

			return React.createElement("Frame", {
				Size = p1.size or uDim2,
				Position = p1.position,
				AnchorPoint = p1.anchorPoint,
				LayoutOrder = p1.layoutOrder,
				BackgroundTransparency = Theme.UIDefault.Transparency,
				BackgroundColor3 = Theme.UIDefault.Color,
				AutomaticSize = p1.automaticSize
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 4)
				}),
				SponsoredLabel = v40
			})
		end

		if coPlayFriends and next(coPlayFriends) then
			if useExperienceTileMetadata then
				return React.createElement(CoPlayFooter2, {
					showEmphasisBorder = true,
					faceGroupCount = 2,
					users = coPlayFriends,
					labelText = v38.friendsText,
					styleProps = {
						badgeBorderWidth = 3,
						faceWidth = Global.Size_250,
						faceHeight = Global.Size_250,
						faceGroupGap = -Global.Space_75,
						containerGap = Global.Space_50,
						badgeHeight = Global.Size_250,
						fontStyle = v34.Font.CaptionHeader,
						badgeSpacingLeading = Global.Space_50,
						badgeSpacingTrailing = Global.Space_50,
						badgeBackgroundColor = {
							Transparency = 0,
							Color = Colors.Smoke
						},
						badgeContentColor = {
							Transparency = 0,
							Color = Colors.White
						}
					}
				})
			end

			local v41 = React.createElement(CoPlayFooter, {
				friends = coPlayFriends
			})

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = p1.size or uDim2,
				Position = p1.position,
				AnchorPoint = p1.anchorPoint,
				LayoutOrder = p1.layoutOrder,
				AutomaticSize = p1.automaticSize
			}, {
				CoPlayFooter = v41
			})
		end

		if showAgeRating then
			local v42 = if not p1.localizedAgeRatingTextLabel then v38.ageRatingText else p1.localizedAgeRatingTextLabel

			if useExperienceTileMetadata then
				return React.createElement(TextFooter, {
					text = v42
				})
			end

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = p1.size or uDim2,
				Position = p1.position,
				AnchorPoint = p1.anchorPoint,
				LayoutOrder = p1.layoutOrder,
				AutomaticSize = p1.automaticSize
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 0),
					PaddingBottom = UDim.new(0, 2),
					PaddingLeft = UDim.new(0, 0)
				}),
				AgeRatingLabel = React.createElement(StyledTextLabel, {
					lineHeight = 1,
					richText = false,
					colorStyle = Theme.TextEmphasis,
					fontStyle = Font.CaptionHeader,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					size = UDim2.new(1, 0, 2, 0),
					text = v42,
					textTruncate = Enum.TextTruncate.AtEnd
				})
			})
		end

		if p1.showFriendActivity and not useExperienceTileMetadata then
			local BodyFont = Font.Body.Font
			local v44 = Font.BaseSize * Font.Body.RelativeSize

			return React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = p1.size or uDim2,
				TextColor3 = Theme.TextMuted.Color,
				Font = BodyFont,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Text = p1.friendActivityTitle,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextSize = v44,
				TextTransparency = Theme.TextMuted.Transparency
			})
		end

		if isPlayable == false and not requiresPurchase then
			if useExperienceTileMetadata then
				return React.createElement(TextFooter, {
					text = v38.notPlayableText
				})
			end

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = p1.size or uDim2,
				Position = p1.position,
				AnchorPoint = p1.anchorPoint,
				LayoutOrder = p1.layoutOrder,
				AutomaticSize = p1.automaticSize
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 4)
				}),
				PlayabilityLabel = React.createElement(StyledTextLabel, {
					lineHeight = 1,
					richText = false,
					colorStyle = Theme.TextMuted,
					fontStyle = Font.CaptionHeader,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					size = UDim2.new(1, 0, 1, 0),
					text = v38.notPlayableText,
					textTruncate = Enum.TextTruncate.AtEnd
				})
			})
		end
	end

	if useExperienceTileMetadata then
		return React.createElement(SocialProofFooter, {
			ratingText = v26,
			playingText = v33
		})
	end

	local v45 = React.createElement(StatGroup, {
		ratingText = v26,
		playingText = v33
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = p1.size or uDim2,
		Position = p1.position,
		AnchorPoint = p1.anchorPoint,
		LayoutOrder = p1.layoutOrder,
		AutomaticSize = p1.automaticSize
	}, {
		ExperienceStats = v45
	})
end
