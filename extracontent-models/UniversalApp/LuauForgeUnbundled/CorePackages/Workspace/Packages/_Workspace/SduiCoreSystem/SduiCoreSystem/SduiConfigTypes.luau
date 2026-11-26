local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/t")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")

local conditionalPropsInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropTypes").ConditionalPropsInterface

local v5 = {
	actionType = t.string,
	actionParams = t.optional(t.table),
	telemetryHandler = t.optional(t.string),
	skipUnifiedLogging = t.optional(t.boolean)
}

local v6 = {
	componentType = t.string,
	props = t.optional(t.table),
	templateKey = t.optional(t.string),
	analyticsData = t.optional(t.table),
	children = t.optional(t.table),
	conditionalProps = t.optional(t.array(t.interface(conditionalPropsInterface))),
	feedItemKey = t.optional(t.string),
	__processed = t.optional(t.boolean),
	__isClientBinding = t.optional(t.boolean),
	__usageRecorded = t.optional(t.boolean)
}

return {
	ActionInterface = v5,
	UiComponentInterface = v6,
	SduiTemplateInterface = Cryo.Dictionary.join(v6, {
		componentType = t.optional(t.string)
	})
}
