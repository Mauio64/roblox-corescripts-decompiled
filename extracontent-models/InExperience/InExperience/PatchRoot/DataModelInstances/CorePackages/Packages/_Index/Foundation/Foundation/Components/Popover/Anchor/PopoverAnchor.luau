local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local PopoverContext = require(script.Parent.Parent.PopoverContext)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local React = require(parent.React)

local function PopoverAnchor(state, p)
	local v = React.useContext(PopoverContext)

	local ref = React.useRef(nil)

	React.useImperativeHandle(p, function()
		return ref.current
	end, {})

	React.useLayoutEffect(function()
		if StudioUri.isStudioUri(state.anchorRef) then
			v.setAnchorUri(state.anchorRef)
		elseif typeof(state.anchorRef) == "table" and state.anchorRef.current then
			v.setAnchor(state.anchorRef.current)
		else
			v.setAnchor(ref.current)
		end
	end)

	if state.anchorRef then
		return nil
	end

	state.testId = `{v.testId}--anchor`

	return React.createElement(View, withCommonProps(state, { tag = "auto-xy", ref = ref }), state.children)
end

return React.forwardRef(PopoverAnchor)
