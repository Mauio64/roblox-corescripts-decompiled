local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module = require("@luauforge/bundled/dPt")
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local avatarEditorCategories = module.Enums.AvatarEditorCategories

local module2 = require("@luauforge/bundled/dRz")

local joined = nil

local function getPhotoboothMomentsBackgroundsCategory()
	if joined then
		return joined
	end

	for k, v5 in module2() do
		if v5.Id == avatarEditorCategories.Backgrounds then
			joined = Cryo.Dictionary.join(v5, { SearchUuid = searchUuid() })
			break
		end
	end

	return joined
end

return getPhotoboothMomentsBackgroundsCategory
