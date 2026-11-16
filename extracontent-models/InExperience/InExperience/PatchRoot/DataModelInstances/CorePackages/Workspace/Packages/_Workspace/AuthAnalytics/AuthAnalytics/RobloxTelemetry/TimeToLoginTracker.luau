local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local parent = script:FindFirstAncestor("AuthAnalytics").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local TelemetryConfigs = require(script.Parent.TelemetryConfigs)

local function getWallClockMillis()
	return DateTime.now().UnixTimestampMillis
end

local function createTimeToLoginTracker(default, callback, p, p2)
	local v = callback or getWallClockMillis
	local v2 = p or MemStorageService
	local v3 = p2 or HttpService

	local function readPendingAttempt()
		local item = v2:GetItem("TimeToLoginPending")

		if item == nil or item == "" then
			return nil
		end

		local success, result = pcall(function()
			return v3:JSONDecode(item)
		end)

		if not success or type(result) ~= "table" then
			return nil
		end

		local loginType = result.loginType
		local identifierType = result.identifierType
		local startTimeMillis = result.startTimeMillis

		if type(loginType) == "string" and type(identifierType) == "string" and type(startTimeMillis) == "number" then
			return {
				loginType = loginType,
				identifierType = identifierType,
				startTimeMillis = startTimeMillis,
				twoStepVerification = result.twoStepVerification == true
			}
		end

		return nil
	end

	local function writePendingAttempt(data) -- 2 equivalent calls inferred from this helper
		v2:SetItem(
			"TimeToLoginPending",
			v3:JSONEncode({
				loginType = data.loginType,
				identifierType = data.identifierType,
				startTimeMillis = data.startTimeMillis,
				twoStepVerification = data.twoStepVerification
			})
		)
	end

	local function cancel() -- 1 equivalent call inferred from this helper
		v2:SetItem("TimeToLoginPending", "")
	end

	local function pendingAgeMillis(p3) -- 1 equivalent call inferred from this helper
		return v() - p3.startTimeMillis
	end

	local function reportInvalidDuration(p3, reason: string) -- 2 equivalent calls inferred from this helper
		default:logRobloxTelemetryCounter(TelemetryConfigs.TimeToLoginInvalidDurationConfig, 1, {
			loginType = p3.loginType,
			reason = reason
		})
	end

	return {
		start = function(loginType: string, value: string?)
			if loginType == nil or loginType == "" then
				return
			end

			writePendingAttempt({ -- inferred equivalent call
				loginType = loginType,
				identifierType = value or "Unknown",
				startTimeMillis = v(),
				twoStepVerification = false
			})
		end,
		markTwoStepVerification = function()
			local v4 = readPendingAttempt()

			if v4 == nil or v4.twoStepVerification then
				return
			end

			v4.twoStepVerification = true
			writePendingAttempt(v4) -- inferred equivalent call
		end,
		cancel = cancel,
		finish = function()
			local v4 = readPendingAttempt()

			if v4 == nil then
				return
			end

			cancel() -- inferred equivalent call
			local v5 = pendingAgeMillis(v4) -- inferred equivalent call

			if v5 < 0 then
				reportInvalidDuration(v4, "negative") -- inferred equivalent call
			elseif v5 > 600000 then
				reportInvalidDuration(v4, "stale") -- inferred equivalent call
			else
				default:logRobloxTelemetryStat(TelemetryConfigs.TimeToLoginStatConfig, math.floor(v5), {
					loginType = v4.loginType,
					identifierType = v4.identifierType,
					twoStepVerification = tostring(v4.twoStepVerification)
				})
			end
		end
	}
end

return {
	create = createTimeToLoginTracker,
	default = createTimeToLoginTracker(LoggingProtocol.default)
}
