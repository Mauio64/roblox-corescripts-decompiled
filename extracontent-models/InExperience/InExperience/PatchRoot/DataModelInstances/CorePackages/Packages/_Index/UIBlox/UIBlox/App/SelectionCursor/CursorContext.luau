local parent = script.Parent.Parent.Parent.Parent
local React = require(parent.React)

return (React.createContext({
	getCursor = function(): nil
		return nil
	end,
	getCursorByType = function(): nil
		return nil
	end
}))
