local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local DataStructures = require(AppChat.DataStructures)
local ArraySet = DataStructures.ArraySet

local function createSelectedUsersStore()
	local signal, v = Signals.createSignal(0)

	local signal2, v2 = Signals.createSignal(ArraySet.new({}))

	local computed = Signals.createComputed(function(p): boolean
		local v3 = signal2(p)
		return signal(p) > v3:size()
	end)

	local computed2 = Signals.createComputed(function(p)
		return signal2(p):size()
	end)

	local computed3 = Signals.createComputed(function(p)
		return signal2(p):toArray()
	end)

	local v3 = Signal.new()

	local v4 = {}

	local v5 = {}

	local function emitMaxSizeExceeded() -- 1 equivalent call inferred from this helper
		v3:fire()
	end

	local function addUserId(p: string): boolean
		if signal2(false):has(p) then
			return true
		end

		if computed(false) then
			v2(function(object)
				local clone = object:clone()
				clone:add(p)
				return clone
			end)

			return true
		end

		emitMaxSizeExceeded() -- inferred equivalent call
		return false
	end

	return {
		setMaxSize = function(p: number)
			v(function(_)
				return p
			end)
		end,
		getSelectedUserIdsCount = function()
			return computed2
		end,
		getSelectedUserIdAtIndex = function(p: number)
			if not v4[p] then
				v4[p] = Signals.createComputed(function(p2)
					return signal2(p2):at(p)
				end)
			end

			return v4[p]
		end,
		getIsUserSelected = function(p: string)
			if not v5[p] then
				v5[p] = Signals.createComputed(function(p2)
					return signal2(p2):has(p)
				end)
			end

			return v5[p]
		end,
		getMaxSize = function()
			return signal
		end,
		getSelectedUserIdsArray = function()
			return computed3
		end,
		addUserId = addUserId,
		removeUserId = function(p: string)
			v2(function(object)
				if not object:has(p) then
					return object
				end

				local clone = object:clone()
				clone:remove(p)
				return clone
			end)
		end,
		toggleUserId = function(p: string)
			if not signal2(false):has(p) then
				return addUserId(p)
			end

			v2(function(object)
				if not object:has(p) then
					return object
				end

				local clone = object:clone()
				clone:remove(p)
				return clone
			end)

			return true
		end,
		clearStore = function()
			v3 = Signal.new()
			v4 = {}
			v5 = {}
			v2(function(_)
				return ArraySet.new({})
			end)
		end,
		onMaxSizeExceeded = function(callback)
			local connection = v3:connect(callback)

			return function()
				connection:disconnect()
			end
		end,
		hasUserId = function(p: string)
			return signal2(false):has(p)
		end,
		getCount = function()
			return signal2(false):size()
		end
	}
end

return createSelectedUsersStore
