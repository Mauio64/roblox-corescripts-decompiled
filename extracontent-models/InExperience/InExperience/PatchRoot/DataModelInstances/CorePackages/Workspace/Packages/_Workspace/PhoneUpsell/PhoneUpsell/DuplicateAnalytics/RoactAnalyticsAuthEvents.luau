local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local upsellCardModalAction = require(PhoneUpsell.DuplicateAnalytics.upsellCardModalAction)
local upsellCardFormInteraction = require(PhoneUpsell.DuplicateAnalytics.upsellCardFormInteraction)
local EventStreamConstants = require(PhoneUpsell.DuplicateAnalytics.EventStreamConstants)
local RoactAnalytics = require(PhoneUpsellParent.RoactServiceTags).RoactAnalytics

return {
	get = function(p1) -- line: 16
		-- upvalues: RoactAnalytics (copy), upsellCardModalAction (copy), EventStreamConstants (copy), upsellCardFormInteraction (copy)
		local v8 = RoactAnalytics.get(p1)

		return {
			reportModalShownWithSection = function(p2, p3, p4) -- line: 21
				-- upvalues: upsellCardModalAction (copy), v8 (copy), EventStreamConstants (copy)
				upsellCardModalAction(v8.EventStream, p2, "", EventStreamConstants.ActionType.Shown, p3, p4)
			end,
			reportModalShownWithSectionAndError = function(p5, p6, p7, p8, p9) -- line: 32
				-- upvalues: upsellCardModalAction (copy), v8 (copy), EventStreamConstants (copy)
				upsellCardModalAction(v8.EventStream, p5, p6, EventStreamConstants.ActionType.Shown, p7, p8, p9)
			end,
			reportModalDismissedWithSection = function(p10, p11, p12) -- line: 44
				-- upvalues: upsellCardModalAction (copy), v8 (copy), EventStreamConstants (copy)
				upsellCardModalAction(v8.EventStream, p10, "", EventStreamConstants.ActionType.Dismiss, p11, p12)
			end,
			reportModalActionWithSection = function(p13, p14, p15, p16, p17, p18) -- line: 55
				-- upvalues: upsellCardModalAction (copy), v8 (copy)
				upsellCardModalAction(v8.EventStream, p13, p14, p15, p16, p17, p18)
			end,
			reportInteractWithActionAndSection = function(p19, p20, p21, p22, p23, p24) -- line: 59
				-- upvalues: upsellCardFormInteraction (copy), v8 (copy)
				upsellCardFormInteraction(v8.EventStream, p19, p20, p21, p22, p23, p24)
			end
		}
	end
}
