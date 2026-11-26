local logger = require("@luauforge/bundled/gir").Logger
local module = require("@luauforge/bundled/gis")
local module2 = require("@luauforge/bundled/git")
local module3 = require("@luauforge/bundled/giu")

local handlePasskeyUpsell = require("@luauforge/bundled/giy").HandlePasskeyUpsell
local handleTutorialUpsell = require("@luauforge/bundled/gjp").HandleTutorialUpsell
local handleSilentUpgrade = require("@luauforge/bundled/gjr").HandleSilentUpgrade
local handleNotificationsPermissions = require("@luauforge/bundled/gju").HandleNotificationsPermissions

local fFlagPreHomePageRoutingEnabled = module2.FFlagPreHomePageRoutingEnabled
local fFlagPasskeyUpsellEnabled = module2.FFlagPasskeyUpsellEnabled
local fFlagTutorialUpsellEnabled = module2.FFlagTutorialUpsellEnabled
local fFlagEnableSystemTrayModals = module2.FFlagEnableSystemTrayModals
local fFlagEnablePWManagerSignupCheck = module2.FFlagEnablePWManagerSignupCheck
local didUsePasswordManagerMediatedLogin = module3.Checks.didUsePasswordManagerMediatedLogin
local didUsePasswordManagerMediatedSignup = module3.Checks.didUsePasswordManagerMediatedSignup
local launchContext = require("@luauforge/bundled/giw").Enums.LaunchContext

local function handleUpsellRouting(p2, callback, p3, p4, p5): boolean
	local v5, v6 = callback(p3, p4, p5):andThen(function(p6): boolean
		if p6 then
			logger:info("User is eligible for {} upsell, proceeding with upsell", p2)
			return true
		end

		logger:info("User is not eligible for {} upsell", p2)
		return false
	end):catch(function(p6): boolean
		logger:warning("Error checking {} upsell eligibility: {}", p2, p6)
		return false
	end):await()

	if not v5 then
		logger:warning("Unknown error checking {} upsell eligibility", p2)
		return false
	end

	if v6 then
		return true
	end

	return false
end

local function handlePreHomePageRouting(p2, p3, p4)
	if not (fFlagPreHomePageRoutingEnabled or fFlagPasskeyUpsellEnabled) then
		return module.resolve(false)
	end

	if fFlagEnablePWManagerSignupCheck and didUsePasswordManagerMediatedSignup() then
		handleSilentUpgrade(p2, p3, launchContext.SignUp)
	elseif didUsePasswordManagerMediatedLogin() then
		handleSilentUpgrade(p2, p3)
	elseif
		fFlagPasskeyUpsellEnabled
		and handleUpsellRouting("passkey", handlePasskeyUpsell, p2, p3, p4)
	then
		return module.resolve(true)
	end

	if fFlagTutorialUpsellEnabled and handleUpsellRouting("tutorial", handleTutorialUpsell, p2, p3, p4) then
		return module.resolve(true)
	end

	if
		fFlagEnableSystemTrayModals
		and handleUpsellRouting("notifications", handleNotificationsPermissions, p2, p3, p4)
	then
	end

	return module.resolve(false)
end

return handlePreHomePageRouting
