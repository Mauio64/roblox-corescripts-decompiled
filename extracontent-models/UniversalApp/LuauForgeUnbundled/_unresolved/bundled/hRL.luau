local module = require("@luauforge/bundled/hRM")
local module2 = require("@luauforge/bundled/ggi")
local module3 = require("@luauforge/bundled/fzS")
local module4 = require("@luauforge/bundled/ggp")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableUpdatedLogoutUpsellModal = SharedFlags.FFlagEnableUpdatedLogoutUpsellModal
local fFlagUseSignalsForIsLocalUserUnder13 = SharedFlags.FFlagUseSignalsForIsLocalUserUnder13
local getIsLocalUserUnder13Store

if fFlagUseSignalsForIsLocalUserUnder13 then
	getIsLocalUserUnder13Store = require("@luauforge/bundled/ciE").Stores.GetIsLocalUserUnder13Store
else
	getIsLocalUserUnder13Store = nil
end

return function(p2, p3, p4)
	return function(object)
		local v5 = {
			addEmailOver13TextKey = "Feature.VerificationUpsell.Description.LogoutAddEmailTextOver13",
			addEmailUnder13TextKey = p4.getRenameParentEmailForVerificationUpsell() and "Feature.VerificationUpsell.Description.LogoutAddEmailTextUnder13V2" or "Feature.VerificationUpsell.Description.LogoutAddEmailTextUnder13",
			addEmailTitleKey = "Feature.VerificationUpsell.Heading.VerifyOnLogout",
			updateEmailSecondaryButtonText = "Feature.VerificationUpsell.Action.Logout",
			origin = "logout",
			onUpdateEmailSecondaryButtonPressedEvent = module3.Button.SkipLogOutAnyway,
			onUpdateEmailSecondaryButtonPressed = function()
				object:dispatch(module2(p2, p3, module4.EmailUpsellLogOut))
			end
		}

		local v6 = if fFlagUseSignalsForIsLocalUserUnder13 then getIsLocalUserUnder13Store(false).getIsLocalUserUnder13(false) else object:getState().IsLocalUserUnder13
		v5.emailUpsellLockedIsLocalUserUnder13 = v6

		if fFlagEnableUpdatedLogoutUpsellModal then
			v5.addEmailTitleKey = "Feature.VerificationUpsell.Heading.FinishAccountSetup"
			v5.addEmailUnder13TextKey = "Feature.VerificationUpsell.Description.AddParentalEmail"
			v5.updateEmailPrimaryButtonText = "Feature.VerificationUpsell.Action.Logout"
			v5.useUpdatedModalDesign = true
		end

		return object:dispatch(module(p2, true, v5))
	end
end
