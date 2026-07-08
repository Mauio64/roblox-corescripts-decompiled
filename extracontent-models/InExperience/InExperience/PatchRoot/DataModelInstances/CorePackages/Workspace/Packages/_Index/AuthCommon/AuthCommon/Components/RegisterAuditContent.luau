local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local useMemo = require(AuthCommonParent.React).useMemo
local useCapturedAuditContent = require(AuthCommon.Stores.AuditContentContext.AuditContentContext).useCapturedAuditContent
local GetFFlagEnableAuditSystem = require(AuthCommon.Flags.GetFFlagEnableAuditSystem)

local function parseTranslationKey(s1: string) -- line: 45
	if not s1 or s1 == "" then
		return "", ""
	end

	local parts = string.split(s1, ".")

	if #parts >= 3 then
		local v10 = parts[1] .. "." .. parts[2]
		local t1 = {}

		for i = 3, #parts do
			table.insert(t1, parts[i])
		end

		return v10, (table.concat(t1, "."))
	end

	return "", s1
end
local function RegisterAuditContent(t2: {[any]: any}) -- line: 70
	-- upvalues: GetFFlagEnableAuditSystem (copy), useMemo (copy), parseTranslationKey (copy), useCapturedAuditContent (copy)
	if not GetFFlagEnableAuditSystem() then
		return nil
	end

	local translationKey = t2.translationKey
	local translatedSourceString = t2.translatedSourceString
	local parameters = t2.parameters
	local v17 = useMemo(function() -- line: 79
		-- upvalues: translationKey (copy), translatedSourceString (copy), parseTranslationKey (copy), parameters (copy)
		if not translationKey or not translatedSourceString then
			return nil
		end

		local v18, v19 = parseTranslationKey(translationKey)

		if v18 == "" then
			return nil
		end

		return {
			translationKey = v19,
			translationNamespace = v18,
			translatedSourceString = translatedSourceString,
			parameters = parameters
		}
	end, {
		translationKey,
		translatedSourceString,
		parameters
	})

	useCapturedAuditContent(translationKey, v17)

	return nil
end

return RegisterAuditContent
