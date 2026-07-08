local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Flags = require(Foundation.Utility.Flags)
local PopoverContext = require(script.Parent.Parent.PopoverContext)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local React = require(FoundationParent.React)

local function PopoverAnchor(p1, p2) -- line: 22
	-- upvalues: React (copy), PopoverContext (copy), Flags (copy), StudioUri (copy), View (copy), withCommonProps (copy)
	local v12 = React.useContext(PopoverContext)
	local v13 = React.useRef(nil)

	React.useImperativeHandle(p2, function() -- line: 27
		-- upvalues: v13 (copy)
		return v13.current
	end, {})
	React.useLayoutEffect(function() -- line: 31
		-- upvalues: Flags (copy), StudioUri (copy), p1 (copy), v12 (copy), v13 (copy)
		if Flags.FoundationPopoverPluginUriAnchor and StudioUri.isStudioUri(p1.anchorRef) then
			v12.setAnchorUri(p1.anchorRef)

			return
		end

		if typeof(p1.anchorRef) == "table" and p1.anchorRef.current then
			v12.setAnchor(p1.anchorRef.current)

			return
		end

		v12.setAnchor(v13.current)
	end)

	if p1.anchorRef then
		return nil
	end

	p1.testId = `{ v12.testId }--anchor`

	return React.createElement(View, withCommonProps(p1, {
		tag = "auto-xy",
		ref = v13
	}), p1.children)
end

return React.forwardRef(PopoverAnchor)
