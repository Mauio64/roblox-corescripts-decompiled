local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Navigation")

local OnScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/OnScreenStore")
local routeIdentity = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/routeIdentity")

local getRouteKeyIsInNavigationState = Navigation.getRouteKeyIsInNavigationState

local function createNavigationHandle(signal, value, fn)
	local v5 = if type(value) == "string" then value else nil
	local signal2, v6 = Signals.createSignal(v5)

	if type(value) ~= "function" then
		value = nil
	end

	local computed = Signals.createComputed(function(p2)
		local v7 = signal2(p2)
		local v8 = signal(p2)
		return v7 ~= nil and v8 ~= nil and getRouteKeyIsInNavigationState(v7, v8)
	end)

	local computed2 = Signals.createComputed(function(p2): boolean
		local v7 = signal2(p2)
		local v8 = signal(p2)

		if v7 == nil or v8 == nil then
			return false
		end

		local routeOnScreen = OnScreenStore.getRouteOnScreen(p2, v7)

		if routeOnScreen == nil then
			return routeIdentity.findOnFocusedPath(v8, function(p3): boolean
				return p3.key == v7
			end) ~= nil
		end

		return routeOnScreen.isOnScreen == true
	end)

	local signal3, v7 = Signals.createSignal(false)
	local computed3 = Signals.createComputed(function(p2)
		return signal3(p2) and not computed(p2)
	end)

	local v8 = {}
	local flag = false
	local function destroy()
		if flag then
			return
		end

		flag = true

		for k, v9 in v8 do
			v9()
		end

		if fn ~= nil then
			fn()
		end
	end

	local navigationHandle = {
		key = v5,
		isOpen = function(p2)
			return not flag and computed(p2)
		end,
		isFocused = function(p2)
			return not flag and computed2(p2)
		end,
		onClosed = function(callback)
			if computed3(false) then
				callback()
				return function() end
			end

			if flag then
				return function() end
			end

			local v9 = nil
			v9 = Signals.createEffect(function(p2)
				if computed3(p2) then
					callback()
					task.defer(function()
						v9()
					end)
				end
			end)
			table.insert(v8, v9)
			return v9
		end,
		onFocusChanged = function(callback)
			if flag then
				return function() end
			end

			local v9 = computed2(false)
			local effect = Signals.createEffect(function(p2)
				local v10 = computed2(p2)

				if v10 ~= v9 then
					v9 = v10
					callback(v10)
				end
			end)
			table.insert(v8, effect)
			return effect
		end,
		destroy = destroy
	}

	if value ~= nil then
		local v9 = nil
		v9 = Signals.createEffect(function(p2)
			if signal2(false) ~= nil then
				return
			end

			local v10 = routeIdentity.findOnFocusedPath(signal(p2), value)

			if v10 ~= nil then
				v6(v10.key)
				navigationHandle.key = v10.key
				task.defer(function()
					v9()
				end)
			end
		end)
		table.insert(v8, v9)
	end

	table.insert(v8, Signals.createEffect(function(p2)
		if computed(p2) then
			v7(true)
		end
	end))

	table.insert(v8, Signals.createEffect(function(p2)
		if computed3(p2) then
			task.defer(destroy)
		end
	end))

	return navigationHandle
end

return {
	new = createNavigationHandle,
	fromRoduxStore = function(object, p2)
		local function read()
			local navigation = object:getState().Navigation

			if navigation then
				return navigation.roactNavigationState
			end

			return nil
		end

		local createSignal = Signals.createSignal
		local navigation = object:getState().Navigation
		local v5 = if navigation then navigation.roactNavigationState else nil

		local signal, v6 = createSignal(v5)
		local changedConnection

		if object.changed == nil then
			changedConnection = nil
		else
			changedConnection = object.changed:connect(function()
				local navigation2 = object:getState().Navigation
				local v8 = if navigation2 then navigation2.roactNavigationState else nil

				v6(v8)
			end)
		end

		return createNavigationHandle(signal, p2, function()
			if changedConnection ~= nil then
				changedConnection:disconnect()
			end
		end)
	end
}
