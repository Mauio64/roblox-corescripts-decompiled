local MemStorageService = game:GetService("MemStorageService")

local experienceService = require("@luauforge/bundled/bXj").ExperienceService
local pioneerLeaveReason = require("@luauforge/bundled/fDJ").PioneerLeaveReason
local fFlagPioneerLeaveOnInExpFaeDownAge = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPioneerLeaveOnInExpFaeDownAge

local module = require("@luauforge/bundled/fTw")
local module2 = require("@luauforge/bundled/fBr")
local module3 = require("@luauforge/bundled/fyV")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module5 = require("@luauforge/bundled/fTx")

local v5 = {}

local v6 = false

local blockedReason = nil
local v7 = {}

local v8 = false
local v9 = {}

local function armDarkThemeOverride()
	MemStorageService:Fire(module2.ThemeUpdate, "dark")
	module3.SetDarkThemeOverride()
end

local function consumeJoinBlocked()
	if not fFlagPioneerLeaveOnInExpFaeDownAge then
		return
	end

	local v10 = experienceService:ConsumePendingExperienceLeaveWithReason()

	if not v10 or v10.reason ~= pioneerLeaveReason.AccountUnder13 then
		return
	end

	local reason = v10.reason
	v6 = true
	blockedReason = reason

	for k, callback in table.clone(v7) do
		xpcall(callback, function(p2)
			warn("PioneerPostAuthExperienceLifecycle blocked listener failed: " .. tostring(p2))
		end, reason)
	end
end

function v5.getBlockedReason()
	return blockedReason
end

function v5.onBlocked(p2)
	table.insert(v7, p2)

	return function()
		local index = table.find(v7, p2)

		if index then
			table.remove(v7, index)
		end
	end
end

function v5.hasKickedOffJoin()
	return v6
end

function v5.markJoinKickedOff()
	v6 = true
	v8 = false
end

function v5.clearJoinKickedOff()
	v6 = false
end

function v5.isRejoinPending()
	return v8
end

function v5.restoreRejoinPending()
	v8 = true
end

function v5.onRejoinPending(p2)
	table.insert(v9, p2)

	return function()
		local index = table.find(v9, p2)

		if index then
			table.remove(v9, index)
		end
	end
end

local function requestRejoin()
	if blockedReason ~= nil then
		return
	end

	v8 = true

	for k, callback in table.clone(v9) do
		xpcall(callback, function(p2)
			warn("PioneerPostAuthExperienceLifecycle rejoin listener failed: " .. tostring(p2))
		end)
	end
end

function v5.onMount()
	MemStorageService:Fire(module2.ThemeUpdate, "dark")
	module3.SetDarkThemeOverride()

	consumeJoinBlocked()
end

function v5.onExperienceJoin(p2)
	module5(p2, Models.fromLocalStorage().userId)
end

function v5.onExperienceLeave()
	MemStorageService:Fire(module2.ThemeUpdate, "dark")
	module3.SetDarkThemeOverride()

	consumeJoinBlocked()

	if module then
		requestRejoin()
	end
end

function v5.connect(p2)
	local connection = experienceService:RegisterForExperienceJoin(function()
		v5.onExperienceJoin(p2)
	end)
	local connection2 = experienceService:RegisterForExperienceLeave(function()
		v5.onExperienceLeave()
	end)

	return function()
		if connection then
			connection:Disconnect()
		end

		if connection2 then
			connection2:Disconnect()
		end
	end
end

return v5
