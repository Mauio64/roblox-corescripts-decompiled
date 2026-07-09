local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent

require(NotApprovedPage.Common.Types)

local React = require(NotApprovedPageParent.React)
local View = require(NotApprovedPageParent.Foundation).View
local t1 = {
	Intro = "intro",
	Resolution = "resolution",
	SecondChanceIntro = "second-chance-intro",
	SecondChanceConclusion = "second-chance-conclusion",
	Unknown = "unknown"
}
local t2 = {
	Rule = "policy-rule-",
	Importance = "policy-importance-"
}

return {
	renderPageItemsFromList = function(t3: {[any]: any}, p1, p2: ((...any) -> ...any), n1: number?, b1: boolean?, b2: boolean?, s1: string?, p3) -- line: 72
		-- upvalues: React (copy), View (copy)
		local t4 = {}

		for i, v in ipairs(t3) do
			if v.getIsVisible(p1, n1, s1, p3) then
				local v18 = React.createElement(v.renderComponent, {
					moderationDetail = p1,
					layoutOrder = i,
					dispatch = p2,
					hasEducationalPages = b1
				})

				if b2 == false then
					table.insert(t4, React.createElement(View, {
						tag = "size-full-0 auto-y padding-bottom-large",
						LayoutOrder = i
					}, {
						Content = v18
					}))
				else
					table.insert(t4, v18)
				end
			end
		end

		return t4
	end,
	EDUCATIONAL_PAGE_PREFIXES = t2,
	STATIC_PAGE_NAMES = t1
}
