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
local v24 = Images["icons/status/games/rating_small"]
local v25 = Images["icons/status/games/people-playing_small"]
local v26 = Roact.PureComponent:extend("GameStats")
local u27 = nil

if not FFlagLuaAppGenreRatingFooter then
	function u27(p1, p2) -- line: 35
		local s1 = "--"

		if p1 == nil or p1 < 0 then
			p1 = 0
		end

		if p2 == nil or p2 < 0 then
			p2 = 0
		end

		local v32 = p1 + p2

		if v32 > 0 then
			s1 = tostring((math.floor(p1 / v32 * 100)))
		end

		return s1
	end
end

function v26.renderSponsored(p3, p4) -- line: 56
	-- upvalues: Roact (copy), SponsoredTooltipHover (copy), TooltipOrientation (copy), getUserInputIsSelectionOnly (copy), Interactable (copy), withLocalization (copy)
	local Theme = p4.Theme
	local p4Font = p4.Font
	local v37 = if not p3.props.useLargerFont then p4Font.CaptionHeader else p4Font.Body
	local v38 = v37.RelativeSize * p4Font.BaseSize

	return withLocalization({
		sponsoredText = "Feature.GamePage.Label.Sponsored"
	})(function(p5) -- line: 63
		-- upvalues: Roact (copy), v38 (copy), Theme (copy), v37 (copy), SponsoredTooltipHover (copy), TooltipOrientation (copy), p3 (copy), getUserInputIsSelectionOnly (copy), Interactable (copy)
		local sponsoredText = p5.sponsoredText
		local v73 = Roact.createElement("Frame", {
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
				TextSize = v38,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = v37.Font,
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
		local v74 = math.ceil(v38)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, v74),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Theme.UIDefault.Color,
			BackgroundTransparency = Theme.UIDefault.Transparency
		}, {
			SponsoredBlock = Roact.createElement(Interactable, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				onStateChanged = function() -- line: 111
				end,
				[Roact.Event.Activated] = p3.props.onActivateSponsoredTooltip
			}, {
				SponsoredBlockFrame = v73
			})
		})
	end)
end
function v26.renderGameStats(t1: {[any]: any}, p6, p7, n1: number?) -- line: 124
	-- upvalues: FFlagLuaAppGenreRatingFooter (copy), getGameStatsRatingPercentageText (copy), u27 (ref), Roact (copy), GridTileGameStats (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), withLocalization (copy), GridTileIconTextFooter (copy), Images (copy)
	local stats = p7.stats
	local v44 = if not FFlagLuaAppGenreRatingFooter then u27(stats.totalUpVotes, stats.totalDownVotes) else getGameStatsRatingPercentageText(stats.totalUpVotes, stats.totalDownVotes)

	if stats.playerCount ~= nil then
		if stats.totalUpVotes + stats.totalDownVotes > 0 then
			v44 ..= "%"
		end

		if p7.isGridTile or p7.isUnifiedGameTile then
			return Roact.createElement(GridTileGameStats, {
				playerCountText = p7.playerCountText,
				ratingText = v44,
				useLargerFont = t1.props.useLargerFont,
				isUnifiedGameTile = p7.isUnifiedGameTile,
				gameTileLayoutType = p7.gameTileLayoutType,
				LayoutOrder = t1.props.LayoutOrder,
				compactMetadataFormat = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else p7.compactMetadataFormat,
				hideRating = if not FFlagLuaAppNarrowTileHideRating then nil else p7.hideRating,
				hidePlayerCount = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else p7.hidePlayerCount
			})
		end

		return t1:renderFullGameStats(p6, p7, v44, n1)
	end

	return withLocalization({
		longRatingText = {
			"Feature.GameDetails.RatingPercentOnly",
			percentRating = v44
		}
	})(function(p8) -- line: 154
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
function v26.renderFullGameStats(_: {[any]: any}, p9, p10, p11, n2: number?) -- line: 169
	-- upvalues: Roact (copy), ImageSetLabel (copy), v24 (copy), v25 (copy)
	local playerCountText = nil

	if p10.stats.playerCount then
		playerCountText = p10.playerCountText
	end

	local Theme = p9.Theme
	local p9Font = p9.Font
	local CaptionSubHeaderFont = p9Font.CaptionSubHeader.Font
	local v54 = p9Font.BaseSize * p9Font.CaptionSubHeader.RelativeSize
	local v55 = math.ceil(v54)
	local v56 = v54 + p9.Tokens.Size.Size_150
	local v57 = math.min(v55 + (n2 or 0), v56)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		VoteIcon = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.125, 0, 0, v57),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Image = v24,
			ImageColor3 = Theme.TextDefault.Color,
			ImageTransparency = Theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		}),
		Vote = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.35, 0, 0, v57),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.15, 0.5),
			Text = p11,
			Font = CaptionSubHeaderFont,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextSize = v54,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v56
			})
		}),
		PlayerIcon = if playerCountText == nil then nil else Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.125, 0, 0, v57),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Image = v25,
			ImageColor3 = Theme.TextDefault.Color,
			ImageTransparency = Theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		}),
		PlayerCount = if playerCountText == nil then nil else Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.35, 0, 0, v57),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.65, 0.5),
			Text = playerCountText,
			Font = CaptionSubHeaderFont,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextSize = v54,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v56
			})
		})
	})
end
function v26.renderConcurrentUsersPill(_, p13, p14) -- line: 254
	-- upvalues: Roact (copy), Colors (copy), ImageSetLabel (copy), v25 (copy)
	local playerCountText = p14.playerCountText
	local p13Font = p13.Font
	local FooterFont = p13Font.Footer.Font
	local v64 = p13Font.BaseSize * p13Font.Footer.RelativeSize

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
			Image = v25,
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
			TextSize = v64,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom
		})
	})
end
function v26.render(p15) -- line: 310
	-- upvalues: withTextSizeOffset (copy), withStyle (copy)
	local stats = p15.props.stats

	if stats == nil then
		return nil
	end

	local function v67(p16, n3: number?) -- line: 316
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

	return withTextSizeOffset(function(p17) -- line: 331
		-- upvalues: withStyle (copy), v67 (copy)
		return withStyle(function(p18) -- line: 332
			-- upvalues: v67 (copy), p17 (copy)
			return v67(p18, p17)
		end)
	end)
end

local v28 = v26

return function(p19) -- line: 339
	-- upvalues: usePlayerCountText (copy), Roact (copy), v28 (copy), Cryo (copy)
	local v69 = p19.stats and p19.stats.playerCount or nil
	local v70 = usePlayerCountText(v69)

	return Roact.createElement(v28, Cryo.Dictionary.join(p19, {
		playerCountText = v70
	}))
end
