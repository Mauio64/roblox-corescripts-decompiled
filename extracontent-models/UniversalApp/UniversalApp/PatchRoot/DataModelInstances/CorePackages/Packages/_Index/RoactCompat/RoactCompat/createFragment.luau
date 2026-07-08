local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local React = require(ParentParent.React)
local warnOnce = require(script.Parent.warnOnce)

return function(p1) -- line: 22
	-- upvalues: ReactGlobals (copy), warnOnce (copy), React (copy)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("createFragment", "Please instead use:\n\tReact.createElement(React.Fragment, ...)")
	end

	return React.createElement(React.Fragment, nil, p1)
end
