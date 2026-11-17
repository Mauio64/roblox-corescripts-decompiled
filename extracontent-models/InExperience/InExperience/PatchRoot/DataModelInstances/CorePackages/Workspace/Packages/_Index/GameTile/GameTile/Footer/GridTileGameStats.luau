local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTileTypes = require(GameTile.GameTileTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixSmallScreenFooterStatsOverlap = SharedFlags.FFlagLuaAppFixSmallScreenFooterStatsOverlap
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags2.FFlagLuaAppNarrowTileHideRating
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags3.FFlagLuaAppNarrowTileHidePlayerCount

local iconsstatusgamesrating_small = Images["icons/status/games/rating_small"]
local iconsstatusgamespeopleplaying_small = Images["icons/status/games/people-playing_small"]

local vector2 = Vector2.new(1e999, 1e999)

local function GridTileGameStats(props)
	local v = useDesignTokens()
	local v2 = useTextSizeOffset()
	local v3 = useTokens()
	local v4

	if FFlagLuaAppFixSmallScreenFooterStatsOverlap then
		v4 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
			and props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
	else
		v4 = false
	end

	local v5 = useBreakpointXOrSmaller(Responsive.Keys.Small)
		and props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow

	local v6 = v4 or props.compactMetadataFormat
	local size_500

	if props.isUnifiedGameTile then
		size_500 = v3.Size.Size_500
	else
		size_500 = v.Size.Size_500
	end

	local v7

	if props.isUnifiedGameTile then
		v7 = if v6 then v3.Gap.XXSmall else v3.Gap.XSmall
	else
		v7 = v.Size.Size_100
	end

	local v8

	if props.isUnifiedGameTile then
		v8 = if v4 then v3.Gap.XXSmall else v3.Gap.Small
	else
		v8 = v.Size.Size_200
	end

	local default

	if props.isUnifiedGameTile then
		default = v3.Color.Content.Default
	else
		default = v.Color.Content.Default
	end

	local gameTileMetadataFont = getGameTileMetadataFont(
		props.useLargerFont,
		v,
		v3 or nil,
		props.isUnifiedGameTile and true or nil,
		props.compactMetadataFormat
	)

	local fontSize = gameTileMetadataFont.FontSize
	local font = gameTileMetadataFont.Font

	if not (v2 > 0) then
		v5 = false
	end

	local v9 = fontSize / 1.26

	local ratingText = props.ratingText
	local useMemo = React.useMemo
	local function fn()
		if FFlagLuaAppNarrowTileHideRating and props.hideRating or ratingText == nil or ratingText == "" then
			return 0
		end

		return Style.GetTextSize(ratingText, fontSize, font, vector2, {
			addTemporaryPadding = false
		}).X
	end

	local v10

	if FFlagLuaAppNarrowTileHideRating then
		v10 = props.hideRating
	end

	local v11 = useMemo(fn, { ratingText, fontSize, font, v2, v10 })

	local v12 = v9 + v7 + v11 + v8

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, v5 and 1 or 0, v5 and 0 or size_500 + v2),
		Position = props.Position,
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local fillDirection

	if v5 then
		fillDirection = Enum.FillDirection.Vertical
	else
		fillDirection = Enum.FillDirection.Horizontal
	end

	local v14 = {
		FillDirection = fillDirection,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0
	}
	local padding

	if not v5 then
		padding = UDim.new(0, v8)
	end

	v14.Padding = padding
	local v15 = {
		UIListLayout = createElement2("UIListLayout", v14),
		RatingsFrame = 0,
		PlayerCountFrame = 0
	}
	local ratingsFrame

	if not (FFlagLuaAppNarrowTileHideRating and props.hideRating) then
		ratingsFrame = React.createElement("Frame", {
			Size = UDim2.new(0, v11 + v9 + v7, 0, size_500 + v2),
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}, {
			RatingIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v9, v9),
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					Image = iconsstatusgamesrating_small,
					ImageColor3 = default.Color3,
					ImageTransparency = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v9, v9),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			RatingText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				Text = ratingText,
				Size = UDim2.new(0, v11 + v7, 0, fontSize + v2),
				Position = UDim2.new(0, v9 + v7, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				TextSize = fontSize,
				FontFace = normalizeFontFace(gameTileMetadataFont.Font),
				TextTransparency = default.Transparency,
				TextColor3 = default.Color3,
				TextWrapped = false,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end

	v15.RatingsFrame = ratingsFrame
	local playerCountFrame

	if not (FFlagLuaAppNarrowTileHidePlayerCount and props.hidePlayerCount) then
		local createElement3 = React.createElement
		local udim

		if v5 then
			udim = UDim2.new(1, 0, 0, size_500 + v2)
		elseif FFlagLuaAppNarrowTileHideRating and props.hideRating then
			udim = UDim2.new(1, 0, 0, size_500 + v2)
		else
			udim = UDim2.new(1, -v12, 0, size_500 + v2)
		end

		playerCountFrame = createElement3("Frame", {
			Size = udim,
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}, {
			PlayerCountIconSlot = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0.5, 0),
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v9, v9),
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					Image = iconsstatusgamespeopleplaying_small,
					ImageColor3 = default.Color3,
					ImageTransparency = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v9, v9),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			PlayerCountText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				Text = props.playerCountText,
				Size = UDim2.new(1, -v9 - v7, 0, fontSize + v2),
				Position = UDim2.new(0, v9 + v7, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				TextSize = gameTileMetadataFont.FontSize,
				FontFace = normalizeFontFace(gameTileMetadataFont.Font),
				TextTransparency = default.Transparency,
				TextColor3 = default.Color3,
				TextWrapped = false,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end

	v15.PlayerCountFrame = playerCountFrame
	return createElement("Frame", v13, v15)
end

return GridTileGameStats
