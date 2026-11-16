local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FeedbackAlert = Foundation.FeedbackAlert
local AlertSeverity = Foundation.Enums.AlertSeverity

local v = { message = "Feature.InExperienceShop.Label.PreviewBanner" }

local function CreatorEarlyAccessBanner(p)
	local v2 = useLocalization(v)

	return React.createElement(FeedbackAlert, {
		severity = AlertSeverity.Info,
		title = v2.message,
		LayoutOrder = p.LayoutOrder,
		testId = "CreatorEarlyAccessBanner"
	})
end

return CreatorEarlyAccessBanner
