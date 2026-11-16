local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local RunService = game:GetService("RunService")
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemLicenseType = AvatarExperienceModel.Enums.ItemLicenseType
local normalize = require(script.Parent.normalize)
local getRawItemLicensingInfo = require(script.Parent.getRawItemLicensingInfo)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails

local v = { ItemLicenseType.FirstParty, ItemLicenseType.ThirdParty }

local normalizeTableFn = normalize.makeNormalizeTableFn({
	id = { fn = normalize.normalizeString },
	licenseType = normalize.makeRequired(normalize.makeNormalizeValueFn(v)),
	badgeAssetId = { fn = normalize.normalizeString },
	name = { fn = normalize.normalizeString },
	licenseHolder = { fn = normalize.normalizeString },
	licenseDisplayName = FFlagAXMarketplaceLicensingItemDetails and {
		fn = normalize.normalizeString
	} or nil
})

return function(p)
	local v2 = getRawItemLicensingInfo(p) or p
	local licenseType

	if type(v2) == "table" then
		licenseType = v2.licenseType
	end

	if RunService:IsStudio() and licenseType ~= nil and table.find(v, licenseType) == nil then
		warn(`Unsupported item licensing type: {tostring(licenseType)}`)
	end

	return (normalizeTableFn(v2))
end
