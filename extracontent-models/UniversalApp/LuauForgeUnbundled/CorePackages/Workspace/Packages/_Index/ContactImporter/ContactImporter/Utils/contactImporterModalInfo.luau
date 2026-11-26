local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")

local getFIntContactImporterModalDisplayMaxCount = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterModalDisplayMaxCount")

local getFIntContactImporterModalDisplayMinDays = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterModalDisplayMinDays")

local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)

return {
	isUserOptedInLocalStorage = function(self, object, p3): boolean
		if not engineFeature then
			return false
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS)
		end)

		if success then
			for k in string.gmatch(result or "", "([^,]+)") do
				if p3 == k then
					return true
				end
			end
		end

		return false
	end,
	shouldUserSeeModalPotentiallyAgain = function(self, object, p3): boolean
		if not engineFeature then
			return true
		end

		local success, result = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT)
		end)

		if not success then
			return true
		end

		local v5 = 0

		for k in string.gmatch(result or "", "([^,]+)") do
			local v7 = string.split(k, ":")

			if v7[1] == p3 then
				v5 = tonumber(v7[2]) or 0
				break
			end
		end

		if v5 <= getFIntContactImporterModalDisplayMaxCount() then
			return true
		end

		local success2, result2 = pcall(function()
			return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP)
		end)

		if not success2 then
			return true
		end

		local v7 = 0

		for k in string.gmatch(result2 or "", "([^,]+)") do
			local v9 = string.split(k, ":")

			if v9[1] == p3 then
				v7 = tonumber(v9[2]) or 0
				break
			end
		end

		local v9 = getFIntContactImporterModalDisplayMinDays() * 86400000
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		return v7 + v9 <= unixTimestampMillis
	end
}
