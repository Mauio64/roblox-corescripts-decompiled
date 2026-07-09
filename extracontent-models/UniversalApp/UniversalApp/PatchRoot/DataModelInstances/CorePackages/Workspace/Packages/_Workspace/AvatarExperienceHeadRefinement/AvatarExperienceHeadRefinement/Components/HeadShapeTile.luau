local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local React = require(AvatarExperienceHeadRefinementParent.React)
local AppCommonStyle = require(AvatarExperienceHeadRefinementParent.AppCommonStyle)
local UIBlox = require(AvatarExperienceHeadRefinementParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(AvatarExperienceHeadRefinementParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local HeadShapeProperties = require(AvatarExperienceHeadRefinement.Enums.HeadShapeProperties)
local HeadShape = require(AvatarExperienceHeadRefinement.Enums.HeadShape)
local HeadShapeTileSize = require(AvatarExperienceHeadRefinement.Enums.HeadShapeTileSize)
local getMappedStyleTokens = require(AvatarExperienceHeadRefinement.Utils.getMappedStyleTokens)
local useDesignTokens = AppCommonStyle.useDesignTokens
local FFlagDynamicHeadsMigration = require(AvatarExperienceHeadRefinementParent.AvatarExperienceFlags).FFlagDynamicHeadsMigration

local function HeadShapeTile(t1: {[any]: any}) -- line: 38
	-- upvalues: useDesignTokens (copy), getMappedStyleTokens (copy), HeadShape (copy), FFlagDynamicHeadsMigration (copy), HeadShapeProperties (copy), HeadShapeTileSize (copy), React (copy), ImageSetButton (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ImageSetLabel (copy)
	local v17 = useDesignTokens()
	local v18 = getMappedStyleTokens(v17)
	local v19 = t1.headShape or HeadShape.Default
	local v20 = if not FFlagDynamicHeadsMigration or not t1.headShapeData then HeadShapeProperties[v19] else t1.headShapeData
	local v21 = if t1.size ~= HeadShapeTileSize.Large then v18.smallTileImageSize else v18.largeTileImageSize
	local v22 = if t1.size ~= HeadShapeTileSize.Large then v18.smallTileContainerSize else v18.largeTileContainerSize
	local v23 = React.useCallback(function() -- line: 55
		-- upvalues: t1 (copy)
		if t1.onActivated then
			t1.onActivated()
		end
	end, { t1.onActivated })

	return React.createElement(ImageSetButton, {
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v17.Semantic.Color.BackgroundUi.Default else v17.Color.Surface.Surface_300)).Color3,
		BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v17.Semantic.Color.BackgroundUi.Default else v17.Color.Surface.Surface_300)).Transparency,
		Size = UDim2.new(0, v22, 0, v22),
		[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeTile",
		[React.Event.Activated] = v23,
		LayoutOrder = t1.LayoutOrder,
		NextSelectionUp = t1.NextSelectionUp
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v17.Semantic.Radius.Medium else v17.Radius.Medium)
		}),
		UIStroke = if not t1.isSelected then nil else React.createElement("UIStroke", {
			Thickness = 2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Color = ((if not FFlagRenameDeprecatedUIBloxTokens then v17.Semantic.Color.Ui.Emphasis else v17.Color.Shift.Shift_400)).Color3
		}),
		HeadShapeTileImage = React.createElement(ImageSetLabel, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = v20.image,
			Size = UDim2.new(0, v21, 0, v21),
			BackgroundTransparency = 1,
			[React.Tag] = "data-testid=AvatarExperienceHeadRefinement_HeadShapeTile_Image"
		})
	})
end

return HeadShapeTile
