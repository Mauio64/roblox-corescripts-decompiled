local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Cryo = require(parent.Cryo)
require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local function createEmptyOrderedList()
	return {}
end

local function createEmptyRemovedList()
	return {}
end

local function alwaysNotifyEquals(_, _): boolean
	return false
end

local function createLayeredClothingCurrentSortStore()
	local sessionScopedSignal, v = createSessionScopedSignal(createEmptyOrderedList, alwaysNotifyEquals)
	local sessionScopedSignal2, v2 = createSessionScopedSignal(createEmptyRemovedList)

	return {
		getOrderedList = sessionScopedSignal,
		getRemovedList = sessionScopedSignal2,
		setCurrentSort = function(p)
			if p == nil then
				return
			end

			v(p)
		end,
		clearCurrentSort = function()
			SignalsExperimental.batch(function()
				v({})
				v2({})
			end)
		end,
		addRemovedItem = function(p: string, p2: string?)
			local v3 = sessionScopedSignal2(false) or {}
			v2(Cryo.Dictionary.join(v3, { [p] = p2 }))
		end,
		clearRemovedItems = function()
			v2({})
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v({})
				v2({})
			end)
		end
	}
end

return createLayeredClothingCurrentSortStore
