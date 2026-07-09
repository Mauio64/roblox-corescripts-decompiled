local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local Progress = Foundation.Progress
local ProgressShape = Foundation.Enums.ProgressShape
local usePageNavigation = require(NotApprovedPage.Contexts.PageNavigationContext).usePageNavigation

local function HeaderProgressBar() -- line: 17
	-- upvalues: usePageNavigation (copy), React (copy), Progress (copy), ProgressShape (copy)
	local v9 = usePageNavigation().getProgress()

	return v9 > 0 and React.createElement(Progress, {
		testId = "header-progress-bar",
		value = v9,
		shape = ProgressShape.Bar
	}) or nil
end

return React.memo(HeaderProgressBar)
