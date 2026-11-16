local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Localization")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")

local LocalizationService = game:GetService("LocalizationService")

local function coerceNumericArg(value)
	if type(value) == "number" then
		return value
	end

	if type(value) == "string" then
		return (tonumber(value))
	end

	return nil
end

local function tryDateTimeFromIsoString(p2)
	local success, result = pcall(function()
		return DateTime.fromIsoDate(p2)
	end)

	if success and result then
		return result
	end

	return nil
end

local function resolveDateTimeForFormat(value)
	if type(value) == "number" then
		return DateTime.fromUnixTimestamp(value)
	end

	if type(value) == "string" then
		local v5

		if type(value) == "number" then
			v5 = value
		elseif type(value) == "string" then
			v5 = tonumber(value)
		end

		if v5 ~= nil then
			return DateTime.fromUnixTimestamp(v5)
		end

		local success, result = pcall(function()
			return DateTime.fromIsoDate(value)
		end)

		if success and result then
			return result
		end

		return nil
	elseif type(value) == "table" and value.seconds ~= nil then
		return resolveDateTimeForFormat(value.seconds)
	else
		return nil
	end
end

return {
	applyFormatArgFormatter = function(value, p2, p3, p4)
		if p2.type == "TYPE_INVALID" or p2.type == nil then
			local v5 = { message = "Formatter specified without a type" }

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v5, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, p3)
			return nil
		elseif p2.type == "TYPE_NUMBER_ABBREVIATE" then
			local v5

			if type(value) == "number" then
				v5 = value
			elseif type(value) == "string" then
				v5 = tonumber(value)
			end

			if v5 ~= nil then
				return Localization.NumberLocalization.abbreviate(v5, LocalizationService.RobloxLocaleId)
			end

			local v6 = {
				message = `Formatter TYPE_NUMBER_ABBREVIATE received incompatible type '{typeof(value)}'`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v6, p3)
			return nil
		elseif p2.type == "TYPE_NUMBER_LOCALIZE" then
			local v5

			if type(value) == "number" then
				v5 = value
			elseif type(value) == "string" then
				v5 = tonumber(value)
			end

			if v5 ~= nil then
				return Localization.NumberLocalization.localize(v5, LocalizationService.RobloxLocaleId)
			end

			local v6 = {
				message = `Formatter TYPE_NUMBER_LOCALIZE received incompatible type '{typeof(value)}'`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v6, p3)
			return nil
		elseif p2.type == "TYPE_DATE_FORMAT" then
			local dateTimeForFormat = resolveDateTimeForFormat(value)

			if dateTimeForFormat ~= nil then
				local config = p2.config

				return dateTimeForFormat:FormatLocalTime(
					(not config or config.type ~= "date_config" or not config.value.pattern or config.value.pattern == "") and "L" or config.value.pattern,
					LocalizationService.RobloxLocaleId
				)
			end

			local v5 = {
				message = `Formatter TYPE_DATE_FORMAT received incompatible type '{typeof(value)}'`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v5, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, p3)
			return nil
		else
			local v5 = {
				message = `Unknown formatter type '{p2.type}'`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v5, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, p3)
			return nil
		end
	end
}
