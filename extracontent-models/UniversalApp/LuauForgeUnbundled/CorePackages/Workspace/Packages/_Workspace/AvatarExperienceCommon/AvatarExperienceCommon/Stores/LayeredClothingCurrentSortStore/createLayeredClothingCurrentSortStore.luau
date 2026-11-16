local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsExperimental")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsUtils").createSessionScopedSignal

local function createEmptyOrderedList()
	return {}
end

local function createEmptyRemovedList()
	return {}
end

local function alwaysNotifyEquals(p2, p3): boolean
	return false
end

local function createLayeredClothingCurrentSortStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(createEmptyOrderedList, alwaysNotifyEquals)
	local sessionScopedSignal2, v6 = createSessionScopedSignal(createEmptyRemovedList)

	return {
		getOrderedList = sessionScopedSignal,
		getRemovedList = sessionScopedSignal2,
		setCurrentSort = function(p2)
			if p2 == nil then
				return
			end

			v5(p2)
		end,
		clearCurrentSort = function()
			SignalsExperimental.batch(function()
				v5({})
				v6({})
			end)
		end,
		addRemovedItem = function(p2, p3)
			local v7 = sessionScopedSignal2(false) or {}
			v6(Cryo.Dictionary.join(v7, { [p2] = p3 }))
		end,
		clearRemovedItems = function()
			v6({})
		end,
		reset = function()
			SignalsExperimental.batch(function()
				v5({})
				v6({})
			end)
		end
	}
end

return createLayeredClothingCurrentSortStore
