local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local AppShortcutBarParent = AppShortcutBar.Parent
local React = require(AppShortcutBarParent.React)

require(AppShortcutBarParent.FocusNavigationUtils)

local v4 = require(AppShortcutBar.Stores.GetButtonHoldStore)(false)
local t1 = {
	ButtonHoldStarted = "ButtonHoldStarted",
	ButtonHoldEnded = "ButtonHoldEnded"
}
local t6 = {
	[t1.ButtonHoldStarted] = function(t2: {[any]: any}, t3: {[any]: any}) -- line: 38
		local v12 = table.clone(t2)

		v12.heldProgress[t3.eventName] = t3.progress

		return v12
	end,
	[t1.ButtonHoldEnded] = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 43
		local v15 = table.clone(t4)

		v15.heldProgress[t5.eventName] = nil

		return v15
	end
}

local function registryReducer(t7: {[any]: any}, p1) -- line: 50
	-- upvalues: t6 (copy)
	local v18 = t6[p1.type]

	if v18 then
		return v18(t7, p1.payload)
	end

	error("Unknown action: " .. p1.type)
end

local v8 = React.createContext(nil)

local function AppShortcutBarStateProvider(t8: {[any]: any}) -- line: 60
	-- upvalues: React (copy), registryReducer (copy), v8 (copy)
	local v20, v21 = React.useReducer(registryReducer, {
		heldProgress = {}
	})

	return React.createElement(v8.Provider, {
		value = {
			state = v20,
			dispatch = v21
		}
	}, t8.children)
end

return {
	Context = v8,
	Provider = AppShortcutBarStateProvider,
	useDispatchButtonHoldStarted = v4.useDispatchButtonHoldStarted,
	useDispatchButtonHoldEnded = v4.useDispatchButtonHoldEnded,
	useHeldProgressByEvent = v4.useHeldProgressByEvent,
	AppShortcutBarStateActionEnum = t1
}
