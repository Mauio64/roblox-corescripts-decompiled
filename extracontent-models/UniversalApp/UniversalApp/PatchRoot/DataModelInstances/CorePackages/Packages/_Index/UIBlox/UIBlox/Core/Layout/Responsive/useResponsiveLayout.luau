local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local React = require(parent2.React)

local ResponsiveLayoutContext = require(parent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(parent.ResponsiveLayoutConfigReader)

return function(p: string, p2: string?)
	local v = React.useContext(ResponsiveLayoutContext)
	return ResponsiveLayoutConfigReader.getValue({
		config = v.config,
		breakpoint = v.breakpoint,
		kind = p2 or v.kind
	}, p)
end
