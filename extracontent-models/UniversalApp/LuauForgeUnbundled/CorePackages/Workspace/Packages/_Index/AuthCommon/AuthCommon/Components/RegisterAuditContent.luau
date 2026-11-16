local useMemo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React").useMemo

local useCapturedAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores/AuditContentContext/AuditContentContext").useCapturedAuditContent

local GetFFlagEnableAuditSystem = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/GetFFlagEnableAuditSystem")

local function parseTranslationKey(translationKey)
	if not translationKey or translationKey == "" then
		return "", ""
	end

	local v5 = string.split(translationKey, ".")

	if not (#v5 >= 3) then
		return "", translationKey
	end

	local v6 = v5[1] .. "." .. v5[2]
	local v7 = {}

	for i = 3, #v5 do
		table.insert(v7, v5[i])
	end

	return v6, (table.concat(v7, "."))
end

local function RegisterAuditContent(data): nil
	if not GetFFlagEnableAuditSystem() then
		return nil
	end

	local translationKey = data.translationKey
	local translatedSourceString = data.translatedSourceString
	local parameters = data.parameters

	useCapturedAuditContent(translationKey, (useMemo(function()
		if not (translationKey and translatedSourceString) then
			return nil
		end

		local v6, v7 = parseTranslationKey(translationKey)

		if v6 == "" then
			return nil
		end

		return {
			translationKey = v7,
			translationNamespace = v6,
			translatedSourceString = translatedSourceString,
			parameters = parameters
		}
	end, { translationKey, translatedSourceString, parameters })))

	return nil
end

return RegisterAuditContent
