local GridTileGameStats = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileGameStats")
local GridTileIconTextFooter = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/GridTileIconTextFooter")
local getGameStatsRatingPercentageText = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getGameStatsRatingPercentageText")
local usePlayerCountText = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/usePlayerCountText")
local getUserInputIsSelectionOnly = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getUserInputIsSelectionOnly")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Roact")
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").Colors
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation").Utility.normalizeFontFace

local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local interactable = UIBlox.Core.Control.Interactable
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").withLocalization
local sponsoredTooltipHover = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Ads").SponsoredTooltipHover
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount
local fFlagLuaAppGenreRatingFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGenreRatingFooter

local iconsstatusgamesrating_small = images["icons/status/games/rating_small"]
local iconsstatusgamespeopleplaying_small = images["icons/status/games/people-playing_small"]

local extended = Roact.PureComponent:extend("GameStats")

local fn = not fFlagLuaAppGenreRatingFooter and function(p2, p3)
	local v5 = (p2 == nil or p2 < 0) and 0 or p2

	local v6 = v5 + ((p3 == nil or p3 < 0) and 0 or p3)

	return not (v6 > 0) and "--" or tostring((math.floor(v5 / v6 * 100)))
end or nil

function extended:renderSponsored(data)
	local theme = data.Theme
	local font = data.Font

	local v6 = (if self.props.useLargerFont then font.Body else font.CaptionHeader).RelativeSize * font.BaseSize

	local function fn2(p3)
		local sponsoredText = p3.sponsoredText
		local createElement = Roact.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

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
		local v10 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextSize = v6,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			FontFace = 0,
			Text = 0,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local v12

		if self.props.useLargerFont then
			v12 = data.Tokens.Typography.BodyLarge.Font
		else
			v12 = data.Tokens.Typography.CaptionLarge.Font
		end

		v10.FontFace = normalizeFontFace(v12)

		v10.Text = sponsoredText
		v10.AutomaticSize = Enum.AutomaticSize.XY
		children.SponsoredText = createElement2("TextLabel", v10)

		children.SponsoredTooltip = Roact.createElement(sponsoredTooltipHover, {
			tooltipOrientation = tooltipOrientation.Bottom,
			onActivateTooltip = self.props.onActivateSponsoredTooltip,
			size = UDim2.new(0, 16, 0, 16),
			color = theme.TextEmphasis.Color,
			layoutOrder = 2,
			selectable = getUserInputIsSelectionOnly()
		})
		local element = createElement("Frame", v8, children)

		local v13 = math.ceil(v6)

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v13),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = theme.UIDefault.Color,
			BackgroundTransparency = theme.UIDefault.Transparency,
			BorderSizePixel = 0
		}, {
			SponsoredBlock = Roact.createElement(interactable, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				onStateChanged = function() end,
				[Roact.Event.Activated] = self.props.onActivateSponsoredTooltip
			}, { SponsoredBlockFrame = element })
		})
	end

	return withLocalization({ sponsoredText = "Feature.GamePage.Label.Sponsored" })(fn2)
end

function extended:renderGameStats(p2, props, p3)
	local stats = props.stats
	local v5

	if fFlagLuaAppGenreRatingFooter then
		v5 = getGameStatsRatingPercentageText(stats.totalUpVotes, stats.totalDownVotes)
	else
		v5 = fn(stats.totalUpVotes, stats.totalDownVotes)
	end

	if stats.playerCount == nil then
		return withLocalization({
			longRatingText = {
				"Feature.GameDetails.RatingPercentOnly",
				percentRating = v5
			}
		})(function(p4)
			return Roact.createElement(GridTileIconTextFooter, {
				icon = images["icons/status/games/rating_small"],
				text = p4.longRatingText,
				styleProps = { iconSize = 15, padding = 4 },
				useLargerFont = self.props.useLargerFont,
				isUnifiedGameTile = props.isUnifiedGameTile
			})
		end)
	end

	if stats.totalUpVotes + stats.totalDownVotes > 0 then
		v5 ..= "%"
	end

	if not (props.isGridTile or props.isUnifiedGameTile) then
		return self:renderFullGameStats(p2, props, v5, p3)
	end

	local createElement = Roact.createElement
	local v7 = {
		playerCountText = props.playerCountText,
		ratingText = v5,
		useLargerFont = self.props.useLargerFont,
		isUnifiedGameTile = props.isUnifiedGameTile,
		gameTileLayoutType = props.gameTileLayoutType,
		LayoutOrder = self.props.LayoutOrder,
		compactMetadataFormat = props.compactMetadataFormat,
		hideRating = 0,
		hidePlayerCount = 0
	}
	local v8 = if fFlagLuaAppNarrowTileHideRating then props.hideRating else nil
	v7.hideRating = v8
	local v9 = if fFlagLuaAppNarrowTileHidePlayerCount then props.hidePlayerCount else nil
	v7.hidePlayerCount = v9
	return createElement(GridTileGameStats, v7)
