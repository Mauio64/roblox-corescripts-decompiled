local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Localization = require(SduiCoreSystemParent.Localization)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local LocalizationService = game:GetService("LocalizationService")

local function coerceNumericArg(p1) -- line: 30
	if type(p1) == "number" then
		return p1
	end

	if type(p1) == "string" then
		return (tonumber(p1))
	end

	return nil
end
local function tryDateTimeFromIsoString(s1: string) -- line: 40
	local ok, result = pcall(function() -- line: 41
		-- upvalues: s1 (copy)
		return DateTime.fromIsoDate(s1)
	end)

	if ok and result then
		return result
	end

	return nil
end
local function resolveDateTimeForFormat(p2) -- line: 52
	-- upvalues: resolveDateTimeForFormat (copy)
	if type(p2) == "number" then
		return DateTime.fromUnixTimestamp(p2)
	end

	if type(p2) == "string" then
		local v15 = if type(p2) ~= "number" then if type(p2) ~= "string" then nil else tonumber(p2) else p2

		if v15 ~= nil then
			return DateTime.fromUnixTimestamp(v15)
		end

		local ok, result = pcall(function() -- line: 41
			-- upvalues: p2 (copy)
			return DateTime.fromIsoDate(p2)
		end)

		if ok and result then
			return result
		end

		return nil
	end

	if type(p2) == "table" and p2.seconds ~= nil then
		return resolveDateTimeForFormat(p2.seconds)
	end

	return nil
end

return {
	applyFormatArgFormatter = function(p3, t1: {[any]: any}, s2: string) -- line: 78
		-- upvalues: SduiLogger (copy), SduiErrors (copy), Localization (copy), LocalizationService (copy), resolveDateTimeForFormat (copy)
		if t1.type == "TYPE_INVALID" or t1.type == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = "Formatter specified without a type"
			}, s2)

			return nil
		end

		if t1.type == "TYPE_NUMBER_ABBREVIATE" then
			local v21 = if type(p3) ~= "number" then if type(p3) ~= "string" then nil else tonumber(p3) else p3

			if v21 == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Formatter TYPE_NUMBER_ABBREVIATE received incompatible type '{ typeof(p3) }'`
				}, s2)

				return nil
			end

			return Localization.NumberLocalization.abbreviate(v21, LocalizationService.RobloxLocaleId)
		end

		if t1.type == "TYPE_NUMBER_LOCALIZE" then
			local v22 = if type(p3) ~= "number" then if type(p3) ~= "string" then nil else tonumber(p3) else p3

			if v22 == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Formatter TYPE_NUMBER_LOCALIZE received incompatible type '{ typeof(p3) }'`
				}, s2)

				return nil
			end

			return Localization.NumberLocalization.localize(v22, LocalizationService.RobloxLocaleId)
		end

		if t1.type == "TYPE_DATE_FORMAT" then
			local v23 = resolveDateTimeForFormat(p3)

			if v23 == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Formatter TYPE_DATE_FORMAT received incompatible type '{ typeof(p3) }'`
				}, s2)

				return nil
			end

			local config = t1.config

			return v23:FormatLocalTime((not config or (config.type ~= "date_config" or (not config.value.pattern or config.value.pattern == ""))) and "L" or config.value.pattern, LocalizationService.RobloxLocaleId)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
			message = `Unknown formatter type '{ t1.type }'`
		}, s2)

		return nil
	end
}
