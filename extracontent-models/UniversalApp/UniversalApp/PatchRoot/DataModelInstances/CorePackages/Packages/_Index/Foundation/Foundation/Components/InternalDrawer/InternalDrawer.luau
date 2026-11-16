local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local ScrollBarVisibility = require(Foundation.Enums.ScrollBarVisibility)
local withDefaults = require(Foundation.Utility.withDefaults)

local InternalDrawerOverlay = require(script.Parent.InternalDrawerOverlay)
require(script.Parent.Types)

local v = {
	outerBleed = 0,
	scrolls = true,
	scrollBarVisibility = ScrollBarVisibility.None,
	testId = "--foundation-internal-drawer"
}

local function InternalDrawer(p, ref)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(v2.isOpen)

	if v2.isOpen and not state then
		setState(true)
	end

	local onCloseComplete = v2.onCloseComplete
	local onExited = React.useCallback(function()
		setState(false)

		if onCloseComplete then
			onCloseComplete()
		end
	end, { onCloseComplete })

	if not state then
		return nil
	end

	v2.ref = ref
	v2.onExited = onExited

	return React.createElement(InternalDrawerOverlay, v2)
end

return React.memo(React.forwardRef(InternalDrawer))
