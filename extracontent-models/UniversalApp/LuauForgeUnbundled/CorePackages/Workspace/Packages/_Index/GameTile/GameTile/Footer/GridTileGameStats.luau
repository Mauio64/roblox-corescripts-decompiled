local TextService = game:GetService("TextService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style")
local useDesignTokens = Style.useDesignTokens
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getGameTileMetadataFont")
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTileTypes = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local fFlagLuaAppMigrateGameTileFooterValueFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileFooterValueFixes

local fFlagLuaAppFixSmallScreenFooterStatsOverlap = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppFixSmallScreenFooterStatsOverlap
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount

local iconsstatusgamesrating_small = images["icons/status/games/rating_small"]
local iconsstatusgamespeopleplaying_small = images["icons/status/games/people-playing_small"]

local vector2 = Vector2.new(1e999, 1e999)

local function GridTileGameStats(props)
	local v5 = useDesignTokens()
	local v6 = useTextSizeOffset()
	local v7 = useTokens()
	local v8

	if fFlagLuaAppFixSmallScreenFooterStatsOverlap then
		v8 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
			and props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
	else
		v8 = false
	end

	local v9 = useBreakpointXOrSmaller(Responsive.Keys.Small)
		and props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow

	local v10 = v8 or props.compactMetadataFormat
	local v11

	if props.isUnifiedGameTile then
		v11 = if fFlagLuaAppMigrateGameTileFooterValueFixes then v7.Size.Size_500 else v7.Size.Size_300
	else
		v11 = if fFlagLuaAppMigrateGameTileFooterValueFixes then v5.Size.Size_500 else v5.Size.Size_300
	end

	local v12

	if props.isUnifiedGameTile then
		v12 = if v10 then v7.Gap.XXSmall else v7.Gap.XSmall
	else
		v12 = v5.Size.Size_100
	end

	local v13

	if props.isUnifiedGameTile then
		if fFlagLuaAppMigrateGameTileFooterValueFixes then
			v13 = if v8 then v7.Gap.XXSmall else v7.Gap.Small
		else
			v13 = v7.Gap.Medium
		end
	else
		v13 = v5.Size.Size_200
	end

	local default = if props.isUnifiedGameTile then v7.Color.Content.Default else v5.Color.Content.Default
	local v14 = getGameTileMetadataFont(
		props.useLargerFont,
		v5,
		v7 or nil,
		props.isUnifiedGameTile and true or nil,
		props.compactMetadataFormat
	)

	local fontSize = v14.FontSize
	local font = v14.Font

	if not (v6 > 0) then
		v9 = false
	end

	local v15 = fontSize / 1.26

	local ratingText = props.ratingText
	local useMemo = React.useMemo
	local function fn()
		if
			fFlagLuaAppNarrowTileHideRating and props.hideRating
			or ratingText == nil
			or ratingText == ""
		then
			return 0
		end

		if foundationFontFaceMigration then
			return Style.GetTextSize(ratingText, fontSize, font, vector2, {
				addTemporaryPadding = false
			}).X
		end

		return TextService:GetTextSize(ratingText, fontSize, font, vector2).X
	end

	local v17 = if fFlagLuaAppNarrowTileHideRating then props.hideRating else nil
	local v18 = useMemo(fn, { ratingText, fontSize, font, v6, v17 })

	local v19 = v15 + v12 + v18 + v13

	local createElement = React.createElement
	local v21 = {
		Size = UDim2.new(1, 0, v9 and 1 or 0, v9 and 0 or v11 + v6),
		Position = props.Position,
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement

	local v25 = if v9 then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
	local v24 = {
		FillDirection = v25,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0
	}
	local v26 = if not v9 then UDim.new(0, v13) else nil
	v24.Padding = v26
	local v22 = {
		UIListLayout = createElement2("UIListLayout", v24),
		RatingsFrame = 0,
		PlayerCountFrame = 0
	}
	local v27

	if not (fFlagLuaAppNarrowTileHideRating and props.hideRating) then
		local createElement3 = React.createElement
		local v29 = {
			Size = UDim2.new(0, v18 + v15 + v12, 0, v11 + v6),
			LayoutOrder = 1,
			BackgroundTransparency = 1
		}

		local v30 = {
			RatingIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v15, v15),
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(imageSetLabel, {
					Image = iconsstatusgamesrating_small,
					ImageColor3 = default.Color3,
					ImageTransparency = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v15, v15),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			RatingText = 0
		}

		local createElement4 = React.createElement
		local v32 = {
			LayoutOrder = 2,
			Text = ratingText,
			Size = UDim2.new(0, v18 + v12, 0, fontSize + v6),
			Position = UDim2.new(0, v15 + v12, 0.5, 0),
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

		local v33 = if not foundationFontFaceMigration then v14.Font else nil
		v32.Font = v33
		local v34 = if foundationFontFaceMigration then normalizeFontFace(v14.Font) else nil
		v32.FontFace = v34
		v32.TextTransparency = default.Transparency
		v32.TextColor3 = default.Color3

		v32.TextTruncate = Enum.TextTruncate.AtEnd
		v32.TextXAlignment = Enum.TextXAlignment.Left
		v32.TextYAlignment = Enum.TextYAlignment.Center
		v30.RatingText = createElement4("TextLabel", v32)
		v27 = createElement3("Frame", v29, v30)
	end

	v22.RatingsFrame = v27
	local v28

	if not (fFlagLuaAppNarrowTileHidePlayerCount and props.hidePlayerCount) then
		local createElement3 = React.createElement
		local udim

		if v9 then
			udim = UDim2.new(1, 0, 0, v11 + v6)
		elseif fFlagLuaAppNarrowTileHideRating and props.hideRating then
			udim = UDim2.new(1, 0, 0, v11 + v6)
		else
			udim = UDim2.new(1, -v19, 0, v11 + v6)
		end

		local v31 = {
			PlayerCountIconSlot = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0.5, 0),
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v15, v15),
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(imageSetLabel, {
					Image = iconsstatusgamespeopleplaying_small,
					ImageColor3 = default.Color3,
					ImageTransparency = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v15, v15),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			PlayerCountText = 0
		}

		local createElement4 = React.createElement
		local v33 = {
			LayoutOrder = 2,
			Text = props.playerCountText,
			Size = UDim2.new(1, -v15 - v12, 0, fontSize + v6),
			Position = UDim2.new(0, v15 + v12, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextSize = v14.FontSize,
			Font = 0,
			FontFace = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = false,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local v34 = if not foundationFontFaceMigration then v14.Font else nil
		v33.Font = v34
		local v35 = if foundationFontFaceMigration then normalizeFontFace(v14.Font) else nil
		v33.FontFace = v35
		v33.TextTransparency = default.Transparency
		v33.TextColor3 = default.Color3

		v33.TextTruncate = Enum.TextTruncate.AtEnd
		v33.TextXAlignment = Enum.TextXAlignment.Left
		v33.TextYAlignment = Enum.TextYAlignment.Center
		v31.PlayerCountText = createElement4("TextLabel", v33)
		v28 = createElement3("Frame", {
			Size = udim,
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}, v31)
	end

	v22.PlayerCountFrame = v28
	return createElement("Frame", v21, v22)
end

return GridTileGameStats
