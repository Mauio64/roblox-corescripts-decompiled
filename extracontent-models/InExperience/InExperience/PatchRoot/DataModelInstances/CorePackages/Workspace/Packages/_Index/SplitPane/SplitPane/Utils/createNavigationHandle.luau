local parent = script:FindFirstAncestor("SplitPane").Parent

local Signals = require(parent.Signals)
local Navigation = require(parent.Navigation)

local OnScreenStore = require(script.Parent.Parent.Stores.OnScreenStore)
local routeIdentity = require(script.Parent.routeIdentity)

local getRouteKeyIsInNavigationState = Navigation.getRouteKeyIsInNavigationState

local function createNavigationHandle(signal, value, fn)
	local v

	if type(value) == "string" then
		v = value
	end

	local signal2, v2 = Signals.createSignal(v)

	if type(value) ~= "function" then
		value = nil
	end

	local computed = Signals.createComputed(function(p)
		local v3 = signal2(p)
		local v4 = signal(p)
		return v3 ~= nil and v4 ~= nil and getRouteKeyIsInNavigationState(v3, v4)
	end)

	local computed2 = Signals.createComputed(function(p): boolean
		local v3 = signal2(p)
		local v4 = signal(p)

		if v3 == nil or v4 == nil then
			return false
		end

		local routeOnScreen = OnScreenStore.getRouteOnScreen(p, v3)

		if routeOnScreen == nil then
			return routeIdentity.findOnFocusedPath(v4, function(p2): boolean
				return p2.key == v3
			end) ~= nil
		end

		return routeOnScreen.isOnScreen == true
	end)

	local signal3, v3 = Signals.createSignal(false)
	local computed3 = Signals.createComputed(function(p)
		return signal3(p) and not computed(p)
	end)

	local v4 = {}
	local flag = false
	local function destroy()
		if flag then
			return
		end

		flag = true

		for _, v5 in v4 do
			v5()
		end

		if fn ~= nil then
			fn()
		end
	end

	local navigationHandle = {
		key = v,
		isOpen = function(p)
			return not flag and computed(p)
		end,
		isFocused = function(p)
			return not flag and computed2(p)
		end,
		onClosed = function(callback)
			if computed3(false) then
				callback()
				return function() end
			end

			if flag then
				return function() end
			end

			local v5 = nil
			v5 = Signals.createEffect(function(p)
				if computed3(p) then
					callback()
					task.defer(function()
						v5()
					end)
				end
			end)
			table.insert(v4, v5)
			return v5
		end,
		onFocusChanged = function(callback)
			if flag then
				return function() end
			end

			local v5 = computed2(false)
			local effect = Signals.createEffect(function(p)
				local v6 = computed2(p)

				if v6 ~= v5 then
					v5 = v6
					callback(v6)
				end
			end)
			table.insert(v4, effect)
			return effect
		end,
		destroy = destroy
	}

	if value ~= nil then
		local v5 = nil
		v5 = Signals.createEffect(function(p)
			if signal2(false) ~= nil then
				return
			end

			local v6 = routeIdentity.findOnFocusedPath(signal(p), value)

			if v6 ~= nil then
				v2(v6.key)
				navigationHandle.key = v6.key
				task.defer(function()
					v5()
				end)
			end
		end)
		table.insert(v4, v5)
	end

	table.insert(v4, Signals.createEffect(function(p)
		if computed(p) then
			v3(true)
		end
	end))

	table.insert(v4, Signals.createEffect(function(p)
		if computed3(p) then
			task.defer(destroy)
		end
	end))

	return navigationHandle
end

return {
	new = createNavigationHandle,
	fromRoduxStore = function(object, p)
		local function read() -- 2 equivalent calls inferred from this helper
			local navigation = object:getState().Navigation

			if navigation then
				return navigation.roactNavigationState
			end

			return nil
		end

		local signal, v = Signals.createSignal(read()) -- inferred equivalent call
		local changedConnection

		if object.changed == nil then
			changedConnection = nil
		else
			changedConnection = object.changed:connect(function()
				v(read()) -- inferred equivalent call
			end)
		end

		return createNavigationHandle(signal, p, function()
			if changedConnection ~= nil then
				changedConnection:disconnect()
			end
		end)
	end
}
