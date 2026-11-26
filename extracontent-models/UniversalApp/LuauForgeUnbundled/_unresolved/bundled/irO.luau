local AppStorageService = game:GetService("AppStorageService")

local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local module2 = require("@luauforge/bundled/irP")
local module3 = require("@luauforge/bundled/irQ")
local module4 = require("@luauforge/bundled/irR")

local defineFastInt = game:DefineFastInt("LuaAppRootUnmountHeartbeatIntervalSeconds", 1)
local defineFastInt2 = game:DefineFastInt("LuaAppRootUnmountHeartbeatMaxSeconds", 900)

local defineFastInt3 = game:DefineFastInt("LuaAppRootUnmountHeartbeatFastWindowSeconds", 60)

local defineFastInt4 = game:DefineFastInt("LuaAppRootUnmountHeartbeatSlowIntervalSeconds", 10)

local luaAppRootUnmountRecord = localStorageKey.LuaAppRootUnmountRecord

local function getAppLifecycleObserverService()
	local success, result = pcall(function()
		return game:GetService("AppLifecycleObserverService")
	end)

	if success then
		return result
	end

	return nil
end

local function getDefaultDeps()
	local defaultDeps = {
		appStorageService = AppStorageService,
		appLifecycleObserverService = 0,
		loggingProtocol = 0,
		getNowMs = 0,
		getSessionId = 0,
		getAppVersion = 0,
		getPlatform = 0,
		delay = 0
	}
	local success, result = pcall(function()
		return game:GetService("AppLifecycleObserverService")
	end)

	if not success then
		result = nil
	end

	defaultDeps.appLifecycleObserverService = result
	defaultDeps.loggingProtocol = LoggingProtocol.default
	function defaultDeps.getNowMs()
		return DateTime.now().UnixTimestampMillis
	end

	function defaultDeps.getSessionId()
		return RbxAnalyticsService:GetSessionId()
	end

	function defaultDeps.getAppVersion()
		return RunService:GetRobloxVersion()
	end

	function defaultDeps.getPlatform()
		return UserInputService:GetPlatform().Name
	end

	function defaultDeps.delay(duration, callback)
		task.delay(duration, callback)
	end

	return defaultDeps
end

local function readRecord(object)
	local item = object:GetItem(luaAppRootUnmountRecord)

	if typeof(item) ~= "string" or item == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	if
		success
		and type(result) == "table"
		and type(result.unmountMs) == "number"
		and type(result.lastAliveMs) == "number"
		and (result.hiddenMs == nil or type(result.hiddenMs) == "number")
	then
		return result
	end

	return nil
end

