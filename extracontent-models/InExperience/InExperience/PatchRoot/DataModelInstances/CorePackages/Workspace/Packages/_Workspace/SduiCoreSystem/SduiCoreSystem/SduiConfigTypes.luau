local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local t = require(parent.t)
local Cryo = require(parent.Cryo)
require(SduiCoreSystem.SduiErrors)

require(SduiCoreSystem.SduiComponentType)

local SduiConditionalPropTypes = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropTypes)
local ConditionalPropsInterface = SduiConditionalPropTypes.ConditionalPropsInterface

local actionInterface = {
	actionType = t.string,
	actionParams = t.optional(t.table),
	telemetryHandler = t.optional(t.string),
	skipUnifiedLogging = t.optional(t.boolean)
}

local uiComponentInterface = {
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

return {
	ActionInterface = actionInterface,
	UiComponentInterface = uiComponentInterface,
	SduiTemplateInterface = Cryo.Dictionary.join(uiComponentInterface, {
		componentType = t.optional(t.string)
	})
}
