local MemStorageService = game:GetService("MemStorageService")

local experienceService = require("@luauforge/bundled/bZg").ExperienceService
local pioneerLeaveReason = require("@luauforge/bundled/gid").PioneerLeaveReason
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagPioneerLeaveOnInExpFaeDownAge = SharedFlags.FFlagPioneerLeaveOnInExpFaeDownAge
local fFlagPioneerLeaveLogsOut = SharedFlags.FFlagPioneerLeaveLogsOut

local module2 = require("@luauforge/bundled/gvj")
local module3 = require("@luauforge/bundled/gfK")
local module4 = require("@luauforge/bundled/fGL")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module6 = require("@luauforge/bundled/gvk")

local v5 = {}

local v6 = false

local blockedReason = nil
local v7 = {}

local v8 = false
local v9 = {}

local v10 = "None"
local v11 = {}

local function armDarkThemeOverride()
	MemStorageService:Fire(module3.ThemeUpdate, "dark")
	module4.SetDarkThemeOverride()
end

local function blockJoin(reason)
	v6 = true
	blockedReason = reason

	for k, callback in table.clone(v7) do
		xpcall(callback, function(p2)
			warn("PioneerPostAuthExperienceLifecycle blocked listener failed: " .. tostring(p2))
		end, reason)
	end
end

local function consumeJoinBlocked()
	if not fFlagPioneerLeaveOnInExpFaeDownAge then
		return
	end

	local v12 = experienceService:ConsumePendingExperienceLeaveWithReason()

	if not v12 or v12.reason ~= pioneerLeaveReason.AccountUnder13 then
		return
	end

	blockJoin(v12.reason)
end

local function requestLogout()
	v6 = true
	v10 = "Requested"

	for k, callback in table.clone(v11) do
		xpcall(callback, function(p2)
			warn("PioneerPostAuthExperienceLifecycle logout listener failed: " .. tostring(p2))
		end)
	end
end

local function consumePendingLeave()
	local v12 = experienceService:ConsumePendingExperienceLeaveWithReason()

	if not v12 then
		return
	end

	if v12.reason == pioneerLeaveReason.Logout then
		requestLogout()
	elseif fFlagPioneerLeaveOnInExpFaeDownAge and v12.reason == pioneerLeaveReason.AccountUnder13 then
		blockJoin(v12.reason)
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

function v5.takeLogoutRequest(): boolean
	if v10 ~= "Requested" then
		return false
	end

	v10 = "Dispatched"
	return true
end

function v5.onLandingPageShown()
	if v10 == "Dispatched" then
		v10 = "SignedOut"
	end
end

function v5.onLogoutRequested(p2)
	table.insert(v11, p2)

	return function()
		local index = table.find(v11, p2)

		if index then
			table.remove(v11, index)
		end
	end
end

local function requestRejoin()
	if blockedReason ~= nil or fFlagPioneerLeaveLogsOut and v10 ~= "None" then
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
	MemStorageService:Fire(module3.ThemeUpdate, "dark")
	module4.SetDarkThemeOverride()

	if fFlagPioneerLeaveLogsOut then
		if v10 == "SignedOut" then
			v10 = "None"
			v6 = false
			v8 = false
		end

		local v12 = experienceService:ConsumePendingExperienceLeaveWithReason()

		if not v12 then
			return
		end

		if v12.reason == pioneerLeaveReason.Logout then
			requestLogout()
		elseif fFlagPioneerLeaveOnInExpFaeDownAge and v12.reason == pioneerLeaveReason.AccountUnder13 then
			blockJoin(v12.reason)
		end
	else
		if not fFlagPioneerLeaveOnInExpFaeDownAge then
			return
		end

		local v12 = experienceService:ConsumePendingExperienceLeaveWithReason()

		if v12 then
			if v12.reason ~= pioneerLeaveReason.AccountUnder13 then
				return
			end

			blockJoin(v12.reason)
		end
	end
end

function v5.onExperienceJoin(p2)
	module6(p2, Models.fromLocalStorage().userId)
end

function v5.onExperienceLeave()
	MemStorageService:Fire(module3.ThemeUpdate, "dark")
	module4.SetDarkThemeOverride()

	if fFlagPioneerLeaveLogsOut then
		local v12 = experienceService:ConsumePendingExperienceLeaveWithReason()

		if v12 then
			if v12.reason == pioneerLeaveReason.Logout then
				requestLogout()
			elseif
				fFlagPioneerLeaveOnInExpFaeDownAge
				and v12.reason == pioneerLeaveReason.AccountUnder13
			then
				blockJoin(v12.reason)
			end
		end
	elseif fFlagPioneerLeaveOnInExpFaeDownAge then
		local v12 = experienceService:ConsumePendingExperienceLeaveWithReason()

		if v12 and v12.reason == pioneerLeaveReason.AccountUnder13 then
			blockJoin(v12.reason)
		end
	end

	if module2 then
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
