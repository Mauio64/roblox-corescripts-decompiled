local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local upsellCardModalAction = require(PhoneUpsell.DuplicateAnalytics.upsellCardModalAction)
local upsellCardFormInteraction = require(PhoneUpsell.DuplicateAnalytics.upsellCardFormInteraction)
local EventStreamConstants = require(PhoneUpsell.DuplicateAnalytics.EventStreamConstants)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics

return {
	get = function(p)
		local v = RoactAnalytics.get(p)

		return {
			reportModalShownWithSection = function(p2, p3, p4)
				upsellCardModalAction(v.EventStream, p2, "", EventStreamConstants.ActionType.Shown, p3, p4)
			end,
			reportModalShownWithSectionAndError = function(p2, p3, p4, p5, p6)
				upsellCardModalAction(v.EventStream, p2, p3, EventStreamConstants.ActionType.Shown, p4, p5, p6)
			end,
			reportModalDismissedWithSection = function(p2, p3, p4)
				upsellCardModalAction(v.EventStream, p2, "", EventStreamConstants.ActionType.Dismiss, p3, p4)
			end,
			reportModalActionWithSection = function(p2, p3, p4, p5, p6, p7)
				upsellCardModalAction(v.EventStream, p2, p3, p4, p5, p6, p7)
			end,
			reportInteractWithActionAndSection = function(p2, p3, p4, p5, p6, p7)
				upsellCardFormInteraction(v.EventStream, p2, p3, p4, p5, p6, p7)
			end
		}
	end
}
