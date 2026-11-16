local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)

local useMemo = React.useMemo

local AuditContentContext = require(AuthCommon.Stores.AuditContentContext.AuditContentContext)
local useCapturedAuditContent = AuditContentContext.useCapturedAuditContent

local GetFFlagEnableAuditSystem = require(AuthCommon.Flags.GetFFlagEnableAuditSystem)

local function parseTranslationKey(translationKey: string)
	if not translationKey or translationKey == "" then
		return "", ""
	end

	local v = string.split(translationKey, ".")

	if not (#v >= 3) then
		return "", translationKey
	end

	local v2 = v[1] .. "." .. v[2]
	local v3 = {}

	for i = 3, #v do
		table.insert(v3, v[i])
	end

	return v2, (table.concat(v3, "."))
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

		local translationNamespace, translationKey2 = parseTranslationKey(translationKey)

		if translationNamespace == "" then
			return nil
		end

		return {
			translationKey = translationKey2,
			translationNamespace = translationNamespace,
			translatedSourceString = translatedSourceString,
			parameters = parameters
		}
	end, { translationKey, translatedSourceString, parameters })))

	return nil
end

return RegisterAuditContent
