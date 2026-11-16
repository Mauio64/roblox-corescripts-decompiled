local module = require("@luauforge/bundled/dHQ")
local module2 = require("@luauforge/bundled/dHW")

return {
	Actions = {
		SetLastSelectedHeadShape = require("@luauforge/bundled/dHV"),
		SetAvailableHeadShapes = require("@luauforge/bundled/dHU"),
		SetEquippedDynamicHeadShape = require("@luauforge/bundled/dLb"),
		SetEquippedStaticFacialAnimation = require("@luauforge/bundled/dLc")
	},
	Components = {
		HeadRefinementEntryButton = require("@luauforge/bundled/dLd"),
		HeadShapeList = require("@luauforge/bundled/dLg"),
		HeadShapeTile = require("@luauforge/bundled/dLk")
	},
	Enums = {
		HeadShapeProperties = module2,
		HeadShapePropertiesByAssetId = require("@luauforge/bundled/dLo")
	},
	Reducers = { HeadRefinementReducer = module },
	Features = { HeadShapePicker = require("@luauforge/bundled/dLp") },
	Thunks = {
		GetUserOwnedClassicHeads = require("@luauforge/bundled/dLs"),
		SetDynamicHeadShape = require("@luauforge/bundled/dLx"),
		SetStaticFacialAnimation = require("@luauforge/bundled/dLB")
	},
	Utils = {
		getMappedStyleTokens = require("@luauforge/bundled/dLm"),
		getFoundationMappedStyleTokens = require("@luauforge/bundled/dLn"),
		getEquippedHeadShapeName = require("@luauforge/bundled/dLC"),
		getDefaultSelectedHeadShapeName = require("@luauforge/bundled/dLE"),
		getShouldShowAdjustmentTooltipFromTime = require("@luauforge/bundled/dLF"),
		getHeadShapeListHeight = require("@luauforge/bundled/dLG")
	},
	Counters = require("@luauforge/bundled/dLv")
}
