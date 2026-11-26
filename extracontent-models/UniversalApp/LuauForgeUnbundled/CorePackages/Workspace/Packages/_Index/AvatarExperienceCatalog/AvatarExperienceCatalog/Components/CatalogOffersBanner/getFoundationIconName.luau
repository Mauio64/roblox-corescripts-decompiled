local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local iconName = Foundation.Enums.IconName

local fFlagAXRemoveOfferBannerIcon = AvatarExperienceFlags.FFlagAXRemoveOfferBannerIcon

local function getFoundationIconName(p2)
	local v5 = p2 and iconName[p2]

	if v5 then
		return v5
	end

	if fFlagAXRemoveOfferBannerIcon then
		return nil
	end

	return iconName.TagSparkle
end

return getFoundationIconName
