local GameTile = script:FindFirstAncestor("GameTile")
local GridTileGameStats = require(GameTile.Footer.GridTileGameStats)
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local getGameStatsRatingPercentageText = require(GameTile.Footer.getGameStatsRatingPercentageText)
local usePlayerCountText = require(GameTile.Footer.usePlayerCountText)
local getUserInputIsSelectionOnly = require(GameTile.Footer.getUserInputIsSelectionOnly)
local GameTileParent = GameTile.Parent
local Roact = require(GameTileParent.Roact)
local Colors = require(GameTileParent.Style).Colors
local Cryo = require(GameTileParent.Cryo)
local UIBlox = require(GameTileParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(GameTileParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withLocalization = require(GameTileParent.Localization).withLocalization
local SponsoredTooltipHover = require(GameTileParent.Ads).SponsoredTooltipHover
local FFlagLuaAppNarrowTileSmallerFooterFont = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local FFlagLuaAppGenreRatingFooter = require(GameTileParent.SharedFlags).FFlagLuaAppGenreRatingFooter
local v25 = Images["icons/status/games/rating_small"]
local v26 = Images["icons/status/games/people-playing_small"]
local v27 = Roact.PureComponent:extend("GameStats")
local u28 = nil

if not FFlagLuaAppGenreRatingFooter then
	function u28(p1, p2) -- line: 37
		local s1 = "--"

		if p1 == nil or p1 < 0 then
			p1 = 0
		end

		if p2 == nil or p2 < 0 then
			p2 = 0
		end

		local v33 = p1 + p2

		if v33 > 0 then
			s1 = tostring((math.floor(p1 / v33 * 100)))
		end

		return s1
	end
end

function v27.renderSponsored(p3, p4) -- line: 58
	-- upvalues: Roact (copy), SponsoredTooltipHover (copy), TooltipOrientation (copy), getUserInputIsSelectionOnly (copy), Interactable (copy), withLocalization (copy)
	local Theme = p4.Theme
	local p4Font = p4.Font
	local v38 = if not p3.props.useLargerFont then p4Font.CaptionHeader else p4Font.Body
	local v39 = v38.RelativeSize * p4Font.BaseSize

	return withLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored"
	})(function(p5) -- line: 65
		-- upvalues: Roact (copy), v39 (copy), Theme (copy), v38 (copy), SponsoredTooltipHover (copy), TooltipOrientation (copy), p3 (copy), getUserInputIsSelectionOnly (copy), Interactable (copy)
		local sponsoredText = p5.sponsoredText
		local v74 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			SponsoredText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				TextSize = v39,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = v38.Font,
				Text = sponsoredText,
				AutomaticSize = Enum.AutomaticSize.XY
			}),
			SponsoredTooltip = Roact.createElement(SponsoredTooltipHover, {
				layoutOrder = 2,
				tooltipOrientation = TooltipOrientation.Bottom,
				onActivateTooltip = p3.props.onActivateSponsoredTooltip,
				size = UDim2.new(0, 16, 0, 16),
				color = Theme.TextEmphasis.Color,
				selectable = getUserInputIsSelectionOnly()
			})
		})
		local v75 = math.ceil(v39)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, v75),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Theme.UIDefault.Color,
			BackgroundTransparency = Theme.UIDefault.Transparency
		}, {
			SponsoredBlock = Roact.createElement(Interactable, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				onStateChanged = function() -- line: 113
				end,
				[Roact.Event.Activated] = p3.props.onActivateSponsoredTooltip
			}, {
				SponsoredBlockFrame = v74
			})
		})
	end)
end
function v27.renderGameStats(t1: {[any]: any}, p6, p7, n1: number?) -- line: 126
	-- upvalues: FFlagLuaAppGenreRatingFooter (copy), getGameStatsRatingPercentageText (copy), u28 (ref), Roact (copy), GridTileGameStats (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), withLocalization (copy), GridTileIconTextFooter (copy), Images (copy)
	local stats = p7.stats
	local v45 = if not FFlagLuaAppGenreRatingFooter then u28(stats.totalUpVotes, stats.totalDownVotes) else getGameStatsRatingPercentageText(stats.totalUpVotes, stats.totalDownVotes)

	if stats.playerCount ~= nil then
		if stats.totalUpVotes + stats.totalDownVotes > 0 then
			v45 ..= "%"
		end

		if p7.isGridTile or p7.isUnifiedGameTile then
			return Roact.createElement(GridTileGameStats, {
				playerCountText = p7.playerCountText,
				ratingText = v45,
				useLargerFont = t1.props.useLargerFont,
				isUnifiedGameTile = p7.isUnifiedGameTile,
				gameTileLayoutType = p7.gameTileLayoutType,
				LayoutOrder = t1.props.LayoutOrder,
				compactMetadataFormat = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else p7.compactMetadataFormat,
				hideRating = if not FFlagLuaAppNarrowTileHideRating then nil else p7.hideRating,
				hidePlayerCount = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else p7.hidePlayerCount
			})
		end

		return t1:renderFullGameStats(p6, p7, v45, n1)
	end

	return withLocalization({
		longRatingText = {
			"Feature.GameDetails.RatingPercentOnly",
			percentRating = v45
		}
	})(function(p8) -- line: 156
		-- upvalues: Roact (copy), GridTileIconTextFooter (copy), Images (copy), t1 (copy), p7 (copy)
		return Roact.createElement(GridTileIconTextFooter, {
			icon = Images["icons/status/games/rating_small"],
			text = p8.longRatingText,
			styleProps = {
				iconSize = 15,
				padding = 4
			},
			useLargerFont = t1.props.useLargerFont,
			isUnifiedGameTile = p7.isUnifiedGameTile
		})
	end)
