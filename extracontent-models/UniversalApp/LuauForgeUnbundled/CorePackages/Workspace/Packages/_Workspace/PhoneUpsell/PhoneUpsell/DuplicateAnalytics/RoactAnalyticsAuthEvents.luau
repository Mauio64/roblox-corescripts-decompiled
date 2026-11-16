local module = require("@luauforge/deferred/gxQ")
local module2 = require("@luauforge/deferred/gxR")
local EventStreamConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/EventStreamConstants")
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactServiceTags").RoactAnalytics

return {
	get = function(p2)
		local v5 = roactAnalytics.get(p2)

		return {
			reportModalShownWithSection = function(p3, p4, p5)
				module(v5.EventStream, p3, "", EventStreamConstants.ActionType.Shown, p4, p5)
			end,
			reportModalShownWithSectionAndError = function(p3, p4, p5, p6, p7)
				module(v5.EventStream, p3, p4, EventStreamConstants.ActionType.Shown, p5, p6, p7)
			end,
			reportModalDismissedWithSection = function(p3, p4, p5)
				module(v5.EventStream, p3, "", EventStreamConstants.ActionType.Dismiss, p4, p5)
			end,
			reportModalActionWithSection = function(p3, p4, p5, p6, p7, p8)
				module(v5.EventStream, p3, p4, p5, p6, p7, p8)
			end,
			reportInteractWithActionAndSection = function(p3, p4, p5, p6, p7, p8)
				module2(v5.EventStream, p3, p4, p5, p6, p7, p8)
			end
		}
	end
}
