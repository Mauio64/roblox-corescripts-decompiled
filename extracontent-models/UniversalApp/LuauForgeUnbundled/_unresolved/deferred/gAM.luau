require("@luauforge/deferred/gzP")

local module = require("@luauforge/deferred/gzS")

local module2 = require("@luauforge/deferred/gzT")
local text = module2.Text
local view = module2.View

require("@luauforge/deferred/gzW")

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local function SecondChanceConclusion(p2)
	local translations = useNotApprovedPageContext().translations

	return module.createElement(
		view,
		{ tag = "col size-full-0 auto-y gap-medium", LayoutOrder = p2.layoutOrder },
		{
			Heading = module.createElement(text, {
				Text = translations.secondChanceConclusionHeading,
				tag = "auto-xy text-heading-medium content-emphasis text-align-x-left text-wrap",
				LayoutOrder = 1
			}),
			Description = module.createElement(text, {
				Text = translations.secondChanceConclusionDescription,
				tag = "auto-xy text-body-large text-align-x-left text-wrap",
				LayoutOrder = 2
			})
		}
	)
end

return {
	getIsVisible = function(p2, p3): boolean
		return true
	end,
	renderComponent = module.memo(SecondChanceConclusion)
}
