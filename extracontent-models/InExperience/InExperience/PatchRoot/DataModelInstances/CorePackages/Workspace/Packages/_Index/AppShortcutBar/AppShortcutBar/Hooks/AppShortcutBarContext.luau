local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local React = require(parent.React)
require(parent.FocusNavigationUtils)

local GetButtonHoldStore = require(AppShortcutBar.Stores.GetButtonHoldStore)
local buttonHoldStore = GetButtonHoldStore(false)

local appShortcutBarStateActionEnum = {
	ButtonHoldStarted = "ButtonHoldStarted",
	ButtonHoldEnded = "ButtonHoldEnded"
}

local v = {
	[appShortcutBarStateActionEnum.ButtonHoldStarted] = function(p, p2)
		local clone = table.clone(p)
		clone.heldProgress[p2.eventName] = p2.progress
		return clone
	end,
	[appShortcutBarStateActionEnum.ButtonHoldEnded] = function(p, p2)
		local clone = table.clone(p)
		clone.heldProgress[p2.eventName] = nil
		return clone
	end
}

local function registryReducer(p, p2)
	local v2 = v[p2.type]

	if v2 then
		return v2(p, p2.payload)
	end

	error("Unknown action: " .. p2.type)
end

local context = React.createContext(nil)
local function AppShortcutBarStateProvider(p)
	local state, dispatch = React.useReducer(registryReducer, { heldProgress = {} })
	return React.createElement(context.Provider, {
		value = { state = state, dispatch = dispatch }
	}, p.children)
end

return {
	Context = context,
	Provider = AppShortcutBarStateProvider,
	useDispatchButtonHoldStarted = buttonHoldStore.useDispatchButtonHoldStarted,
	useDispatchButtonHoldEnded = buttonHoldStore.useDispatchButtonHoldEnded,
	useHeldProgressByEvent = buttonHoldStore.useHeldProgressByEvent,
	AppShortcutBarStateActionEnum = appShortcutBarStateActionEnum
}
