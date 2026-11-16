local parent = script:FindFirstAncestor("InExperienceTopBar").Parent

local Chrome = require(parent.Chrome)
local Enabled = Chrome.Enabled
local SharedFlags = require(parent.SharedFlags)

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FFlagFixBulkPurchaseTopBarObfuscation = SharedFlags.FFlagFixBulkPurchaseTopBarObfuscation

local CoreGuiCommon = require(parent.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local defineFastFlag = game:DefineFastFlag("TopBarSignalizeSetCores", false)
local defineFastFlag2 = game:DefineFastFlag("TopBarRefactor2", false)
return {
	FFlagExperienceAgeRatingBadge = game:DefineFastFlag("ExperienceAgeRatingBadge2", false),
	FFlagTopBarSignalizeSetCores = defineFastFlag,
	FFlagTopBarRefactor = defineFastFlag2 and FFlagFixBulkPurchaseTopBarObfuscation and Enabled() and FFlagTopBarSignalizeKeepOutAreas and FFlagTopBarSignalizeMenuOpen and FFlagTopBarSignalizeScreenSize and FFlagEnableConsoleExpControls and not FFlagAddUILessMode
}
