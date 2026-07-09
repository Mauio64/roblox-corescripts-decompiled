local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local KeybindContext = require(ParentParent.Context.KeybindContext)

return function() -- line: 11
	-- upvalues: React (copy), KeybindContext (copy)
	return React.useContext(KeybindContext)
end
