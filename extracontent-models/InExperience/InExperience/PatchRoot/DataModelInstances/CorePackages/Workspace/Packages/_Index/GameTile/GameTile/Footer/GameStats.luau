local GameTile = script:FindFirstAncestor("GameTile")
local GridTileGameStats = require(GameTile.Footer.GridTileGameStats)
local GridTileIconTextFooter = require(GameTile.Footer.GridTileIconTextFooter)
local getGameStatsRatingPercentageText = require(GameTile.Footer.getGameStatsRatingPercentageText)
local usePlayerCountText = require(GameTile.Footer.usePlayerCountText)
local getUserInputIsSelectionOnly = require(GameTile.Footer.getUserInputIsSelectionOnly)

local parent = GameTile.Parent
local Roact = require(parent.Roact)
local Style = require(parent.Style)
local Colors = Style.Colors
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local Ads = require(parent.Ads)
local SponsoredTooltipHover = Ads.SponsoredTooltipHover
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags.FFlagLuaAppNarrowTileHideRating
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags2.FFlagLuaAppNarrowTileHidePlayerCount
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGenreRatingFooter = SharedFlags3.FFlagLuaAppGenreRatingFooter

local iconsstatusgamesrating_small = Images["icons/status/games/rating_small"]
local iconsstatusgamespeopleplaying_small = Images["icons/status/games/people-playing_small"]

local extended = Roact.PureComponent:extend("GameStats")

local fn = not FFlagLuaAppGenreRatingFooter and function(p, p2)
	local v = (p == nil or p < 0) and 0 or p

	local v2 = v + ((p2 == nil or p2 < 0) and 0 or p2)

	return not (v2 > 0) and "--" or tostring((math.floor(v / v2 * 100)))
end or nil

function extended:renderSponsored(data)
	local theme = data.Theme
	local font = data.Font
	local v

	if self.props.useLargerFont then
		v = font.Body
	else
		v = font.CaptionHeader
	end

	local textSize = v.RelativeSize * font.BaseSize

	local function fn2(p)
		local sponsoredText = p.sponsoredText
		local createElement = Roact.createElement
		local v2 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0 }

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			SponsoredText = 0,
			SponsoredTooltip = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextSize = textSize,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			FontFace = 0,
			Text = 0,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local v4

		if self.props.useLargerFont then
			v4 = data.Tokens.Typography.BodyLarge.Font
		else
			v4 = data.Tokens.Typography.CaptionLarge.Font
		end

		v3.FontFace = normalizeFontFace(v4)

		v3.Text = sponsoredText
		v3.AutomaticSize = Enum.AutomaticSize.XY
		children.SponsoredText = createElement2("TextLabel", v3)

		children.SponsoredTooltip = Roact.createElement(SponsoredTooltipHover, {
			tooltipOrientation = TooltipOrientation.Bottom,
			onActivateTooltip = self.props.onActivateSponsoredTooltip,
			size = UDim2.new(0, 16, 0, 16),
			color = theme.TextEmphasis.Color,
			layoutOrder = 2,
			selectable = getUserInputIsSelectionOnly()
		})
		local element = createElement("Frame", v2, children)

		local v5 = math.ceil(textSize)

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v5),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = theme.UIDefault.Color,
			BackgroundTransparency = theme.UIDefault.Transparency,
			BorderSizePixel = 0
		}, {
			SponsoredBlock = Roact.createElement(Interactable, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				onStateChanged = function() end,
				[Roact.Event.Activated] = self.props.onActivateSponsoredTooltip
			}, { SponsoredBlockFrame = element })
		})
	end

	return withLocalization({ sponsoredText = "Feature.GamePage.Label.Sponsored" })(fn2)
end

