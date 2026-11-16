local FFlagAppChatResolveShareLinkV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatResolveShareLinkV2")
local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnablePlusReferralLandingSheet

return game:DefineFastFlag("AppChatPlusReferralAssetCard", false)
	and FFlagAppChatResolveShareLinkV2
	and fFlagEnablePlusReferralLandingSheet
