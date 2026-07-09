local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local EvidenceField = require(NotApprovedPage.Components.EvidenceField)
local platformEvidence = require(NotApprovedPage.Utils.platformEvidence)
local parseDateFromString = require(NotApprovedPage.Utils.parseDateFromString)

require(NotApprovedPage.Common.Types)
require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local View = require(NotApprovedPageParent.Foundation).View
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function SimpleModeratorNote(p1) -- line: 32
	-- upvalues: useNotApprovedPageContext (copy), React (copy), View (copy), EvidenceField (copy), parseDateFromString (copy)
	local translations = useNotApprovedPageContext().translations
	local beginDate = p1.moderationDetail.beginDate

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = p1.layoutOrder
	}, {
		ReviewDate = React.createElement(EvidenceField, {
			layoutOrder = 2,
			fieldLabel = translations.dateReviewedLabel,
			fieldValue = parseDateFromString(beginDate, translations)
		})
	})
end

return {
	getIsVisible = function(p2) -- line: 49
		-- upvalues: platformEvidence (copy)
		local violation = p2.violation
		local badUtterances = p2.badUtterances

		return not platformEvidence.isVisibleInView(violation) and (not badUtterances or #badUtterances == 0)
	end,
	renderComponent = React.memo(SimpleModeratorNote)
}
