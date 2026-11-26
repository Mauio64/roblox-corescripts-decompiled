local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/FocusNavigationUtils")

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Stores/GetButtonHoldStore")(false)

local v6 = {
	ButtonHoldStarted = "ButtonHoldStarted",
	ButtonHoldEnded = "ButtonHoldEnded"
}

local v7 = {
	[v6.ButtonHoldStarted] = function(p2, p3)
		local clone = table.clone(p2)
		clone.heldProgress[p3.eventName] = p3.progress
		return clone
	end,
	[v6.ButtonHoldEnded] = function(p2, p3)
		local clone = table.clone(p2)
		clone.heldProgress[p3.eventName] = nil
		return clone
	end
}

local function registryReducer(p2, p3)
	local v8 = v7[p3.type]

	if v8 then
		return v8(p2, p3.payload)
	end

	error("Unknown action: " .. p3.type)
end

local context = React.createContext(nil)
local function AppShortcutBarStateProvider(p2)
	local v8, v9 = React.useReducer(registryReducer, { heldProgress = {} })
	return React.createElement(context.Provider, {
		value = { state = v8, dispatch = v9 }
	}, p2.children)
end

return {
	Context = context,
	Provider = AppShortcutBarStateProvider,
	useDispatchButtonHoldStarted = v5.useDispatchButtonHoldStarted,
	useDispatchButtonHoldEnded = v5.useDispatchButtonHoldEnded,
	useHeldProgressByEvent = v5.useHeldProgressByEvent,
	AppShortcutBarStateActionEnum = v6
}
