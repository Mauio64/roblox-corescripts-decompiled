local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function SecondChanceIntro(p1) -- line: 23
	-- upvalues: useNotApprovedPageContext (copy), React (copy), View (copy), FoundationText (copy)
	local translations = useNotApprovedPageContext().translations

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-large",
		LayoutOrder = p1.layoutOrder
	}, {
		Heading = React.createElement(FoundationText, {
			tag = "auto-xy text-heading-medium content-emphasis text-align-x-left text-wrap",
			LayoutOrder = 1,
			Text = translations.secondChanceIntroHeading
		}),
		Description = React.createElement(FoundationText, {
			tag = "auto-xy text-body-large text-align-x-left text-wrap",
			LayoutOrder = 2,
			Text = translations.secondChanceIntroDescription
		})
	})
end

return {
	getIsVisible = function(_, _: number?) -- line: 45
		return true
	end,
	renderComponent = React.memo(SecondChanceIntro)
}
