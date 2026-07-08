local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local LuaSocialLibrariesDeps = require(ProfileQRCodeParent.LuaSocialLibrariesDeps)
local RODUX_KEY = require(ProfileQRCode.Common.Constants).RODUX_KEY

return LuaSocialLibrariesDeps.RoduxUsers.config({
	keyPath = RODUX_KEY .. ".Users"
})
