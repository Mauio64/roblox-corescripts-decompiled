local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal

local arraySet = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/DataStructures").ArraySet

local function createSelectedUsersStore()
	local signal2, v5 = Signals.createSignal(0)

	local signal3, v6 = Signals.createSignal(arraySet.new({}))

	local computed = Signals.createComputed(function(p2): boolean
		local v7 = signal3(p2)
		return signal2(p2) > v7:size()
	end)

	local computed2 = Signals.createComputed(function(p2)
		return signal3(p2):size()
	end)

	local computed3 = Signals.createComputed(function(p2)
		return signal3(p2):toArray()
	end)

	local v7 = signal.new()

	local v8 = {}

	local v9 = {}

	local function emitMaxSizeExceeded()
		v7:fire()
	end

	local function addUserId(p2): boolean
		if signal3(false):has(p2) then
			return true
		end

		if computed(false) then
			v6(function(object)
				local clone = object:clone()
				clone:add(p2)
				return clone
			end)

			return true
		end

		v7:fire()

		return false
	end

	return {
		setMaxSize = function(p2)
			v5(function(p3)
				return p2
			end)
		end,
		getSelectedUserIdsCount = function()
			return computed2
		end,
		getSelectedUserIdAtIndex = function(p2)
			if not v8[p2] then
				v8[p2] = Signals.createComputed(function(p3)
					return signal3(p3):at(p2)
				end)
			end

			return v8[p2]
		end,
		getIsUserSelected = function(p2)
			if not v9[p2] then
				v9[p2] = Signals.createComputed(function(p3)
					return signal3(p3):has(p2)
				end)
			end

			return v9[p2]
		end,
		getMaxSize = function()
			return signal2
		end,
		getSelectedUserIdsArray = function()
			return computed3
		end,
		addUserId = addUserId,
		removeUserId = function(p2)
			v6(function(object)
				if not object:has(p2) then
					return object
				end

				local clone = object:clone()
				clone:remove(p2)
				return clone
			end)
		end,
		toggleUserId = function(p2)
			if not signal3(false):has(p2) then
				return addUserId(p2)
			end

			v6(function(object)
				if not object:has(p2) then
					return object
				end

				local clone = object:clone()
				clone:remove(p2)
				return clone
			end)

			return true
		end,
		clearStore = function()
			v7 = signal.new()
			v8 = {}
			v9 = {}
			v6(function(p2)
				return arraySet.new({})
			end)
		end,
		onMaxSizeExceeded = function(p2)
			local connection = v7:connect(p2)

			return function()
				connection:disconnect()
			end
		end,
		hasUserId = function(p2)
			return signal3(false):has(p2)
		end,
		getCount = function()
			return signal3(false):size()
		end
	}
end

return createSelectedUsersStore
