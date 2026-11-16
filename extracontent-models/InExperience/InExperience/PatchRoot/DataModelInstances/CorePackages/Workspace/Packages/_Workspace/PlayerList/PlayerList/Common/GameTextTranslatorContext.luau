local parent = script.Parent.Parent.Parent
local React = require(parent.React)

return (React.createContext(function(p: string)
	return p
end))
