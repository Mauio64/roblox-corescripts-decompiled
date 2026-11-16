local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/LoggingProtocol").default
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Dash")

local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppCommonLib").isSpatial

local fFlagAXUnifiedEventCounters = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventCounters

local function getAXCounterV2Metadata(items)
	local platform = UserInputService:GetPlatform()
	local v5 = isSpatial() and "VR" or platform

	local v6 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = v5
	}

	if items and next(items) ~= nil then
		v6 = Dash.assign({}, v6, items)
	end

	return v6
end

local function sendAXCounterV2(p2, p3, p4)
	default:logRobloxTelemetryCounter({
		eventName = "AvatarExperience_" .. p2,
		backends = { default.TelemetryBackends.Counter },
		lastUpdated = { 2025, 10, 30 },
		description = "Counter to track various Avatar Experience events.",
		links = ""
	}, fFlagAXUnifiedEventCounters and p4 or 1, getAXCounterV2Metadata(p3))
end

return sendAXCounterV2
