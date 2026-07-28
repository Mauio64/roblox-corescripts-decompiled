local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.enumerate)("PromptType", {
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
