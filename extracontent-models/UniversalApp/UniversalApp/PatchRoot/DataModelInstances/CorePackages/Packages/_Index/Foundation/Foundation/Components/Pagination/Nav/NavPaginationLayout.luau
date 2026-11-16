local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(Foundation.Enums.PaginationDirection)

require(Foundation.Enums.PaginationSize)

local withCommonProps = require(Foundation.Utility.withCommonProps)

local NavControls = require(script.Parent.NavControls)
require(script.Parent.Parent.usePaginationSelectionChain)

local function NavPaginationLayout(props, ref)
	return React.createElement(
		View,
		withCommonProps(props, { tag = "row align-y-center gap-small auto-xy", ref = ref }),
		{
			LeftNav = React.createElement(NavControls, {
				side = "start",
				size = props.size,
				LayoutOrder = 1,
				isFirstDisabled = props.isFirstDisabled,
				isBackDisabled = props.isBackDisabled,
				isForwardDisabled = props.isForwardDisabled,
				isLastDisabled = props.isLastDisabled,
				onDirectionActivated = props.onDirectionActivated,
				hasFirstLastButtons = props.hasFirstLastButtons,
				testId = props.testId,
				selection = props.selection
			}),
			PageContent = props.pageContent,
			RightNav = React.createElement(NavControls, {
				side = "end",
				size = props.size,
				LayoutOrder = props.pageContent and 3 or 2,
				isFirstDisabled = props.isFirstDisabled,
				isBackDisabled = props.isBackDisabled,
				isForwardDisabled = props.isForwardDisabled,
				isLastDisabled = props.isLastDisabled,
				onDirectionActivated = props.onDirectionActivated,
				hasFirstLastButtons = props.hasFirstLastButtons,
				testId = props.testId,
				selection = props.selection
			})
		}
	)
end

return React.memo(React.forwardRef(NavPaginationLayout))
