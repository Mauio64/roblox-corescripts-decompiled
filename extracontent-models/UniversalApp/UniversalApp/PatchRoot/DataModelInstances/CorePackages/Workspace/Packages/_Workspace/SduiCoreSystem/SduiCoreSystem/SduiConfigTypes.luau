local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local t = require(SduiCoreSystemParent.t)
local Cryo = require(SduiCoreSystemParent.Cryo)

require(SduiCoreSystem.SduiComponentType)

local ConditionalPropsInterface = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes).ConditionalPropsInterface
local FFlagSduiActionTelemetryHandler = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionTelemetryHandler
local t1 = {
	actionType = t.string,
	actionParams = t.optional(t.table),
	telemetryHandler = if not FFlagSduiActionTelemetryHandler then nil else t.optional(t.string)
}
local t2 = {
	componentType = t.string,
	props = t.optional(t.table),
	templateKey = t.optional(t.string),
	analyticsData = t.optional(t.table),
	children = t.optional(t.table),
	conditionalProps = t.optional(t.array(t.interface(ConditionalPropsInterface))),
	feedItemKey = t.optional(t.string),
	__processed = t.optional(t.boolean),
	__isClientBinding = t.optional(t.boolean),
	__usageRecorded = t.optional(t.boolean)
}
local v9 = Cryo.Dictionary.join(t2, {
	componentType = t.optional(t.string)
})

return {
	ActionInterface = t1,
	UiComponentInterface = t2,
	SduiTemplateInterface = v9
}
