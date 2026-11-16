local TextService = game:GetService("TextService")
local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTileTypes = require(GameTile.GameTileTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileFooterValueFixes = SharedFlags.FFlagLuaAppMigrateGameTileFooterValueFixes

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppFixSmallScreenFooterStatsOverlap = SharedFlags2.FFlagLuaAppFixSmallScreenFooterStatsOverlap
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags3.FFlagLuaAppNarrowTileHideRating
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags4.FFlagLuaAppNarrowTileHidePlayerCount

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
	local v7

	if props.isUnifiedGameTile then
		if FFlagLuaAppMigrateGameTileFooterValueFixes then
			v7 = v3.Size.Size_500
		else
			v7 = v3.Size.Size_300
		end
	elseif FFlagLuaAppMigrateGameTileFooterValueFixes then
		v7 = v.Size.Size_500
	else
		v7 = v.Size.Size_300
	end

	local v8

	if props.isUnifiedGameTile then
		v8 = if v6 then v3.Gap.XXSmall else v3.Gap.XSmall
	else
		v8 = v.Size.Size_100
	end

	local v9

	if props.isUnifiedGameTile then
		if FFlagLuaAppMigrateGameTileFooterValueFixes then
			v9 = if v4 then v3.Gap.XXSmall else v3.Gap.Small
		else
			v9 = v3.Gap.Medium
		end
	else
		v9 = v.Size.Size_200
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

	local v10 = fontSize / 1.26

	local ratingText = props.ratingText
	local useMemo = React.useMemo
	local function fn()
		if FFlagLuaAppNarrowTileHideRating and props.hideRating or ratingText == nil or ratingText == "" then
			return 0
		end

		if FoundationFontFaceMigration then
			return Style.GetTextSize(ratingText, fontSize, font, vector2, {
				addTemporaryPadding = false
			}).X
		end

		return TextService:GetTextSize(ratingText, fontSize, font, vector2).X
	end

	local v11

	if FFlagLuaAppNarrowTileHideRating then
		v11 = props.hideRating
	end

	local v12 = useMemo(fn, { ratingText, fontSize, font, v2, v11 })

	local v13 = v10 + v8 + v12 + v9

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, v5 and 1 or 0, v5 and 0 or v7 + v2),
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

	local v15 = {
		FillDirection = fillDirection,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0
	}
	local padding

	if not v5 then
		padding = UDim.new(0, v9)
	end

	v15.Padding = padding
	local v16 = {
		UIListLayout = createElement2("UIListLayout", v15),
		RatingsFrame = 0,
		PlayerCountFrame = 0
	}
	local ratingsFrame

	if not (FFlagLuaAppNarrowTileHideRating and props.hideRating) then
		local createElement3 = React.createElement
		local v17 = {
			Size = UDim2.new(0, v12 + v10 + v8, 0, v7 + v2),
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}

		local v18 = {
			RatingIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v10, v10),
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
					Size = UDim2.fromOffset(v10, v10),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			RatingText = 0
		}

		local createElement4 = React.createElement
		local v19 = {
			LayoutOrder = 2,
			Text = ratingText,
			Size = UDim2.new(0, v12 + v8, 0, fontSize + v2),
			Position = UDim2.new(0, v10 + v8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextSize = fontSize,
			Font = 0,
			FontFace = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = false,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = gameTileMetadataFont.Font
		end

		v19.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(gameTileMetadataFont.Font)
		end

		v19.FontFace = fontFace
		v19.TextTransparency = default.Transparency
		v19.TextColor3 = default.Color3

		v19.TextTruncate = Enum.TextTruncate.AtEnd
		v19.TextXAlignment = Enum.TextXAlignment.Left
		v19.TextYAlignment = Enum.TextYAlignment.Center
		v18.RatingText = createElement4("TextLabel", v19)
		ratingsFrame = createElement3("Frame", v17, v18)
	end

	v16.RatingsFrame = ratingsFrame
	local playerCountFrame

	if not (FFlagLuaAppNarrowTileHidePlayerCount and props.hidePlayerCount) then
		local createElement3 = React.createElement
		local udim

		if v5 then
			udim = UDim2.new(1, 0, 0, v7 + v2)
		elseif FFlagLuaAppNarrowTileHideRating and props.hideRating then
			udim = UDim2.new(1, 0, 0, v7 + v2)
		else
			udim = UDim2.new(1, -v13, 0, v7 + v2)
		end

		local v17 = {
			PlayerCountIconSlot = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0.5, 0),
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v10, v10),
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					Image = iconsstatusgamespeopleplaying_small,
					ImageColor3 = default.Color3,
					ImageTransparency = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v10, v10),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			PlayerCountText = 0
		}

		local createElement4 = React.createElement
		local v18 = {
			LayoutOrder = 2,
			Text = props.playerCountText,
			Size = UDim2.new(1, -v10 - v8, 0, fontSize + v2),
			Position = UDim2.new(0, v10 + v8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextSize = gameTileMetadataFont.FontSize,
			Font = 0,
			FontFace = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = false,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = gameTileMetadataFont.Font
		end

		v18.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(gameTileMetadataFont.Font)
		end

		v18.FontFace = fontFace
		v18.TextTransparency = default.Transparency
		v18.TextColor3 = default.Color3

		v18.TextTruncate = Enum.TextTruncate.AtEnd
		v18.TextXAlignment = Enum.TextXAlignment.Left
		v18.TextYAlignment = Enum.TextYAlignment.Center
		v17.PlayerCountText = createElement4("TextLabel", v18)
		playerCountFrame = createElement3("Frame", {
			Size = udim,
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}, v17)
	end

	v16.PlayerCountFrame = playerCountFrame
	return createElement("Frame", v14, v16)
end

return GridTileGameStats
