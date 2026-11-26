local RunService = game:GetService("RunService")
local itemLicenseType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel").Enums.ItemLicenseType
local normalize = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/normalize")
local getRawItemLicensingInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getRawItemLicensingInfo")

local fFlagAXMarketplaceLicensingItemDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXMarketplaceLicensingItemDetails

local v5 = { itemLicenseType.FirstParty, itemLicenseType.ThirdParty }

local normalizeTableFn = normalize.makeNormalizeTableFn({
	id = { fn = normalize.normalizeString },
	licenseType = normalize.makeRequired(normalize.makeNormalizeValueFn(v5)),
	badgeAssetId = { fn = normalize.normalizeString },
	name = { fn = normalize.normalizeString },
	licenseHolder = { fn = normalize.normalizeString },
	licenseDisplayName = fFlagAXMarketplaceLicensingItemDetails and {
		fn = normalize.normalizeString
	} or nil
})

return function(p2)
	local v6 = getRawItemLicensingInfo(p2) or p2

	local licenseType = if type(v6) == "table" then v6.licenseType else nil

	if RunService:IsStudio() and licenseType ~= nil and table.find(v5, licenseType) == nil then
		warn(`Unsupported item licensing type: {tostring(licenseType)}`)
	end

	return (normalizeTableFn(v6))
end
