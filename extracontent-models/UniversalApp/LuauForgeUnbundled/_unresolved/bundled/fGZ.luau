local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local Lighting = game:GetService("Lighting")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local default = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.AppStorageJsonCacheUtils.default
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module2 = require("@luauforge/bundled/fHa")

local getFStringDefaultSkyStyle = SharedFlags.GetFStringDefaultSkyStyle
local getFIntSkyStyleDayClockTime = SharedFlags.GetFIntSkyStyleDayClockTime

local v5 = { Day = "Day", Night = "Night" }

local v6 = v5[getFStringDefaultSkyStyle()] or v5.Day
local fIntSkyStyleDayClockTime = getFIntSkyStyleDayClockTime()

local v7 = { SkyStyleEnum = v5 }

function v7.isValidLocalUserId(p2): boolean
	local v8 = tonumber(p2)
	return v8 ~= nil and v8 > 0
end

function v7.getSkyStyleFromName(p2)
	if p2 then
		return v5[p2]
	end

	return nil
end

function v7.getCachedSkyStyle(p2, options)
	if not v7.isValidLocalUserId(p2) then
		logger:info("[SkyStyleUtils] The userId is not valid, defaulting to sky style: " .. v6)
		return v6
	end

	local result = ((options or {}).appStorageJsonCacheUtils or default):decodeInternal("SkyStyle").result
	local v8 = if type(result) == "table" then result[p2] else nil
	local v9 = v7.getSkyStyleFromName(v8) or v6
	logger:info("[SkyStyleUtils] Fetched cached sky style: " .. v9 .. " for userId: " .. tostring(p2))
	return v9
end

function v7.setCachedSkyStyle(p2, p3, options)
	if not v7.isValidLocalUserId(p2) then
		return
	end

	local skyStyleFromName = v7.getSkyStyleFromName(p3)

	if skyStyleFromName then
		local v8 = options or {}
		local appStorageJsonCacheUtils = v8.appStorageJsonCacheUtils or default
		local appStorageService = v8.appStorageService or AppStorageService
		local httpService = v8.httpService or HttpService
		local result = appStorageJsonCacheUtils:decodeInternal("SkyStyle").result

		local skyStyleFromNames = type(result) ~= "table" and {} or result

		skyStyleFromNames[p2] = skyStyleFromName
		logger:info("[SkyStyleUtils] Caching sky style: " .. skyStyleFromName .. " for userId: " .. tostring(p2))
		appStorageService:SetItem("SkyStyle", httpService:JSONEncode(skyStyleFromNames))
		appStorageService:Flush()
	elseif module2.FFlagEnableSkyStyleTelemetry then
		module2.reportError("invalidCachedName", p3, "setCachedSkyStyle")
	end
end

function v7.createSimpleSky(options)
	local lighting = (options or {}).lighting or Lighting

	if lighting:FindFirstChild("SimpleSky") then
		return
	end

	logger:info("[SkyStyleUtils] Creating simple sky")
	local simpleSky = Instance.new("Sky")
	simpleSky.CelestialBodiesShown = false
	simpleSky.Name = "SimpleSky"
	simpleSky.Parent = lighting
end

function v7.setDefaultSky(options)
	local lighting = (options or {}).lighting or Lighting

	local sky = lighting:FindFirstChild("Sky")
	local simpleSky = lighting:FindFirstChild("SimpleSky")

	if sky and simpleSky then
		sky.Parent = nil
		sky.Parent = lighting
	end
end

function v7.setSimpleSky(options)
	local lighting = (options or {}).lighting or Lighting

	local sky = lighting:FindFirstChild("Sky")
	local simpleSky = lighting:FindFirstChild("SimpleSky")

	if sky and simpleSky then
		simpleSky.Parent = nil
		simpleSky.Parent = lighting
	end
end

function v7.applyDaySky(options)
	local v8 = options or {}
	(v8.lighting or Lighting).ClockTime = fIntSkyStyleDayClockTime
	v7.setSimpleSky(v8)
end

function v7.applyNightSky(options)
	local v8 = options or {}
	(v8.lighting or Lighting).ClockTime = 12.2525
	v7.setDefaultSky(v8)
end

function v7.applySkyStyle(p2, options)
	local v8 = options or {}

	logger:info("[SkyStyleUtils] Applying sky style: " .. p2)

	if module2.FFlagEnableSkyStyleTelemetry then
		module2.reportApplied(p2)
	end

	if p2 == v5.Day then
		v7.applyDaySky(v8)
	elseif p2 == v5.Night then
		v7.applyNightSky(v8)
	end
end

function v7.applyCachedSkyStyle(p2, p3)
	logger:info("[SkyStyleUtils] Applying cached sky style for userId: " .. tostring(p2))
	local cachedSkyStyle = v7.getCachedSkyStyle(p2, p3)
	v7.applySkyStyle(cachedSkyStyle, p3)
end

return v7
