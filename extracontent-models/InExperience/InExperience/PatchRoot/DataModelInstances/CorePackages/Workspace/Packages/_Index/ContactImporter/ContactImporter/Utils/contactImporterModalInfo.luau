local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)
local getFIntContactImporterModalDisplayMaxCount = require(script.Parent.Parent.Flags.getFIntContactImporterModalDisplayMaxCount)
local getFIntContactImporterModalDisplayMinDays = require(script.Parent.Parent.Flags.getFIntContactImporterModalDisplayMinDays)
local EngineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	isUserOptedInLocalStorage = function(_, p2, p3) -- line: 18
		-- upvalues: EngineFeature (copy), Constants (copy)
		if not EngineFeature then
			return false
		end

		local ok, result = pcall(function() -- line: 29
			-- upvalues: p2 (copy), Constants (copy)
			return p2:GetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS)
		end)

		if ok then
			for match in string.gmatch(result or "", "([^,]+)") do
				if p3 == match then
					return true
				end
			end
		end

		return false
	end,
	shouldUserSeeModalPotentiallyAgain = function(_, p5, p6) -- line: 43
		-- upvalues: EngineFeature (copy), Constants (copy), getFIntContactImporterModalDisplayMaxCount (copy), getFIntContactImporterModalDisplayMinDays (copy)
		if not EngineFeature then
			return true
		end

		local ok, result = pcall(function() -- line: 49
			-- upvalues: p5 (copy), Constants (copy)
			return p5:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT)
		end)

		if not ok then
			return true
		end

		local n1 = 0

		for match in string.gmatch(result or "", "([^,]+)") do
			local parts = string.split(match, ":")

			if p6 == parts[1] then
				n1 = tonumber(parts[2]) or 0

				break
			end
		end

		if n1 <= getFIntContactImporterModalDisplayMaxCount() then
			return true
		end

		local ok2, result2 = pcall(function() -- line: 69
			-- upvalues: p5 (copy), Constants (copy)
			return p5:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP)
		end)

		if not ok2 then
			return true
		end

		local n2 = 0

		for match in string.gmatch(result2 or "", "([^,]+)") do
			local parts = string.split(match, ":")

			if p6 == parts[1] then
				n2 = tonumber(parts[2]) or 0

				break
			end
		end

		local v24 = getFIntContactImporterModalDisplayMinDays() * 86400000

		return DateTime.now().UnixTimestampMillis >= n2 + v24
	end
}
