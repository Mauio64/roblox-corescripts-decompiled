local fFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpV2Wizard

local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlusReferralLandingSheet

game:DefineFastString("PlusSubscribeDeepLinkPrefix", "roblox://navigation/plus_subscribe")
game:DefineFastString("ContactsDeepLinkPrefix", "roblox://navigation/contacts")
game:DefineFastString("AppealsPortalPrefix", "roblox://navigation/appeals")
game:DefineFastString("SecurityAlertDeepLinkPrefix", "roblox://navigation/security_alert")
game:DefineFastString("SortDeeplinkPrefix", "roblox://navigation/experience_sort")
game:DefineFastString("AmpWizardDeepLinkPrefix", "roblox://navigation/amp_wizard")
game:DefineFastString("SearchDeepLinkPrefix", "roblox://navigation/search")
game:DefineFastString("NotificationSettingsDeepLinkPrefix", "roblox://navigation/notification_settings")

local fastString = game:GetFastString("ContactsDeepLinkPrefix")
local fastString2 = game:GetFastString("AppealsPortalPrefix")
local fastString3 = game:GetFastString("SecurityAlertDeepLinkPrefix")
local fastString4 = game:GetFastString("SortDeeplinkPrefix")
local fastString5 = game:GetFastString("AmpWizardDeepLinkPrefix")
local fastString6 = game:GetFastString("SearchDeepLinkPrefix")
local fastString7 = game:GetFastString("NotificationSettingsDeepLinkPrefix")

local v7 = if fFlagEnablePlusReferralLandingSheet then game:GetFastString("PlusSubscribeDeepLinkPrefix") else nil
return {
	fastString,
	fastString2,
	fastString3,
	fastString4,
	fastString5,
	fastString6,
	fastString7,
	fFlagEnableAmpV2Wizard and "roblox://navigation/odp_checkpoint_resume" or nil,
	v7
}