local function writeRecord(object, p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if not success then
		return
	end

	object:SetItem(luaAppRootUnmountRecord, result)
	object:Flush()
end

local function readOwnRecord(p2, p3)
	local v5 = readRecord(p2)

	if v5 == nil or v5.unmountMs ~= p3 then
		return nil
	end

	return v5
end

return {
	recordUnmount = function(p2, p3)
		if not module3 then
			return
		end

		local v5 = p2 or getDefaultDeps()
		local appStorageService = v5.appStorageService
		local v6 = not (module4 and p3) and "root_unmount" or p3.trigger
		local sessionId = v5.getSessionId()

		if module4 and v6 == "root_unmount" then
			local v7 = readRecord(appStorageService)

			if v7 and v7.trigger == "boundary" and v7.sessionId == sessionId then
				return
			end
		end

		local nowMs = v5.getNowMs()

		local v7 = {
			unmountMs = nowMs,
			lastAliveMs = nowMs,
			sessionId = sessionId,
			appVersion = v5.getAppVersion(),
			trigger = 0,
			restart = 0
		}

		if not module4 then
			v6 = nil
		end

		v7.trigger = v6
		local v8 = if module4 and p3 then p3.restart else nil
		v7.restart = v8
		local success, result = pcall(function()
			return HttpService:JSONEncode(v7)
		end)

		if success then
			appStorageService:SetItem(luaAppRootUnmountRecord, result)
			appStorageService:Flush()
		end

		local appLifecycleObserverService = v5.appLifecycleObserverService

		if appLifecycleObserverService and appLifecycleObserverService.OnHide then
			local onHideConnection = nil
			onHideConnection = appLifecycleObserverService.OnHide:Connect(function()
				onHideConnection:Disconnect()
				local v10 = readRecord(appStorageService)

				if v10 == nil or v10.unmountMs ~= nowMs then
					v10 = nil
				end

				if v10 == nil or v10.hiddenMs ~= nil then
					return
				end

				v10.hiddenMs = v5.getNowMs()
				local v11 = appStorageService
				local success2, result2 = pcall(function()
					return HttpService:JSONEncode(v10)
				end)

				if not success2 then
					return
				end

				v11:SetItem(luaAppRootUnmountRecord, result2)
				v11:Flush()
			end)
		end

		local v9 = defineFastInt2 * 1000
		local v10 = defineFastInt3 * 1000
		local function beat()
			local v12 = readRecord(appStorageService)

			if v12 == nil or v12.unmountMs ~= nowMs then
				v12 = nil
			end

			if v12 == nil then
				return
			end

			local nowMs2 = v5.getNowMs()

			if v9 <= nowMs2 - nowMs then
				v12.lastAliveMs = nowMs + v9
				v12.heartbeatCapped = true
				local v14 = appStorageService
				local success2, result2 = pcall(function()
					return HttpService:JSONEncode(v12)
				end)

				if not success2 then
					return
				end

				v14:SetItem(luaAppRootUnmountRecord, result2)
				v14:Flush()
			else
				v12.lastAliveMs = nowMs2
				local v14 = appStorageService
				local success2, result2 = pcall(function()
					return HttpService:JSONEncode(v12)
				end)

				if success2 then
					v14:SetItem(luaAppRootUnmountRecord, result2)
					v14:Flush()
				end

				local delay2 = v5.delay
				local v15 = if nowMs2 - nowMs < v10 then defineFastInt else defineFastInt4
				delay2(v15, beat)
			end
		end
		v5.delay(defineFastInt, beat)
	end,
	reportPreviousUnmount = function(p2)
		if not module3 then
			return
		end

		local v5 = p2 or getDefaultDeps()
		local appStorageService = v5.appStorageService
		local v6 = readRecord(appStorageService)

		if v6 == nil then
			return
		end

		appStorageService:SetItem(luaAppRootUnmountRecord, "")
		appStorageService:Flush()

		local hiddenMs = v6.hiddenMs
		local loggingProtocol = v5.loggingProtocol
		local v9 = {
			msUnmountToLastAlive = v6.lastAliveMs - v6.unmountMs,
			msUnmountToHidden = 0,
			msUnmountToRelaunch = 0,
			wasHidden = 0,
			heartbeatCapped = 0,
			isSameSession = 0,
			previousSessionId = 0,
			previousAppVersion = 0,
			platform = 0,
			trigger = 0,
			restart = 0
		}
		local v10 = if hiddenMs then hiddenMs - v6.unmountMs else nil
		v9.msUnmountToHidden = v10
		v9.msUnmountToRelaunch = v5.getNowMs() - v6.unmountMs
		v9.wasHidden = hiddenMs == nil and 0 or 1
		v9.heartbeatCapped = v6.heartbeatCapped == true and 1 or 0
		v9.isSameSession = v6.sessionId == v5.getSessionId() and 1 or 0
		v9.previousSessionId = v6.sessionId
		v9.previousAppVersion = v6.appVersion
		v9.platform = v5.getPlatform()
		v9.trigger = module4 and (v6.trigger or "root_unmount") or nil
		local v11 = if module4 then v6.restart else nil
		v9.restart = v11
		loggingProtocol:logRobloxTelemetryEvent(module2, {}, v9)
	end
}
