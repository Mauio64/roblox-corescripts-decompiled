local parent = script:FindFirstAncestor("Foundation").Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local None = Dash.None

local context = React.createContext(None)

return {
	Provider = context.Provider,
	useStyleSheet = function()
		local v = React.useContext(context)
		return if v ~= None then v else nil
	end
}
