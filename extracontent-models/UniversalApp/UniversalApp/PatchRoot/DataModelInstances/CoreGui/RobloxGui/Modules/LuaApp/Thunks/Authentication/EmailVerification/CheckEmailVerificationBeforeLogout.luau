local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CheckEmailVerification = require(Modules.LuaApp.Thunks.Authentication.EmailVerification.CheckEmailVerification)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local CorePackages = game:GetService("CorePackages")
local FFlagEnableUpdatedLogoutUpsellModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUpdatedLogoutUpsellModal

return function(p1, p2, p3) -- line: 14
	-- upvalues: EventStreamConstants (copy), Logout (copy), luaLogoutReasonNames (copy), FFlagEnableUpdatedLogoutUpsellModal (copy), CheckEmailVerification (copy)
	return function(p4) -- line: 15
		-- upvalues: p3 (copy), EventStreamConstants (copy), Logout (copy), p1 (copy), p2 (copy), luaLogoutReasonNames (copy), FFlagEnableUpdatedLogoutUpsellModal (copy), CheckEmailVerification (copy)
		local t1 = {
			addEmailOver13TextKey = "Feature.VerificationUpsell.Description.LogoutAddEmailTextOver13",
			addEmailTitleKey = "Feature.VerificationUpsell.Heading.VerifyOnLogout",
			updateEmailSecondaryButtonText = "Feature.VerificationUpsell.Action.Logout",
			origin = "logout",
			addEmailUnder13TextKey = not p3.getRenameParentEmailForVerificationUpsell() and "Feature.VerificationUpsell.Description.LogoutAddEmailTextUnder13" or "Feature.VerificationUpsell.Description.LogoutAddEmailTextUnder13V2",
			onUpdateEmailSecondaryButtonPressedEvent = EventStreamConstants.Button.SkipLogOutAnyway,
			onUpdateEmailSecondaryButtonPressed = function() -- line: 25
				-- upvalues: p4 (copy), Logout (copy), p1 (copy), p2 (copy), luaLogoutReasonNames (copy)
				p4:dispatch(Logout(p1, p2, luaLogoutReasonNames.EmailUpsellLogOut))
			end,
			emailUpsellLockedIsLocalUserUnder13 = p4:getState().IsLocalUserUnder13
		}

		if FFlagEnableUpdatedLogoutUpsellModal then
			t1.addEmailTitleKey = "Feature.VerificationUpsell.Heading.FinishAccountSetup"
			t1.addEmailUnder13TextKey = "Feature.VerificationUpsell.Description.AddParentalEmail"
			t1.updateEmailPrimaryButtonText = "Feature.VerificationUpsell.Action.Logout"
			t1.useUpdatedModalDesign = true
		end

		return p4:dispatch(CheckEmailVerification(p1, true, t1))
	end
end
