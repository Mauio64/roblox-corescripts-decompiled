local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local Dash = require(parent.Dash)

local AppCommonLib = require(parent.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters

local function getAXCounterV2Metadata(items)
	local platform = UserInputService:GetPlatform()
	local platform2 = isSpatial() and "VR" or platform

	local v = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = platform2
	}

	if items and next(items) ~= nil then
		return (Dash.assign({}, v, items))
	end

	return v
end

local function sendAXCounterV2(p: string, p2, p3: number?)
	default:logRobloxTelemetryCounter({
		eventName = "AvatarExperience_" .. p,
		backends = { default.TelemetryBackends.Counter },
		lastUpdated = { 2025, 10, 30 },
		description = "Counter to track various Avatar Experience events.",
		links = ""
	}, FFlagAXUnifiedEventCounters and p3 or 1, getAXCounterV2Metadata(p2))
end

return sendAXCounterV2
