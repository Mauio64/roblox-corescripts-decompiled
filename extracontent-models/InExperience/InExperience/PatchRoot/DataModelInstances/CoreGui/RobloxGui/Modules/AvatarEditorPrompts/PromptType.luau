local CorePackages = game:GetService("CorePackages")
local enumerate = require(CorePackages.Packages.enumerate)

return enumerate("PromptType", {
	"AllowInventoryReadAccess",
	"SaveAvatar",
	"CreateOutfit",
	"EnterOutfitName",
	"SetFavorite",
	"DeleteOutfit",
	"RenameOutfit",
	"UpdateOutfit",
	"SaveAvatarTimeout"
})
