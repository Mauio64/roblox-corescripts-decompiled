local AccountSwitching = script:FindFirstAncestor("AccountSwitching")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")
local AccountSwitchingParent = AccountSwitching.Parent
local FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = require(AccountSwitchingParent.SharedFlags).FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues
local AuthCommon = require(AccountSwitchingParent.AuthCommon)
local NotificationType = require(AccountSwitchingParent.RobloxAppEnums).NotificationType
local AccountSwitcherConstants = AuthCommon.Common.AccountSwitcherConstants
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities

return function(b1: boolean, p1: ((...any) -> ...any), p2: ((...any) -> ...any), b2: boolean) -- line: 15
	-- upvalues: AccountSwitcherConstants (copy), FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues (copy), AppStorageUtilities (copy), AppStorageService (copy), GuiService (copy), NotificationType (copy)
	if b1 then
		p1()

		local AccountSwitcherSwitchedStatus = AccountSwitcherConstants.AccountSwitcherSwitchedStatus

		if FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then
			AccountSwitcherSwitchedStatus = if not b2 then AccountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus else AccountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus
		end

		AppStorageUtilities.setAccountSwitchStatus(AccountSwitcherSwitchedStatus)
		AppStorageService:Flush()
		GuiService:BroadcastNotification("", NotificationType.DID_SWITCH_ACCOUNT)

		return
	end

	p2()
end