function extended:renderGameStats(p, props, p2: number?)
	local stats = props.stats
	local v

	if FFlagLuaAppGenreRatingFooter then
		v = getGameStatsRatingPercentageText(stats.totalUpVotes, stats.totalDownVotes)
	else
		v = fn(stats.totalUpVotes, stats.totalDownVotes)
	end

	if stats.playerCount == nil then
		return withLocalization({
			longRatingText = {
				"Feature.GameDetails.RatingPercentOnly",
				percentRating = v
			}
		})(function(p3)
			return Roact.createElement(GridTileIconTextFooter, {
				icon = Images["icons/status/games/rating_small"],
				text = p3.longRatingText,
				styleProps = { iconSize = 15, padding = 4 },
				useLargerFont = self.props.useLargerFont,
				isUnifiedGameTile = props.isUnifiedGameTile
			})
		end)
	end

	if stats.totalUpVotes + stats.totalDownVotes > 0 then
		v ..= "%"
	end

	if not (props.isGridTile or props.isUnifiedGameTile) then
		return self:renderFullGameStats(p, props, v, p2)
	end

	local createElement = Roact.createElement
	local v2 = {
		playerCountText = props.playerCountText,
		ratingText = v,
		useLargerFont = self.props.useLargerFont,
		isUnifiedGameTile = props.isUnifiedGameTile,
		gameTileLayoutType = props.gameTileLayoutType,
		LayoutOrder = self.props.LayoutOrder,
		compactMetadataFormat = props.compactMetadataFormat,
		hideRating = 0,
		hidePlayerCount = 0
	}
	local hideRating

	if FFlagLuaAppNarrowTileHideRating then
		hideRating = props.hideRating
	end

	v2.hideRating = hideRating
	local hidePlayerCount

	if FFlagLuaAppNarrowTileHidePlayerCount then
		hidePlayerCount = props.hidePlayerCount
	end

	v2.hidePlayerCount = hidePlayerCount
	return createElement(GridTileGameStats, v2)
end

function extended:renderFullGameStats(props, p, text, value: number?)
	local playerCountText

	if p.stats.playerCount then
		playerCountText = p.playerCountText
	end

	local theme = props.Theme
	local font = props.Font
	local textSize = font.BaseSize * font.CaptionSubHeader.RelativeSize
	local v = math.ceil(textSize)
	local maxTextSize = textSize + props.Tokens.Size.Size_150
	local v2 = math.min(v + (value or 0), maxTextSize)

	local createElement = Roact.createElement
	local v3 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0 }

	local v4 = {
		VoteIcon = Roact.createElement(ImageSetLabel, {
			Size = UDim2.new(0.125, 0, 0, v2),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			BackgroundTransparency = 1,
			Image = iconsstatusgamesrating_small,
			ImageColor3 = theme.TextDefault.Color,
			ImageTransparency = theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		}),
		Vote = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.35, 0, 0, v2),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.15, 0.5),
			Text = text,
			FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = maxTextSize
			})
		}),
		PlayerIcon = 0,
		PlayerCount = 0
	}
	local playerIcon

	if playerCountText ~= nil then
		playerIcon = Roact.createElement(ImageSetLabel, {
			Size = UDim2.new(0.125, 0, 0, v2),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			Image = iconsstatusgamespeopleplaying_small,
			ImageColor3 = theme.TextDefault.Color,
			ImageTransparency = theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		})
	end

	v4.PlayerIcon = playerIcon
	local playerCount

	if playerCountText ~= nil then
		playerCount = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.35, 0, 0, v2),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.65, 0.5),
			Text = playerCountText,
			FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = maxTextSize
			})
		})
	end

	v4.PlayerCount = playerCount
	return createElement("Frame", v3, v4)
end

function extended:renderConcurrentUsersPill(p, p2)
	local playerCountText = p2.playerCountText
	local font = p.Font
	local textSize = font.BaseSize * font.Footer.RelativeSize

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 0, 0, 23),
		Position = UDim2.new(1, -8, 1, -8),
		AnchorPoint = Vector2.new(1, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 0,
		BackgroundColor3 = Colors.Black
	}, {
		Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
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
			Size = UDim2.new(0.7, 0, 0.7, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = iconsstatusgamespeopleplaying_small,
			ImageColor3 = Colors.White,
			ImageTransparency = 0,
			ScaleType = Enum.ScaleType.Fit
		}),
		PillPlayerCount = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Text = playerCountText,
			FontFace = normalizeFontFace(p.Tokens.Typography.CaptionSmall.Font),
			TextColor3 = Colors.White,
			TextTransparency = 0,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom
		})
	})
end

function extended:render()
	local stats = self.props.stats

	if stats == nil then
		return nil
	end

	local function fn2(p, p2: number?)
		if stats.isSponsored and stats.isShowSponsoredLabel then
			return self:renderSponsored(p)
		end

		if stats.displayConcurrentUsersPill then
			return self:renderConcurrentUsersPill(p, self.props)
		end

		if self.props.hideGameStats then
			return nil
		end

		return self:renderGameStats(p, self.props, p2)
	end

	return withTextSizeOffset(function(p)
		return withStyle(function(p2)
			return fn2(p2, p)
		end)
	end)
end

return function(p)
	local v

	if p.stats then
		v = p.stats.playerCount or nil
	end

	local playerCountText = usePlayerCountText(v)

	return Roact.createElement(extended, Cryo.Dictionary.join(p, {
		playerCountText = playerCountText
	}))
end
