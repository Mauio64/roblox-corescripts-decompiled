local module = require("@luauforge/deferred/fVk")
local module2 = require("@luauforge/deferred/fVl")
local module3 = require("@luauforge/deferred/fVo")

require("@luauforge/deferred/fUR")

require("@luauforge/deferred/fUY")

local module4 = require("@luauforge/deferred/fUU")
local view = require("@luauforge/deferred/fUV").View

local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

local function SimpleModeratorNote(p2)
	local translations = useNotApprovedPageContext().translations
	local beginDate = p2.moderationDetail.beginDate

	return module4.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = p2.layoutOrder },
		{
			ReviewDate = module4.createElement(module, {
				fieldLabel = translations.dateReviewedLabel,
				fieldValue = module3(beginDate, translations),
				layoutOrder = 2
			})
		}
	)
end

return {
	getIsVisible = function(p2): boolean
		local violation = p2.violation
		local badUtterances = p2.badUtterances
		return not module2.isVisibleInView(violation) and (not badUtterances or #badUtterances == 0)
	end,
	renderComponent = module4.memo(SimpleModeratorNote)
}
