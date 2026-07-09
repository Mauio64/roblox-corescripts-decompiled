local HeadRefinementReducer = require(script.Reducers.HeadRefinementReducer)
local HeadShape = require(script.Enums.HeadShape)
local HeadShapeProperties = require(script.Enums.HeadShapeProperties)

return {
	Actions = {
		TryOnClassicHeadShape = require(script.Actions.TryOnClassicHeadShape),
		SetLastSelectedHeadShape = require(script.Actions.SetLastSelectedHeadShape),
		SetAvailableHeadShapes = require(script.Actions.SetAvailableHeadShapes),
		SetEquippedDynamicHeadShape = require(script.Actions.SetEquippedDynamicHeadShape),
		SetEquippedStaticFacialAnimation = require(script.Actions.SetEquippedStaticFacialAnimation)
	},
	Components = {
		HeadRefinementEntryButton = require(script.Components.HeadRefinementEntryButton),
		HeadShapeList = require(script.Components.HeadShapeList),
		HeadShapeTile = require(script.Components.HeadShapeTile)
	},
	Enums = {
		HeadShape = HeadShape,
		HeadShapeProperties = HeadShapeProperties,
		HeadShapePropertiesByAssetId = require(script.Enums.HeadShapePropertiesByAssetId)
	},
	Reducers = {
		HeadRefinementReducer = HeadRefinementReducer
	},
	Features = {
		HeadShapePicker = require(script.Features.HeadShapePicker)
	},
	Thunks = {
		GetUserOwnedClassicHeads = require(script.Thunks.GetUserOwnedClassicHeads),
		SetDynamicHeadShape = require(script.Thunks.SetDynamicHeadShape),
		SetStaticFacialAnimation = require(script.Thunks.SetStaticFacialAnimation)
	},
	Utils = {
		getMappedStyleTokens = require(script.Utils.getMappedStyleTokens),
		getFoundationMappedStyleTokens = require(script.Utils.getFoundationMappedStyleTokens),
		getEquippedHeadShapeName = require(script.Utils.getEquippedHeadShapeName),
		getDefaultSelectedHeadShapeName = require(script.Utils.getDefaultSelectedHeadShapeName),
		getShouldShowAdjustmentTooltipFromTime = require(script.Utils.getShouldShowAdjustmentTooltipFromTime),
		getHeadShapeListHeight = require(script.Utils.getHeadShapeListHeightConstraints)
	},
	Counters = require(script.Counters),
	["jest.config"] = script["jest.config"]
}
