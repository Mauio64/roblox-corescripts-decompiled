local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style")
local useDesignTokens = Style.useDesignTokens
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getGameTileMetadataFont")
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTileTypes = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

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

	local size_500 = if props.isUnifiedGameTile then v7.Size.Size_500 else v5.Size.Size_500
	local v11

	if props.isUnifiedGameTile then
		v11 = if v10 then v7.Gap.XXSmall else v7.Gap.XSmall
	else
		v11 = v5.Size.Size_100
	end

	local v12

	if props.isUnifiedGameTile then
		v12 = if v8 then v7.Gap.XXSmall else v7.Gap.Small
	else
		v12 = v5.Size.Size_200
	end

	local default = if props.isUnifiedGameTile then v7.Color.Content.Default else v5.Color.Content.Default
	local v13 = getGameTileMetadataFont(
		props.useLargerFont,
		v5,
		v7 or nil,
		props.isUnifiedGameTile and true or nil,
		props.compactMetadataFormat
	)

	local fontSize = v13.FontSize
	local font = v13.Font

	if not (v6 > 0) then
		v9 = false
	end

	local v14 = fontSize / 1.26

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

		return Style.GetTextSize(ratingText, fontSize, font, vector2, {
			addTemporaryPadding = false
		}).X
	end

	local v16 = if fFlagLuaAppNarrowTileHideRating then props.hideRating else nil
	local v17 = useMemo(fn, { ratingText, fontSize, font, v6, v16 })

	local v18 = v14 + v11 + v17 + v12

	local createElement = React.createElement
	local v20 = {
		Size = UDim2.new(1, 0, v9 and 1 or 0, v9 and 0 or size_500 + v6),
		Position = props.Position,
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement

	local v24 = if v9 then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
	local v23 = {
		FillDirection = v24,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0
	}
	local v25 = if not v9 then UDim.new(0, v12) else nil
	v23.Padding = v25
	local v21 = {
		UIListLayout = createElement2("UIListLayout", v23),
		RatingsFrame = 0,
		PlayerCountFrame = 0
	}

	local v26 = if not (fFlagLuaAppNarrowTileHideRating and props.hideRating) then React.createElement("Frame", {
		Size = UDim2.new(0, v17 + v14 + v11, 0, size_500 + v6),
		LayoutOrder = 1,
		BackgroundTransparency = 1
	}, {
		RatingIconSlot = React.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v14, v14),
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
				Size = UDim2.fromOffset(v14, v14),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1
			})
		}),
		RatingText = React.createElement("TextLabel", {
			LayoutOrder = 2,
			Text = ratingText,
			Size = UDim2.new(0, v17 + v11, 0, fontSize + v6),
			Position = UDim2.new(0, v14 + v11, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextSize = fontSize,
			FontFace = normalizeFontFace(v13.Font),
			TextTransparency = default.Transparency,
			TextColor3 = default.Color3,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	}) else nil
	v21.RatingsFrame = v26
	local v27

	if not (fFlagLuaAppNarrowTileHidePlayerCount and props.hidePlayerCount) then
		local createElement3 = React.createElement
		local udim

		if v9 then
			udim = UDim2.new(1, 0, 0, size_500 + v6)
		elseif fFlagLuaAppNarrowTileHideRating and props.hideRating then
			udim = UDim2.new(1, 0, 0, size_500 + v6)
		else
			udim = UDim2.new(1, -v18, 0, size_500 + v6)
		end

		v27 = createElement3("Frame", {
			Size = udim,
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}, {
			PlayerCountIconSlot = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0.5, 0),
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v14, v14),
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(imageSetLabel, {
					Image = iconsstatusgamespeopleplaying_small,
					ImageColor3 = default.Color3,
					ImageTransparency = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v14, v14),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1
				})
			}),
			PlayerCountText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				Text = props.playerCountText,
				Size = UDim2.new(1, -v14 - v11, 0, fontSize + v6),
				Position = UDim2.new(0, v14 + v11, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				TextSize = v13.FontSize,
				FontFace = normalizeFontFace(v13.Font),
				TextTransparency = default.Transparency,
				TextColor3 = default.Color3,
				TextWrapped = false,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end

	v21.PlayerCountFrame = v27
	return createElement("Frame", v20, v21)
end

return GridTileGameStats
