local CorePackages = game:GetService("CorePackages")
local FFlagAXFixDeselectOutfitInManage = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixDeselectOutfitInManage

return game:DefineFastFlag("AEGetEditableOutfitsType2", false) and FFlagAXFixDeselectOutfitInManage
