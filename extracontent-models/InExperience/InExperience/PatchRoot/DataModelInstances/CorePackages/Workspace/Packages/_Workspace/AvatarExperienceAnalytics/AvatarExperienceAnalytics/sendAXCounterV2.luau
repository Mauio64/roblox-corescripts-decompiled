local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local default = require(Parent.LoggingProtocol).default
local Dash = require(Parent.Dash)
local isSpatial = require(Parent.AppCommonLib).isSpatial

local function getAXCounterV2Metadata(t1: {[any]: any}?) -- line: 15
	-- upvalues: UserInputService (copy), isSpatial (copy), RunService (copy), HttpService (copy), Dash (copy)
	local Platform = UserInputService:GetPlatform()

	if isSpatial() then
		Platform = "VR"
	end

	local t2 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = Platform
	}

	if t1 and next(t1) ~= nil then
		t2 = Dash.assign({}, t2, t1)
	end

	return t2
end
local function sendAXCounterV2(s1: string, t3: {[any]: any}?) -- line: 35
	-- upvalues: default (copy), getAXCounterV2Metadata (copy)
	local t4 = {
		description = "Counter to track various Avatar Experience events.",
		links = "",
		eventName = "AvatarExperience_" .. s1,
		backends = { default.TelemetryBackends.Counter },
		lastUpdated = {
			2025,
			10,
			30
		}
	}
	local v16 = getAXCounterV2Metadata(t3)

	default:logRobloxTelemetryCounter(t4, 1, v16)
end

return sendAXCounterV2
