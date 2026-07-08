local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local t = require(Parent.t)
local t1 = {
	friendInGame = "friendInGame",
	imageQualityLevel = "imageQualityLevel",
	isPortrait = "isPortrait",
	lastInput = "lastInput",
	maxScreenWidth = "maxScreenWidth",
	minScreenWidth = "minScreenWidth",
	performanceLevel = "performanceLevel",
	preferredInput = "preferredInput",
	isSpatial = "isSpatial"
}
local t2 = {
	imageQualityLevel = "imageQualityLevel",
	isPortrait = "isPortrait",
	lastInput = "lastInput",
	maxScreenWidth = "maxScreenWidth",
	minScreenWidth = "minScreenWidth",
	performanceLevel = "performanceLevel",
	preferredInput = "preferredInput",
	isSpatial = "isSpatial"
}
local v5 = t.union(t.literal("Touch"), t.literal("Pointer"), t.literal("Directional"))
local v6 = t.interface({
	imageQualityLevel = t.optional(t.string),
	isPortrait = t.optional(t.boolean),
	isSpatial = t.optional(t.boolean),
	lastInput = t.optional(v5),
	maxScreenWidth = t.optional(t.number),
	minScreenWidth = t.optional(t.number),
	performanceLevel = t.optional(t.string),
	preferredInput = t.optional(v5)
})
local t3 = {
	propOverrides = t.table,
	conditions = t.optional(v6)
}

return {
	SduiConditionKey = t1,
	SduiResponsiveKey = t2,
	ConditionalPropsInterface = t3
}
