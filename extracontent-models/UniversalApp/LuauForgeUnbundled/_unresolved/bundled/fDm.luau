local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")

local fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues = require("@luauforge/bundled/fDj").FFlagLuaEnableLoginAndSignupDifferentiatedStatusValues

local module = require("@luauforge/bundled/fCO")
local notificationType = require("@luauforge/bundled/fDf").NotificationType
local accountSwitcherConstants = module.Common.AccountSwitcherConstants
local appStorageUtilities = module.Utils.AppStorageUtilities

return function(p2, callback, callback2, p3)
	if not p2 then
		callback2()

		return
	end

	callback()
	local v5 = accountSwitcherConstants.AccountSwitcherSwitchedStatus

	if fFlagLuaEnableLoginAndSignupDifferentiatedStatusValues then
		if p3 then
			v5 = accountSwitcherConstants.AccountSwitcherSwitchedFromSignupStatus
		else
			v5 = accountSwitcherConstants.AccountSwitcherSwitchedFromLoginStatus
		end
	end

	appStorageUtilities.setAccountSwitchStatus(v5)
	AppStorageService:Flush()
	GuiService:BroadcastNotification("", notificationType.DID_SWITCH_ACCOUNT)
end