end

function extended:renderFullGameStats(props, p3, p4, value)
	local playerCountText = if p3.stats.playerCount then p3.playerCountText else nil

	local theme = props.Theme
	local font = props.Font
	local v5 = font.BaseSize * font.CaptionSubHeader.RelativeSize
	local v6 = math.ceil(v5)
	local v7 = v5 + props.Tokens.Size.Size_150
	local v8 = math.min(v6 + (value or 0), v7)

	local createElement = Roact.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v11 = {
		VoteIcon = Roact.createElement(imageSetLabel, {
			Size = UDim2.new(0.125, 0, 0, v8),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			BackgroundTransparency = 1,
			Image = iconsstatusgamesrating_small,
			ImageColor3 = theme.TextDefault.Color,
			ImageTransparency = theme.TextDefault.Transparency,
			ScaleType = Enum.ScaleType.Fit
		}),
		Vote = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.35, 0, 0, v8),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0.15, 0.5),
			Text = p4,
			FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextSize = v5,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
				MaxTextSize = v7
			})
		}),
		PlayerIcon = 0,
		PlayerCount = 0
	}

	local v12 = if playerCountText ~= nil then Roact.createElement(imageSetLabel, {
		Size = UDim2.new(0.125, 0, 0, v8),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0, 0.5),
		Image = iconsstatusgamespeopleplaying_small,
		ImageColor3 = theme.TextDefault.Color,
		ImageTransparency = theme.TextDefault.Transparency,
		ScaleType = Enum.ScaleType.Fit
	}) else nil
	v11.PlayerIcon = v12

	local v13 = if playerCountText ~= nil then Roact.createElement("TextLabel", {
		Size = UDim2.new(0.35, 0, 0, v8),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0.65, 0.5),
		Text = playerCountText,
		FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
		TextColor3 = theme.TextDefault.Color,
		TextTransparency = theme.TextDefault.Transparency,
		TextSize = v5,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		TextTruncate = Enum.TextTruncate.AtEnd
	}, {
		UiTextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = v7
		})
	}) else nil
	v11.PlayerCount = v13
	return createElement("Frame", v10, v11)
end

function extended:renderConcurrentUsersPill(p3, p4)
	local playerCountText = p4.playerCountText
	local font = p3.Font
	local v5 = font.BaseSize * font.Footer.RelativeSize

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 0, 0, 23),
		Position = UDim2.new(1, -8, 1, -8),
		AnchorPoint = Vector2.new(1, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 0,
		BackgroundColor3 = colors.Black
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
		PillIcon = Roact.createElement(imageSetLabel, {
			Size = UDim2.new(0.7, 0, 0.7, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = iconsstatusgamespeopleplaying_small,
			ImageColor3 = colors.White,
			ImageTransparency = 0,
			ScaleType = Enum.ScaleType.Fit
		}),
		PillPlayerCount = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Text = playerCountText,
			FontFace = normalizeFontFace(p3.Tokens.Typography.CaptionSmall.Font),
			TextColor3 = colors.White,
			TextTransparency = 0,
			TextSize = v5,
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

	local function fn2(p2, p3)
		if stats.isSponsored and stats.isShowSponsoredLabel then
			return self:renderSponsored(p2)
		end

		if stats.displayConcurrentUsersPill then
			return self:renderConcurrentUsersPill(p2, self.props)
		end

		if self.props.hideGameStats then
			return nil
		end

		return self:renderGameStats(p2, self.props, p3)
	end

	return withTextSizeOffset(function(p2)
		return withStyle(function(p3)
			return fn2(p3, p2)
		end)
	end)
end

return function(p2)
	local v5 = if p2.stats then p2.stats.playerCount or nil else nil
	local v6 = usePlayerCountText(v5)

	return Roact.createElement(extended, Cryo.Dictionary.join(p2, {
		playerCountText = v6
	}))
end
