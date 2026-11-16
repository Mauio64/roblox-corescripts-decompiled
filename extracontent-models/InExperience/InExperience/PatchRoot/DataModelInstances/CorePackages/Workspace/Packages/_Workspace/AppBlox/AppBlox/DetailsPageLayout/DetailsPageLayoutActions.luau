local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)

local function DetailsPageLayoutActions(p, ref)
	local v = React.useContext(DetailsPageLayoutContext)
	local setHasActions = v.setHasActions
	local setActionBarHeight = v.setActionBarHeight
	local testId = v.testId

	assert(
		setHasActions and setActionBarHeight and testId,
		"DetailsPageLayout.Actions must be used within DetailsPageLayout.Root"
	)

	React.useEffect(function()
		setHasActions(true)
		return function()
			setHasActions(false)
			setActionBarHeight(0)
		end
	end, {})

	local createElement = React.createElement
	local v2 = {
		tag = "row size-full-0 auto-y bg-surface-0 stroke-muted stroke-standard position-bottom-left anchor-bottom-left align-y-center gap-small align-x-center padding-top-large padding-bottom-medium padding-x-large",
		onAbsoluteSizeChanged = function(p2)
			setActionBarHeight(p2.AbsoluteSize.Y)
		end,
		ZIndex = 2,
		testId = 0,
		onActivated = 0,
		selection = 0,
		stateLayer = 0,
		ref = 0
	}
	local testId2

	if testId then
		testId2 = `{testId}--actions`
	end

	v2.testId = testId2
	function v2.onActivated() end
	v2.selection = { Selectable = false }
	v2.stateLayer = { affordance = StateLayerAffordance.None }
	v2.ref = ref
	return createElement(View, v2, p.children)
end

return React.memo(React.forwardRef(DetailsPageLayoutActions))
