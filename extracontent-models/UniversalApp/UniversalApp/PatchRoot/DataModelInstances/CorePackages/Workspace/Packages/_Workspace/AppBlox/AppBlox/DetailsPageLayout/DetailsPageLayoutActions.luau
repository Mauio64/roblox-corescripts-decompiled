local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)

local function DetailsPageLayoutActions(t1: {[any]: any}, p1) -- line: 24
	-- upvalues: React (copy), DetailsPageLayoutContext (copy), View (copy), StateLayerAffordance (copy)
	local v10 = React.useContext(DetailsPageLayoutContext)
	local setHasActions = v10.setHasActions
	local setActionBarHeight = v10.setActionBarHeight
	local testId = v10.testId

	assert(setHasActions and (setActionBarHeight and testId), "DetailsPageLayout.Actions must be used within DetailsPageLayout.Root")
	React.useEffect(function() -- line: 35
		-- upvalues: setHasActions (copy), setActionBarHeight (copy)
		setHasActions(true)

		return function() -- line: 37
			-- upvalues: setHasActions (copy), setActionBarHeight (copy)
			setHasActions(false)
			setActionBarHeight(0)
		end
	end, {})

	return React.createElement(View, {
		tag = "row size-full-0 auto-y bg-surface-0 stroke-muted stroke-standard position-bottom-left anchor-bottom-left align-y-center gap-small align-x-center padding-top-large padding-bottom-medium padding-x-large",
		ZIndex = 2,
		onAbsoluteSizeChanged = function(p2) -- line: 45
			-- upvalues: setActionBarHeight (copy)
			setActionBarHeight(p2.AbsoluteSize.Y)
		end,
		testId = if not testId then nil else `{ testId }--actions`,
		onActivated = function() -- line: 50
		end,
		selection = {
			Selectable = false
		},
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		ref = p1
	}, t1.children)
end

return React.memo(React.forwardRef(DetailsPageLayoutActions))
