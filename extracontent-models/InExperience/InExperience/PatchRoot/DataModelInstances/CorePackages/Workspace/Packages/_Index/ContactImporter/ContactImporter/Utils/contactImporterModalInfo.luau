local Constants = require(script.Parent.Parent.Parent.ContactImporter.Common.Constants)

local getFIntContactImporterModalDisplayMaxCount = require(script.Parent.Parent.Flags.getFIntContactImporterModalDisplayMaxCount)

local getFIntContactImporterModalDisplayMinDays = require(script.Parent.Parent.Flags.getFIntContactImporterModalDisplayMinDays)

local engineFeature = game:GetEngineFeature(Constants.UNIVERSAL_APP_CONTACT_IMPORTER_STORAGE_KEYS)
local ContactImporterModalInfo = {}

function ContactImporterModalInfo.isUserOptedInLocalStorage(_, object, p): boolean
	if not engineFeature then
		return false
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_OPTED_IN_USERS)
	end)

	if success then
		for k in string.gmatch(result or "", "([^,]+)") do
			if p == k then
				return true
			end
		end
	end

	return false
end

function ContactImporterModalInfo.shouldUserSeeModalPotentiallyAgain(_, object, p): boolean
	if not engineFeature then
		return true
	end

	local success, result = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_DISPLAY_COUNT)
	end)

	if not success then
		return true
	end

	local v = 0

	for k in string.gmatch(result or "", "([^,]+)") do
		local v2 = string.split(k, ":")

		if v2[1] == p then
			v = tonumber(v2[2]) or 0
			break
		end
	end

	if v <= getFIntContactImporterModalDisplayMaxCount() then
		return true
	end

	local success2, result2 = pcall(function()
		return object:GetItem(Constants.LOCAL_STORAGE_KEY_MODAL_TIMESTAMP)
	end)

	if not success2 then
		return true
	end

	local v2 = 0

	for k in string.gmatch(result2 or "", "([^,]+)") do
		local v3 = string.split(k, ":")

		if v3[1] == p then
			v2 = tonumber(v3[2]) or 0
			break
		end
	end

	local v3 = getFIntContactImporterModalDisplayMinDays() * 86400000
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	return v2 + v3 <= unixTimestampMillis
end

return ContactImporterModalInfo
