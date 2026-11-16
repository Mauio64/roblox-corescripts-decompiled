local parent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local parent2 = Foundation.Parent
local React = require(parent2.React)

local PreferencesContext = require(parent.PreferencesContext)

local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	preferredTextSize = Enum.PreferredTextSize.Medium,
	preferredTransparency = 1,
	reducedMotion = false,
	scale = 1
}

local function PreferencesProvider(props)
	local v2 = React.useMemo(function()
		return withDefaults(
			{
				preferredTextSize = props.preferredTextSize,
				preferredTransparency = props.preferredTransparency,
				reducedMotion = props.reducedMotion
			},
			v
		)
	end, { props.preferredTextSize, props.preferredTransparency, props.reducedMotion })

	return React.createElement(PreferencesContext.Provider, { value = v2 }, props.children)
end

return PreferencesProvider
