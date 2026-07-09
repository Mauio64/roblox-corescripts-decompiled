local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t1 = {
	EventContext = "HomePageRemindersEvent",
	EventName = "HomePageRemindersEvent",
	Platform = "PLATFORM_UNIVERSAL_APP",
	EventTypes = {
		CtaClicked = "REMINDER_INTERACTION_CTA_CLICKED",
		Dimissed = "REMINDER_INTERACTION_REMINDER_DISMISSED"
	}
}

return {
	sendEvent = function(p1, t2: {[any]: any}) -- line: 15
		-- upvalues: t1 (copy), Cryo (copy)
		p1:sendEventDeferred(t1.EventContext, t1.EventName, Cryo.Dictionary.join({
			platform = t1.Platform
		}, t2))
	end,
	Constants = t1
}
