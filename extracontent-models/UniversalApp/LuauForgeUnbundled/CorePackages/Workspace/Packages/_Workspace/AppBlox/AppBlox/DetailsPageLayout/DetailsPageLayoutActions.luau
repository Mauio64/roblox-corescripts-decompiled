local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")

local view = Foundation.View
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local DetailsPageLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout/DetailsPageLayoutContext")

local function DetailsPageLayoutActions(p2, ref)
	local v5 = React.useContext(DetailsPageLayoutContext)
	local setHasActions = v5.setHasActions
	local setActionBarHeight = v5.setActionBarHeight
	local testId = v5.testId

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
	local v7 = {
		tag = "row size-full-0 auto-y bg-surface-0 stroke-muted stroke-standard position-bottom-left anchor-bottom-left align-y-center gap-small align-x-center padding-top-large padding-bottom-medium padding-x-large",
		onAbsoluteSizeChanged = function(p3)
			setActionBarHeight(p3.AbsoluteSize.Y)
		end,
		ZIndex = 2,
		testId = 0,
		onActivated = 0,
		selection = 0,
		stateLayer = 0,
		ref = 0
	}

	local v8 = if testId then `{testId}--actions` else nil
	v7.testId = v8
	function v7.onActivated() end
	v7.selection = { Selectable = false }
	v7.stateLayer = { affordance = stateLayerAffordance.None }
	v7.ref = ref
	return createElement(view, v7, p2.children)
end

return React.memo(React.forwardRef(DetailsPageLayoutActions))
