local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local ResponsiveLayoutContext = require(scriptParent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(scriptParent.ResponsiveLayoutConfigReader)

return function(s1: string, s2: string?) -- line: 19
	-- upvalues: React (copy), ResponsiveLayoutContext (copy), ResponsiveLayoutConfigReader (copy)
	local v8 = React.useContext(ResponsiveLayoutContext)

	return ResponsiveLayoutConfigReader.getValue({
		config = v8.config,
		breakpoint = v8.breakpoint,
		kind = s2 or v8.kind
	}, s1)
end
