local parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local t = require(parent.t)

local union = t.union(t.literal("Touch"), t.literal("Pointer"), t.literal("Directional"))
local interface = t.interface({
	imageQualityLevel = t.optional(t.string),
	isPortrait = t.optional(t.boolean),
	isSpatial = t.optional(t.boolean),
	lastInput = t.optional(union),
	maxScreenWidth = t.optional(t.number),
	minScreenWidth = t.optional(t.number),
	performanceLevel = t.optional(t.string),
	preferredInput = t.optional(union)
})
return {
	SduiConditionKey = {
		friendInGame = "friendInGame",
		imageQualityLevel = "imageQualityLevel",
		isPortrait = "isPortrait",
		lastInput = "lastInput",
		maxScreenWidth = "maxScreenWidth",
		minScreenWidth = "minScreenWidth",
		performanceLevel = "performanceLevel",
		preferredInput = "preferredInput",
		isSpatial = "isSpatial"
	},
	SduiResponsiveKey = {
		imageQualityLevel = "imageQualityLevel",
		isPortrait = "isPortrait",
		lastInput = "lastInput",
		maxScreenWidth = "maxScreenWidth",
		minScreenWidth = "minScreenWidth",
		performanceLevel = "performanceLevel",
		preferredInput = "preferredInput",
		isSpatial = "isSpatial"
	},
	ConditionalPropsInterface = { propOverrides = t.table, conditions = t.optional(interface) }
}
