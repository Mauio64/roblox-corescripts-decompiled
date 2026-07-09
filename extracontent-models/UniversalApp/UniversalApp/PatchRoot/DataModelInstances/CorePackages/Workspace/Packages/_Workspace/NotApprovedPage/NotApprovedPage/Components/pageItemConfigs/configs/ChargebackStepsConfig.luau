local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local VERIFICATION_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.VERIFICATION_TYPES

require(NotApprovedPage.Common.Types)
require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function ChargebackSteps(p1) -- line: 28
	-- upvalues: useNotApprovedPageContext (copy), VERIFICATION_TYPES (copy), React (copy), View (copy), FoundationText (copy)
	local translations = useNotApprovedPageContext().translations
	local v12 = if p1.moderationDetail.verificationCategory ~= VERIFICATION_TYPES.Parent then translations.emailReactivationNotice else translations.parentReactivationNotice

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium",
		LayoutOrder = p1.layoutOrder
	}, {
		Heading = React.createElement(FoundationText, {
			tag = "auto-xy text-heading-medium text-align-x-left text-wrap content-emphasis",
			LayoutOrder = 1,
			Text = translations.chargebackNextSteps
		}),
		Content = React.createElement(FoundationText, {
			tag = "auto-xy text-align-x-left text-wrap text-body-large",
			LayoutOrder = 2,
			Text = v12
		})
	})
end

return {
	getIsVisible = function(p2) -- line: 55
		-- upvalues: VERIFICATION_TYPES (copy)
		local verificationCategory = p2.verificationCategory

		return verificationCategory == VERIFICATION_TYPES.Parent or verificationCategory == VERIFICATION_TYPES.Email
	end,
	renderComponent = React.memo(ChargebackSteps)
}
