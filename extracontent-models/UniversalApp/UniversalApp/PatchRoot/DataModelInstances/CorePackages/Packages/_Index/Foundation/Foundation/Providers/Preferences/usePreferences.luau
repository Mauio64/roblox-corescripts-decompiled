local parent = script.Parent
local parent2 = script:FindFirstAncestor("Foundation").Parent

local PreferencesContext = require(parent.PreferencesContext)

local React = require(parent2.React)

local function usePreferences()
	return (React.useContext(PreferencesContext))
end

return usePreferences
