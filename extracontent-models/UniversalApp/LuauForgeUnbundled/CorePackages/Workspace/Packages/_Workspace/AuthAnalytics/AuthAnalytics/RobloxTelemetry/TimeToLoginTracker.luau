local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/LoggingProtocol")
local TelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/RobloxTelemetry/TelemetryConfigs")

local function getWallClockMillis()
	return DateTime.now().UnixTimestampMillis
end

local function createTimeToLoginTracker(default, p2, p3, p4)
	local v5 = p2 or getWallClockMillis
	local v6 = p3 or MemStorageService
	local v7 = p4 or HttpService

	local function readPendingAttempt()
		local item = v6:GetItem("TimeToLoginPending")

		if item == nil or item == "" then
			return nil
		end

		local success, result = pcall(function()
			return v7:JSONDecode(item)
		end)

		if not success or type(result) ~= "table" then
			return nil
		end

		local loginType = result.loginType
		local identifierType = result.identifierType
		local startTimeMillis = result.startTimeMillis

		if
			type(loginType) == "string"
			and type(identifierType) == "string"
			and type(startTimeMillis) == "number"
		then
			return {
				loginType = loginType,
				identifierType = identifierType,
				startTimeMillis = startTimeMillis,
				twoStepVerification = result.twoStepVerification == true
			}
		end

		return nil
	end

	local function writePendingAttempt(data)
		v6:SetItem(
			"TimeToLoginPending",
			v7:JSONEncode({
				loginType = data.loginType,
				identifierType = data.identifierType,
				startTimeMillis = data.startTimeMillis,
				twoStepVerification = data.twoStepVerification
			})
		)
	end

	local function pendingAgeMillis(p5)
		return v5() - p5.startTimeMillis
	end

	local function reportInvalidDuration(p5, p6)
		default:logRobloxTelemetryCounter(TelemetryConfigs.TimeToLoginInvalidDurationConfig, 1, {
			loginType = p5.loginType,
			reason = p6
		})
	end

	return {
		start = function(p5, value)
			if p5 == nil or p5 == "" then
				return
			end

			local v8 = {
				loginType = p5,
				identifierType = value or "Unknown",
				startTimeMillis = v5(),
				twoStepVerification = false
			}
			v6:SetItem(
				"TimeToLoginPending",
				v7:JSONEncode({
					loginType = v8.loginType,
					identifierType = v8.identifierType,
					startTimeMillis = v8.startTimeMillis,
					twoStepVerification = v8.twoStepVerification
				})
			)
		end,
		markTwoStepVerification = function()
			local v8 = readPendingAttempt()

			if v8 == nil or v8.twoStepVerification then
				return
			end

			v8.twoStepVerification = true
			v6:SetItem(
				"TimeToLoginPending",
				v7:JSONEncode({
					loginType = v8.loginType,
					identifierType = v8.identifierType,
					startTimeMillis = v8.startTimeMillis,
					twoStepVerification = v8.twoStepVerification
				})
			)
		end,
		cancel = function()
			v6:SetItem("TimeToLoginPending", "")
		end,
		finish = function()
			local v8 = readPendingAttempt()

			if v8 == nil then
				return
			end

			v6:SetItem("TimeToLoginPending", "")

			local v9 = v5() - v8.startTimeMillis

			if v9 < 0 then
				default:logRobloxTelemetryCounter(TelemetryConfigs.TimeToLoginInvalidDurationConfig, 1, {
					loginType = v8.loginType,
					reason = "negative"
				})
			elseif v9 > 600000 then
				default:logRobloxTelemetryCounter(TelemetryConfigs.TimeToLoginInvalidDurationConfig, 1, {
					loginType = v8.loginType,
					reason = "stale"
				})
			else
				default:logRobloxTelemetryStat(TelemetryConfigs.TimeToLoginStatConfig, math.floor(v9), {
					loginType = v8.loginType,
					identifierType = v8.identifierType,
					twoStepVerification = tostring(v8.twoStepVerification)
				})
			end
		end
	}
end

return {
	create = createTimeToLoginTracker,
	default = createTimeToLoginTracker(LoggingProtocol.default)
}
