local TextService = game:GetService("TextService")
local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local UIBlox = require(GameTileParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local Responsive = require(GameTileParent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTileTypes = require(GameTile.GameTileTypes)
local FFlagLuaAppMigrateGameTileFooterValueFixes = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileFooterValueFixes
local FFlagLuaAppFixSmallScreenFooterStatsOverlap = require(GameTileParent.SharedFlags).FFlagLuaAppFixSmallScreenFooterStatsOverlap
local FFlagLuaAppNarrowTileSmallerFooterFont = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameTileParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local v20 = Images["icons/status/games/rating_small"]
local v21 = Images["icons/status/games/people-playing_small"]
local vector2 = Vector2.new(1e999, 1e999)

local function GridTileGameStats(t1: {[any]: any}) -- line: 61
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), useTokens (copy), FFlagLuaAppFixSmallScreenFooterStatsOverlap (copy), useBreakpointXOrSmaller (copy), Responsive (copy), GameTileTypes (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppMigrateGameTileFooterValueFixes (copy), getGameTileMetadataFont (copy), React (copy), FFlagLuaAppNarrowTileHideRating (copy), TextService (copy), vector2 (copy), ImageSetLabel (copy), v20 (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), v21 (copy)
	local v25 = useDesignTokens()
	local v26 = useTextSizeOffset()
	local v27 = useTokens()
	local v28 = not not FFlagLuaAppFixSmallScreenFooterStatsOverlap and (useBreakpointXOrSmaller(Responsive.Keys.XSmall) and t1.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow)
	local v29 = useBreakpointXOrSmaller(Responsive.Keys.Small) and t1.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
	local v30 = v28 or FFlagLuaAppNarrowTileSmallerFooterFont and t1.compactMetadataFormat
	local v31 = if not t1.isUnifiedGameTile then if not FFlagLuaAppMigrateGameTileFooterValueFixes then v25.Size.Size_300 else v25.Size.Size_500 else if not FFlagLuaAppMigrateGameTileFooterValueFixes then v27.Size.Size_300 else v27.Size.Size_500
	local v32 = if not t1.isUnifiedGameTile then v25.Size.Size_100 else if not v30 then v27.Gap.XSmall else v27.Gap.XXSmall
	local v33 = if not t1.isUnifiedGameTile then v25.Size.Size_200 else if not FFlagLuaAppMigrateGameTileFooterValueFixes then v27.Gap.Medium else if not v28 then v27.Gap.Small else v27.Gap.XXSmall
	local v34 = if not t1.isUnifiedGameTile then v25.Color.Content.Default else v27.Color.Content.Default
	local v35 = getGameTileMetadataFont(t1.useLargerFont, v25, v27 or nil, not not t1.isUnifiedGameTile or nil, if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else t1.compactMetadataFormat)
	local FontSize = v35.FontSize
	local Font = v35.Font
	local v38 = v26 > 0 and v29
	local v39 = FontSize / 1.26
	local ratingText = t1.ratingText
	local v41 = React.useMemo(function() -- line: 110
		-- upvalues: FFlagLuaAppNarrowTileHideRating (copy), t1 (copy), ratingText (copy), TextService (copy), FontSize (copy), Font (copy), vector2 (copy)
		if FFlagLuaAppNarrowTileHideRating and t1.hideRating or (ratingText == nil or ratingText == "") then
			return 0
		end

		return TextService:GetTextSize(ratingText, FontSize, Font, vector2).X
	end, {
		ratingText,
		FontSize,
		Font,
		v26,
		if not FFlagLuaAppNarrowTileHideRating then nil else t1.hideRating
	})
	local v42 = v39 + v32 + v41 + v33

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, not v38 and 0 or 1, if not v38 then v31 + v26 else 0),
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = if not v38 then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = if not v38 then UDim.new(0, v33) else nil
		}),
		RatingsFrame = if not FFlagLuaAppNarrowTileHideRating or not t1.hideRating then React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v41 + v39 + v32, 0, v31 + v26)
		}, {
			RatingIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v39, v39),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					ImageTransparency = 0,
					BackgroundTransparency = 1,
					Image = v20,
					ImageColor3 = v34.Color3,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v39, v39),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}),
			RatingText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = false,
				Text = ratingText,
				Size = UDim2.new(0, v41 + v32, 0, FontSize + v26),
				Position = UDim2.new(0, v39 + v32, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				TextSize = FontSize,
				Font = v35.Font,
				TextTransparency = v34.Transparency,
				TextColor3 = v34.Color3,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}) else nil,
		PlayerCountFrame = if not FFlagLuaAppNarrowTileHidePlayerCount or not t1.hidePlayerCount then React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = if not v38 then if not FFlagLuaAppNarrowTileHideRating or not t1.hideRating then UDim2.new(1, -v42, 0, v31 + v26) else UDim2.new(1, 0, 0, v31 + v26) else UDim2.new(1, 0, 0, v31 + v26)
		}, {
			PlayerCountIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(v39, v39),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					ImageTransparency = 0,
					BackgroundTransparency = 1,
					Image = v21,
					ImageColor3 = v34.Color3,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v39, v39),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}),
			PlayerCountText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = false,
				Text = t1.playerCountText,
				Size = UDim2.new(1, -v39 - v32, 0, FontSize + v26),
				Position = UDim2.new(0, v39 + v32, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				TextSize = v35.FontSize,
				Font = v35.Font,
				TextTransparency = v34.Transparency,
				TextColor3 = v34.Color3,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}) else nil
	})
end

return GridTileGameStats
