local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local ResponsiveLayoutContext = require(scriptParent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(scriptParent.ResponsiveLayoutConfigReader)

local function ResponsiveLayoutProvider(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), ResponsiveLayoutConfigReader (copy), ResponsiveLayoutContext (copy)
	local v8 = t1.width or 1
	local v9 = t1.config or {}
	local v10, v11 = React.useState(function() -- line: 22
		-- upvalues: ResponsiveLayoutConfigReader (copy), v9 (copy), v8 (copy)
		return ResponsiveLayoutConfigReader.findBreakpoint(v9, v8)
	end)

	React.useLayoutEffect(function() -- line: 26
		-- upvalues: v11 (copy), ResponsiveLayoutConfigReader (copy), v9 (copy), v8 (copy)
		v11(ResponsiveLayoutConfigReader.findBreakpoint(v9, v8))
	end, { v9 })
	React.useLayoutEffect(function() -- line: 30
		-- upvalues: v10 (copy), v8 (copy), v11 (copy), ResponsiveLayoutConfigReader (copy), v9 (copy)
		if v10.min > v8 or v8 > v10.max then
			v11(ResponsiveLayoutConfigReader.findBreakpoint(v9, v8))
		end
	end, {
		v8,
		v10.min,
		v10.max
	})

	return React.createElement(ResponsiveLayoutContext.Provider, {
		value = {
			config = v9,
			breakpoint = v10.name
		}
	}, t1.children)
end

return ResponsiveLayoutProvider
