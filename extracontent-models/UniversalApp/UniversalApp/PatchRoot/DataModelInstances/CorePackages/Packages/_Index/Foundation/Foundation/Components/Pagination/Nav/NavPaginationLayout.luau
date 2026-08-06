local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)

require(Foundation.Enums.PaginationDirection)
require(Foundation.Enums.PaginationSize)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local NavControls = require(script.Parent.NavControls)

require(script.Parent.Parent.usePaginationSelectionChain)

local function NavPaginationLayout(p1, p2) -- line: 36
	-- upvalues: React (copy), View (copy), withCommonProps (copy), NavControls (copy)
	return React.createElement(View, withCommonProps(p1, {
		tag = "row align-y-center gap-small auto-xy",
		ref = p2
	}), {
		LeftNav = React.createElement(NavControls, {
			side = "start",
			layoutOrder = 1,
			size = p1.size,
			isFirstDisabled = p1.isFirstDisabled,
			isBackDisabled = p1.isBackDisabled,
			isForwardDisabled = p1.isForwardDisabled,
			isLastDisabled = p1.isLastDisabled,
			onDirectionActivated = p1.onDirectionActivated,
			hasFirstLastButtons = p1.hasFirstLastButtons,
			testId = p1.testId,
			selection = p1.selection
		}),
		PageContent = p1.pageContent,
		RightNav = React.createElement(NavControls, {
			side = "end",
			size = p1.size,
			layoutOrder = not p1.pageContent and 2 or 3,
			isFirstDisabled = p1.isFirstDisabled,
			isBackDisabled = p1.isBackDisabled,
			isForwardDisabled = p1.isForwardDisabled,
			isLastDisabled = p1.isLastDisabled,
			onDirectionActivated = p1.onDirectionActivated,
			hasFirstLastButtons = p1.hasFirstLastButtons,
			testId = p1.testId,
			selection = p1.selection
		})
	})
end

return React.memo(React.forwardRef(NavPaginationLayout))
