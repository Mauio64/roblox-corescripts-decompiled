local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local Foundation = require(parent.Foundation)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local IconName = Foundation.Enums.IconName

local FFlagAXRemoveOfferBannerIcon = AvatarExperienceFlags.FFlagAXRemoveOfferBannerIcon

local function getFoundationIconName(p: string?)
	local v = p and IconName[p]

	if v then
		return v
	end

	if FFlagAXRemoveOfferBannerIcon then
		return nil
	end

	return IconName.TagSparkle
end

return getFoundationIconName
