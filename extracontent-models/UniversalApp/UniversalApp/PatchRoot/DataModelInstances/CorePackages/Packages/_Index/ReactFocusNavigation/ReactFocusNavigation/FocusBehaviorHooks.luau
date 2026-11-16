local parent = script.Parent.Parent
require(parent.FocusNavigation)
local FocusBehaviors = require(parent.FocusBehaviors)
local React = require(parent.React)

local default = FocusBehaviors.default
local mostRecent = FocusBehaviors.mostRecent
local mostRecentOrDefault = FocusBehaviors.mostRecentOrDefault

local useContainerFocusBehavior = require(script.Parent.useContainerFocusBehavior)
local FocusBehaviorHooks = {}

function FocusBehaviorHooks.useDefaultFocusBehavior(p)
	local state, setState = React.useState(nil)

	return setState, (useContainerFocusBehavior(React.useMemo(function()
		return default(state)
	end, { state }), p))
end

function FocusBehaviorHooks.useMostRecentFocusBehavior(p)
	return useContainerFocusBehavior(React.useMemo(mostRecent, {}), p)
end

function FocusBehaviorHooks.useMostRecentOrDefaultFocusBehavior(p)
	local state, setState = React.useState(nil)

	return setState, (useContainerFocusBehavior(React.useMemo(function()
		return mostRecentOrDefault(state)
	end, { state }), p))
end

return FocusBehaviorHooks
