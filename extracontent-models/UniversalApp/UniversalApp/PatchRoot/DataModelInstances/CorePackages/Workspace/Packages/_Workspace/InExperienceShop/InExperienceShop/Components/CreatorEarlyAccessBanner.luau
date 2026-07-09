local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FeedbackAlert = Foundation.FeedbackAlert
local AlertSeverity = Foundation.Enums.AlertSeverity
local t1 = {
	message = "Feature.InExperienceShop.Label.PreviewBanner"
}

local function CreatorEarlyAccessBanner(t2: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), FeedbackAlert (copy), AlertSeverity (copy)
	local v10 = useLocalization(t1)

	return React.createElement(FeedbackAlert, {
		testId = "CreatorEarlyAccessBanner",
		severity = AlertSeverity.Info,
		title = v10.message,
		LayoutOrder = t2.LayoutOrder
	})
end

return CreatorEarlyAccessBanner