end
function v27.renderFullGameStats(_: {[any]: any}, p9, p10, p11, n2: number?) -- line: 171
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), ImageSetLabel (copy), v25 (copy), v26 (copy)
	local playerCountText = nil

	if p10.stats.playerCount then
		playerCountText = p10.playerCountText
	end

	local Theme = p9.Theme
	local p9Font = p9.Font
	local CaptionSubHeaderFont = p9Font.CaptionSubHeader.Font
	local v55 = p9Font.BaseSize * p9Font.CaptionSubHeader.RelativeSize
	local v56 = math.ceil(v55)
	local v57 = v55 + if not FFlagRenameDeprecatedUIBloxTokens then p9.Tokens.Global.Size_75 else p9.Tokens.Size.Size_150
	local v58 = math.min(v56 + (n2 or 0), v57)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		VoteIcon = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.125, 0, 0, v58),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Image = v25,
			ImageColor3 = Theme.TextDefault.Color,
			ImageTransparency = Theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		}),
		Vote = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.35, 0, 0, v58),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.15, 0.5),
			Text = p11,
			Font = CaptionSubHeaderFont,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextSize = v55,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v57
			})
		}),
		PlayerIcon = if playerCountText == nil then nil else Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.125, 0, 0, v58),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Image = v26,
			ImageColor3 = Theme.TextDefault.Color,
			ImageTransparency = Theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		}),
		PlayerCount = if playerCountText == nil then nil else Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.35, 0, 0, v58),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.65, 0.5),
			Text = playerCountText,
			Font = CaptionSubHeaderFont,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextSize = v55,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v57
			})
		})
	})
end
function v27.renderConcurrentUsersPill(_, p13, p14) -- line: 261
	-- upvalues: Roact (copy), Colors (copy), ImageSetLabel (copy), v26 (copy)
	local playerCountText = p14.playerCountText
	local p13Font = p13.Font
	local FooterFont = p13Font.Footer.Font
	local v65 = p13Font.BaseSize * p13Font.Footer.RelativeSize

	return Roact.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 0, 0, 23),
		Position = UDim2.new(1, -8, 1, -8),
		AnchorPoint = Vector2.new(1, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Colors.Black
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 15)
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0.15, 0)
		}),
		PillIcon = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ImageTransparency = 0,
			Size = UDim2.new(0.7, 0, 0.7, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Image = v26,
			ImageColor3 = Colors.White,
			ScaleType = Enum.ScaleType.Fit
		}),
		PillPlayerCount = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextTransparency = 0,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = playerCountText,
			Font = FooterFont,
			TextColor3 = Colors.White,
			TextSize = v65,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom
		})
	})
end
function v27.render(p15) -- line: 317
	-- upvalues: withTextSizeOffset (copy), withStyle (copy)
	local stats = p15.props.stats

	if stats == nil then
		return nil
	end

	local function v68(p16, n3: number?) -- line: 323
		-- upvalues: stats (copy), p15 (copy)
		if stats.isSponsored and stats.isShowSponsoredLabel then
			return p15:renderSponsored(p16)
		end

		if stats.displayConcurrentUsersPill then
			return p15:renderConcurrentUsersPill(p16, p15.props)
		end

		if p15.props.hideGameStats then
			return nil
		end

		return p15:renderGameStats(p16, p15.props, n3)
	end

	return withTextSizeOffset(function(p17) -- line: 338
		-- upvalues: withStyle (copy), v68 (copy)
		return withStyle(function(p18) -- line: 339
			-- upvalues: v68 (copy), p17 (copy)
			return v68(p18, p17)
		end)
	end)
end

local v29 = v27

return function(p19) -- line: 346
	-- upvalues: usePlayerCountText (copy), Roact (copy), v29 (copy), Cryo (copy)
	local v70 = p19.stats and p19.stats.playerCount or nil
	local v71 = usePlayerCountText(v70)

	return Roact.createElement(v29, Cryo.Dictionary.join(p19, {
		playerCountText = v71
	}))
end
