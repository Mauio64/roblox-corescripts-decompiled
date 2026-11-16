require("@luauforge/deferred/fUR")

local module = require("@luauforge/deferred/fUU")

local view = require("@luauforge/deferred/fUV").View

return {
	renderPageItemsFromList = function(list, p2, p3, p4, p5, p6, p7, p8)
		local children = {}

		for i, item in ipairs(list) do
			if not item.getIsVisible(p2, p4, p7, p8) then
				continue
			end

			local element = module.createElement(item.renderComponent, {
				moderationDetail = p2,
				layoutOrder = i,
				dispatch = p3,
				hasEducationalPages = p5
			})

			if p6 == false then
				table.insert(
					children,
					module.createElement(
						view,
						{
							tag = "size-full-0 auto-y padding-bottom-large",
							LayoutOrder = i
						},
						{ Content = element }
					)
				)
			else
				table.insert(children, element)
			end
		end

		return children
	end,
	EDUCATIONAL_PAGE_PREFIXES = {
		Rule = "policy-rule-",
		Importance = "policy-importance-"
	},
	STATIC_PAGE_NAMES = {
		Intro = "intro",
		Resolution = "resolution",
		SecondChanceIntro = "second-chance-intro",
		SecondChanceConclusion = "second-chance-conclusion",
		Unknown = "unknown"
	}
}
