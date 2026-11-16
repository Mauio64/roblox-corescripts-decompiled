local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local React = require(parent.React)

local warnOnce = require(script.Parent.warnOnce)

return function(p)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("createFragment", "Please instead use:\n\tReact.createElement(React.Fragment, ...)")
	end

	return React.createElement(React.Fragment, nil, p)
end
