local FFlagLuaAppEdpMediaGalleryRedesign = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryRedesign")
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagLuaAppEdpMediaGalleryVideoPreviewIxp")

return FFlagLuaAppEdpMediaGalleryRedesign and (game:DefineFastFlag("LuaAppEdpMediaGalleryVideoPreview5", false) or FFlagLuaAppEdpMediaGalleryVideoPreviewIxp)
