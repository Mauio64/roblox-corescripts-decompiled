local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local Localization = require(parent.Localization)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

local LocalizationService = game:GetService("LocalizationService")

local function coerceNumericArg(value) -- 3 equivalent calls inferred from this helper
	if type(value) == "number" then
		return value
	end

	if type(value) == "string" then
		return (tonumber(value))
	end

	return nil
end

local function tryDateTimeFromIsoString(value: string) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return DateTime.fromIsoDate(value)
	end)
	return if success and result then result else nil
end

local function resolveDateTimeForFormat(value)
	if type(value) == "number" then
		return DateTime.fromUnixTimestamp(value)
	end

	if type(value) == "string" then
		local v = coerceNumericArg(value) -- inferred equivalent call

		if v ~= nil then
			return DateTime.fromUnixTimestamp(v)
		end

		return tryDateTimeFromIsoString(value) -- inferred equivalent call
	elseif type(value) == "table" and value.seconds ~= nil then
		return resolveDateTimeForFormat(value.seconds)
	else
		return nil
	end
end

return {
	applyFormatArgFormatter = function(value, p, p2: string, p3)
		if p.type == "TYPE_INVALID" or p.type == nil then
			local v = { message = "Formatter specified without a type" }

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v, p3)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, p2)
			return nil
		elseif p.type == "TYPE_NUMBER_ABBREVIATE" then
			local v = coerceNumericArg(value) -- inferred equivalent call

			if v ~= nil then
				return Localization.NumberLocalization.abbreviate(v, LocalizationService.RobloxLocaleId)
			end

			local v2 = {
				message = `Formatter TYPE_NUMBER_ABBREVIATE received incompatible type '{typeof(value)}'`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v2, p3)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v2, p2)
			return nil
		elseif p.type == "TYPE_NUMBER_LOCALIZE" then
			local v = coerceNumericArg(value) -- inferred equivalent call

			if v ~= nil then
				return Localization.NumberLocalization.localize(v, LocalizationService.RobloxLocaleId)
			end

			local v2 = {
				message = `Formatter TYPE_NUMBER_LOCALIZE received incompatible type '{typeof(value)}'`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v2, p3)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v2, p2)
			return nil
		elseif p.type == "TYPE_DATE_FORMAT" then
			local dateTimeForFormat = resolveDateTimeForFormat(value)

			if dateTimeForFormat ~= nil then
				local config = p.config

				return dateTimeForFormat:FormatLocalTime(
					(not config or config.type ~= "date_config" or not config.value.pattern or config.value.pattern == "") and "L" or config.value.pattern,
					LocalizationService.RobloxLocaleId
				)
			end

			local v = {
				message = `Formatter TYPE_DATE_FORMAT received incompatible type '{typeof(value)}'`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v, p3)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, p2)
			return nil
		else
			local v = {
				message = `Unknown formatter type '{p.type}'`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v, p3)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, p2)
			return nil
		end
	end
}
