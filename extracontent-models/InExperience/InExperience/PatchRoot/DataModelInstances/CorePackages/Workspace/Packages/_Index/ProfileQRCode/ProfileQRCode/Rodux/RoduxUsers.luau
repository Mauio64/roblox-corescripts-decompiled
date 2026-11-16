local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local Constants = require(ProfileQRCode.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

return LuaSocialLibrariesDeps.RoduxUsers.config({
	keyPath = RODUX_KEY .. ".Users"
})
