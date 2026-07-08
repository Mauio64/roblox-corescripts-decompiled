local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local PreferencesContext = require(scriptParent.PreferencesContext)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	preferredTransparency = 1,
	reducedMotion = false,
	scale = 1,
	preferredTextSize = Enum.PreferredTextSize.Medium
}

local function PreferencesProvider(p1) -- line: 30
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), PreferencesContext (copy)
	local v10 = withDefaults({
		preferredTextSize = p1.preferredTextSize,
		preferredTransparency = p1.preferredTransparency,
		reducedMotion = p1.reducedMotion
	}, t1)

	return React.createElement(PreferencesContext.Provider, {
		value = v10
	}, p1.children)
end

return PreferencesProvider
