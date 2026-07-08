local CorePackages = game:GetService("CorePackages")
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {
	"AllowInventoryReadAccess",
	"SaveAvatar",
	"CreateOutfit",
	"EnterOutfitName",
	"SetFavorite",
	"DeleteOutfit",
	"RenameOutfit",
	"UpdateOutfit"
}

if require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE then
	table.insert(t1, "SaveAvatarTimeout")
end

return enumerate("PromptType", t1)
