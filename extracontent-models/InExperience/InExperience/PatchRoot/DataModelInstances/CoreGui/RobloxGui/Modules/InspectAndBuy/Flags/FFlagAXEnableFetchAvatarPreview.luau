local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
return SharedFlags.FFlagEnableInspectAndBuyV2RootFlag and game:DefineFastFlag("AXEnableFetchAvatarPreview9", false)
