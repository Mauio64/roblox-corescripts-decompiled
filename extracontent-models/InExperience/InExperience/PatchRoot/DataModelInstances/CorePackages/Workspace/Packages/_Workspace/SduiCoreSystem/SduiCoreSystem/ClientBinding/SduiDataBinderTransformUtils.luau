local LocalizationService = game:GetService("LocalizationService")
local SduiDataBinderTransformUtils = {}

function SduiDataBinderTransformUtils.snakeToCamel(value: string)
	return value:gsub("_(%l)", function(value2)
		return value2:upper()
	end)
end

function SduiDataBinderTransformUtils.protobufTimestampToLocalTimeString(p)
	if p == nil then
		return nil
	end

	if p.seconds then
		return DateTime.fromUnixTimestamp(p.seconds):FormatLocalTime("ll", LocalizationService.RobloxLocaleId)
	end

	return (tostring(p))
end

return SduiDataBinderTransformUtils
