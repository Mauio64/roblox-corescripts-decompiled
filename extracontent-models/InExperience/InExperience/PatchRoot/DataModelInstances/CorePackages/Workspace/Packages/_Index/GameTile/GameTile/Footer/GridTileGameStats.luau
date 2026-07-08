local TextService = game:GetService("TextService")
local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local UIBlox = require(GameTileParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(GameTileParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
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
local v21 = Images["icons/status/games/rating_small"]
local v22 = Images["icons/status/games/people-playing_small"]
local vector2 = Vector2.new(1e999, 1e999)

local function GridTileGameStats(t1: {[any]: any}) -- line: 63
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), useTokens (copy), FFlagLuaAppFixSmallScreenFooterStatsOverlap (copy), useBreakpointXOrSmaller (copy), Responsive (copy), GameTileTypes (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppMigrateGameTileFooterValueFixes (copy), FFlagRenameDeprecatedUIBloxTokens (copy), getGameTileMetadataFont (copy), React (copy), FFlagLuaAppNarrowTileHideRating (copy), TextService (copy), vector2 (copy), ImageSetLabel (copy), v21 (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), v22 (copy)
	local v26 = useDesignTokens()
	local v27 = useTextSizeOffset()
	local v28 = useTokens()
	local v29 = not not FFlagLuaAppFixSmallScreenFooterStatsOverlap and (useBreakpointXOrSmaller(Responsive.Keys.XSmall) and t1.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow)
	local v30 = useBreakpointXOrSmaller(Responsive.Keys.Small) and t1.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow
	local v31 = v29 or FFlagLuaAppNarrowTileSmallerFooterFont and t1.compactMetadataFormat
	local v32 = if not t1.isUnifiedGameTile then if not FFlagLuaAppMigrateGameTileFooterValueFixes then if not FFlagRenameDeprecatedUIBloxTokens then v26.Global.Space_150 else v26.Size.Size_300 else if not FFlagRenameDeprecatedUIBloxTokens then v26.Global.Space_250 else v26.Size.Size_500 else if not FFlagLuaAppMigrateGameTileFooterValueFixes then v28.Size.Size_300 else v28.Size.Size_500
	local v33 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v26.Global.Space_50 else v26.Size.Size_100 else if not v31 then v28.Gap.XSmall else v28.Gap.XXSmall
	local v34 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v26.Global.Space_100 else v26.Size.Size_200 else if not FFlagLuaAppMigrateGameTileFooterValueFixes then v28.Gap.Medium else if not v29 then v28.Gap.Small else v28.Gap.XXSmall
	local v35 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v26.Semantic.Color.Text.Default else v26.Color.Content.Default else v28.Color.Content.Default
	local v36 = getGameTileMetadataFont(t1.useLargerFont, v26, v28 or nil, not not t1.isUnifiedGameTile or nil, if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else t1.compactMetadataFormat)
	local FontSize = v36.FontSize
	local Font = v36.Font
	local v39 = v27 > 0 and v30
	local v40 = FontSize / 1.26
	local ratingText = t1.ratingText
	local v42 = React.useMemo(function() -- line: 116
		-- upvalues: FFlagLuaAppNarrowTileHideRating (copy), t1 (copy), ratingText (copy), TextService (copy), FontSize (copy), Font (copy), vector2 (copy)
		if FFlagLuaAppNarrowTileHideRating and t1.hideRating or (ratingText == nil or ratingText == "") then
			return 0
		end

		return TextService:GetTextSize(ratingText, FontSize, Font, vector2).X
	end, {
		ratingText,
		FontSize,
		Font,
		v27,
		if not FFlagLuaAppNarrowTileHideRating then nil else t1.hideRating
	})
	local v43 = v40 + v33 + v42 + v34

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, not v39 and 0 or 1, if not v39 then v32 + v27 else 0),
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = if not v39 then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = if not v39 then UDim.new(0, v34) else nil
		}),
		RatingsFrame = if not FFlagLuaAppNarrowTileHideRating or not t1.hideRating then React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v42 + v40 + v33, 0, v32 + v27)
		}, {
			RatingIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v40, v40),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					ImageTransparency = 0,
					BackgroundTransparency = 1,
					Image = v21,
					ImageColor3 = v35.Color3,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v40, v40),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}),
			RatingText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = false,
				Text = ratingText,
				Size = UDim2.new(0, v42 + v33, 0, FontSize + v27),
				Position = UDim2.new(0, v40 + v33, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				TextSize = FontSize,
				Font = v36.Font,
				TextTransparency = v35.Transparency,
				TextColor3 = v35.Color3,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}) else nil,
		PlayerCountFrame = if not FFlagLuaAppNarrowTileHidePlayerCount or not t1.hidePlayerCount then React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = if not v39 then if not FFlagLuaAppNarrowTileHideRating or not t1.hideRating then UDim2.new(1, -v43, 0, v32 + v27) else UDim2.new(1, 0, 0, v32 + v27) else UDim2.new(1, 0, 0, v32 + v27)
		}, {
			PlayerCountIconSlot = React.createElement("Frame", {
				LayoutOrder = 1,
				ClipsDescendants = false,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(v40, v40),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Icon = React.createElement(ImageSetLabel, {
					ImageTransparency = 0,
					BackgroundTransparency = 1,
					Image = v22,
					ImageColor3 = v35.Color3,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(v40, v40),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}),
			PlayerCountText = React.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextWrapped = false,
				Text = t1.playerCountText,
				Size = UDim2.new(1, -v40 - v33, 0, FontSize + v27),
				Position = UDim2.new(0, v40 + v33, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				TextSize = v36.FontSize,
				Font = v36.Font,
				TextTransparency = v35.Transparency,
				TextColor3 = v35.Color3,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}) else nil
	})
end

return GridTileGameStats
