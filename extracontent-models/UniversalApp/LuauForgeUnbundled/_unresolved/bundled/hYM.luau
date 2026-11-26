local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/hQO")

local v5 = {
	EventTypes = {
		CtaClicked = "REMINDER_INTERACTION_CTA_CLICKED",
		Dimissed = "REMINDER_INTERACTION_REMINDER_DISMISSED"
	},
	ExperimentVariants = {
		Invalid = "EXPERIMENT_VARIANT_INVALID",
		[module.ExperimentVariant.ChangeOrBlock] = "EXPERIMENT_VARIANT_CHANGE_OR_BLOCK",
		[module.ExperimentVariant.Warning] = "EXPERIMENT_VARIANT_WARNING"
	},
	EventContext = "HomePageRemindersEvent",
	EventName = "HomePageRemindersEvent",
	Platform = "PLATFORM_UNIVERSAL_APP"
}

return {
	sendEvent = function(object, p2)
		object:sendEventDeferred(
			v5.EventContext,
			v5.EventName,
			Cryo.Dictionary.join({ platform = v5.Platform }, p2)
		)
	end,
	Constants = v5
}
