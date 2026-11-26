local VERIFICATION_TYPES = require("@luauforge/deferred/gzN").Constants.VERIFICATION_TYPES

require("@luauforge/deferred/gzP")

require("@luauforge/deferred/gzW")

local module = require("@luauforge/deferred/gzS")
local module2 = require("@luauforge/deferred/gzT")
local text = module2.Text
local view = module2.View

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local function ChargebackSteps(p2)
	local translations = useNotApprovedPageContext().translations
	local v5

	if p2.moderationDetail.verificationCategory == VERIFICATION_TYPES.Parent then
		v5 = translations.parentReactivationNotice
	else
		v5 = translations.emailReactivationNotice
	end

	return module.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-medium", LayoutOrder = p2.layoutOrder },
		{
			Heading = module.createElement(text, {
				Text = translations.chargebackNextSteps,
				tag = "auto-xy text-heading-medium text-align-x-left text-wrap content-emphasis",
				LayoutOrder = 1
			}),
			Content = module.createElement(text, {
				Text = v5,
				tag = "auto-xy text-align-x-left text-wrap text-body-large",
				LayoutOrder = 2
			})
		}
	)
end

return {
	getIsVisible = function(p2): boolean
		local verificationCategory = p2.verificationCategory
		return verificationCategory == VERIFICATION_TYPES.Parent
			or verificationCategory == VERIFICATION_TYPES.Email
	end,
	renderComponent = module.memo(ChargebackSteps)
}
