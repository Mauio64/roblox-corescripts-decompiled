local scriptParent = script.Parent
local Parent = script:FindFirstAncestor("Foundation").Parent
local PreferencesContext = require(scriptParent.PreferencesContext)
local React = require(Parent.React)

local function usePreferences() -- line: 9
	-- upvalues: React (copy), PreferencesContext (copy)
	return (React.useContext(PreferencesContext))
end

return usePreferences
