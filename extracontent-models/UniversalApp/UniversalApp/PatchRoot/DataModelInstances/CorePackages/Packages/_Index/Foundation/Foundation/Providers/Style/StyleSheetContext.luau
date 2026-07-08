local Parent = script:FindFirstAncestor("Foundation").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local None = Dash.None
local v5 = React.createContext(None)

return {
	Provider = v5.Provider,
	useStyleSheet = function() -- line: 11
		-- upvalues: React (copy), v5 (copy), None (copy)
		local v6 = React.useContext(v5)

		if v6 == None then
			return nil
		end

		return v6
	end
}
