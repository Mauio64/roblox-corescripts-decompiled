local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local Lighting = game:GetService("Lighting")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local default = require(CorePackages.Workspace.Packages.AppCommonLib).Utils.AppStorageJsonCacheUtils.default
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local GetFStringDefaultSkyStyle = SharedFlags.GetFStringDefaultSkyStyle
local GetFIntSkyStyleDayClockTime = SharedFlags.GetFIntSkyStyleDayClockTime
local t1 = {
	Day = "Day",
	Night = "Night"
}
local v11 = t1[GetFStringDefaultSkyStyle()] or t1.Day
local v12 = GetFIntSkyStyleDayClockTime()
local t2 = {
	SkyStyleEnum = t1,
	isValidLocalUserId = function(s1: string?) -- line: 37
		local num = tonumber(s1)

		return num ~= nil and num > 0
	end,
	getSkyStyleFromName = function(s2: string?) -- line: 42
		-- upvalues: t1 (copy)
		if not s2 then
			return nil
		end

		return t1[s2]
	end
}

function t2.getCachedSkyStyle(s3: string?, t3: {[any]: any}?) -- line: 50
	-- upvalues: t2 (copy), Logger (copy), v11 (copy), default (copy)
	if not t2.isValidLocalUserId(s3) then
		Logger:info("[SkyStyleUtils] The userId is not valid, defaulting to sky style: " .. v11)

		return v11
	end

	local result = ((t3 or {}).appStorageJsonCacheUtils or default):decodeInternal("SkyStyle").result
	local v20 = if type(result) ~= "table" then nil else result[s3]
	local v21 = t2.getSkyStyleFromName(v20) or v11

	Logger:info("[SkyStyleUtils] Fetched cached sky style: " .. v21 .. " for userId: " .. tostring(s3))

	return v21
end
function t2.setCachedSkyStyle(s4: string?, s5: string, t4: {[any]: any}?) -- line: 65
	-- upvalues: t2 (copy), default (copy), AppStorageService (copy), HttpService (copy), Logger (copy)
	if not t2.isValidLocalUserId(s4) then
		return
	end

	local v25 = t2.getSkyStyleFromName(s5)

	if not v25 then
		return
	end

	local v26 = t4 or {}
	local v27 = v26.appStorageJsonCacheUtils or default
	local v28 = v26.appStorageService or AppStorageService
	local v29 = v26.httpService or HttpService
	local result = v27:decodeInternal("SkyStyle").result

	if type(result) ~= "table" then
		result = {}
	end

	result[s4] = v25
	Logger:info("[SkyStyleUtils] Caching sky style: " .. v25 .. " for userId: " .. tostring(s4))
	v28:SetItem("SkyStyle", v29:JSONEncode(result))
	v28:Flush()
end
function t2.createSimpleSky(t5: {[any]: any}?) -- line: 91
	-- upvalues: Lighting (copy), Logger (copy)
	local v32 = (t5 or {}).lighting or Lighting

	if v32:FindFirstChild("SimpleSky") then
		return
	end

	Logger:info("[SkyStyleUtils] Creating simple sky")

	local Sky = Instance.new("Sky")

	Sky.CelestialBodiesShown = false
	Sky.Name = "SimpleSky"
	Sky.Parent = v32
end
function t2.setDefaultSky(t6: {[any]: any}?) -- line: 106
	-- upvalues: Lighting (copy)
	local v35 = (t6 or {}).lighting or Lighting
	local Sky = v35:FindFirstChild("Sky")
	local SimpleSky = v35:FindFirstChild("SimpleSky")

	if not Sky or not SimpleSky then
		return
	end

	Sky.Parent = nil
	Sky.Parent = v35
end
function t2.setSimpleSky(t7: {[any]: any}?) -- line: 122
	-- upvalues: Lighting (copy)
	local v39 = (t7 or {}).lighting or Lighting
	local Sky = v39:FindFirstChild("Sky")
	local SimpleSky = v39:FindFirstChild("SimpleSky")

	if not Sky or not SimpleSky then
		return
	end

	SimpleSky.Parent = nil
	SimpleSky.Parent = v39
end
function t2.applyDaySky(t8: {[any]: any}?) -- line: 138
	-- upvalues: Lighting (copy), v12 (copy), t2 (copy)
	local v43 = t8 or {};

	(v43.lighting or Lighting).ClockTime = v12
	t2.setSimpleSky(v43)
end
function t2.applyNightSky(t9: {[any]: any}?) -- line: 145
	-- upvalues: Lighting (copy), t2 (copy)
	local v45 = t9 or {};

	(v45.lighting or Lighting).ClockTime = 12.2525
	t2.setDefaultSky(v45)
end
function t2.applySkyStyle(s6: string, t10: {[any]: any}?) -- line: 152
	-- upvalues: Logger (copy), t1 (copy), t2 (copy)
	local v48 = t10 or {}

	Logger:info("[SkyStyleUtils] Applying sky style: " .. s6)

	if s6 == t1.Day then
		t2.applyDaySky(v48)

		return
	end

	if s6 == t1.Night then
		t2.applyNightSky(v48)
	end
end
function t2.applyCachedSkyStyle(s7: string?, t11: {[any]: any}?) -- line: 163
	-- upvalues: Logger (copy), t2 (copy)
	Logger:info("[SkyStyleUtils] Applying cached sky style for userId: " .. tostring(s7))

	local v51 = t2.getCachedSkyStyle(s7, t11)

	t2.applySkyStyle(v51, t11)
end

return t2
