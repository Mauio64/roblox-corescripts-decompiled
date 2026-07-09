local PreHomePage = script:FindFirstAncestor("PreHomePage")
local PreHomePageParent = PreHomePage.Parent
local Logger = require(PreHomePageParent.Loggers).Logger
local Promise = require(PreHomePageParent.Promise)
local SharedFlags = require(PreHomePageParent.SharedFlags)
local Common = require(PreHomePage.Common)
local HandlePasskeyUpsell = require(PreHomePage.Routes.PasskeyUpsell).HandlePasskeyUpsell
local HandleTutorialUpsell = require(PreHomePage.Routes.TutorialUpsell).HandleTutorialUpsell
local HandleSilentUpgrade = require(PreHomePage.Routes.SilentUpgrade).HandleSilentUpgrade
local HandleNotificationsPermissions = require(PreHomePage.Routes.Notifications).HandleNotificationsPermissions
local FFlagPreHomePageRoutingEnabled = SharedFlags.FFlagPreHomePageRoutingEnabled
local FFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local FFlagPasskeySilentUpgradeEnabled = SharedFlags.FFlagPasskeySilentUpgradeEnabled
local FFlagTutorialUpsellEnabled = SharedFlags.FFlagTutorialUpsellEnabled
local FFlagEnableSystemTrayModals = SharedFlags.FFlagEnableSystemTrayModals
local FFlagEnablePWManagerSignupCheck = SharedFlags.FFlagEnablePWManagerSignupCheck
local didUsePasswordManagerMediatedLogin = Common.Checks.didUsePasswordManagerMediatedLogin
local didUsePasswordManagerMediatedSignup = Common.Checks.didUsePasswordManagerMediatedSignup
local LaunchContext = require(PreHomePageParent.AppStartup).Enums.LaunchContext

local function handleUpsellRouting(p1, p2, p3, p4, p5) -- line: 42
	-- upvalues: Logger (copy)
	local v27, v28 = p2(p3, p4, p5):andThen(function(p6) -- line: 44
		-- upvalues: Logger (copy), p1 (copy)
		if p6 then
			Logger:info("User is eligible for {} upsell, proceeding with upsell", p1)

			return true
		end

		Logger:info("User is not eligible for {} upsell", p1)

		return false
	end):catch(function(p7) -- line: 53
		-- upvalues: Logger (copy), p1 (copy)
		Logger:warning("Error checking {} upsell eligibility: {}", p1, p7)

		return false
	end):await()

	if not v27 then
		Logger:warning("Unknown error checking {} upsell eligibility", p1)

		return false
	end

	if v28 then
		return true
	end

	return false
end
local function handlePreHomePageRouting(p8, p9, p10) -- line: 80
	-- upvalues: FFlagPreHomePageRoutingEnabled (copy), FFlagPasskeyUpsellEnabled (copy), Promise (copy), FFlagEnablePWManagerSignupCheck (copy), didUsePasswordManagerMediatedSignup (copy), HandleSilentUpgrade (copy), LaunchContext (copy), didUsePasswordManagerMediatedLogin (copy), FFlagPasskeySilentUpgradeEnabled (copy), handleUpsellRouting (copy), HandlePasskeyUpsell (copy), FFlagTutorialUpsellEnabled (copy), HandleTutorialUpsell (copy), FFlagEnableSystemTrayModals (copy), HandleNotificationsPermissions (copy)
	if not FFlagPreHomePageRoutingEnabled and not FFlagPasskeyUpsellEnabled then
		return Promise.resolve(false)
	end

	if FFlagEnablePWManagerSignupCheck and didUsePasswordManagerMediatedSignup() then
		HandleSilentUpgrade(p8, p9, LaunchContext.SignUp)
	elseif didUsePasswordManagerMediatedLogin() then
		if FFlagPasskeySilentUpgradeEnabled then
			HandleSilentUpgrade(p8, p9)
		end
	elseif FFlagPasskeyUpsellEnabled and handleUpsellRouting("passkey", HandlePasskeyUpsell, p8, p9, p10) then
		return Promise.resolve(true)
	end

	if FFlagTutorialUpsellEnabled and handleUpsellRouting("tutorial", HandleTutorialUpsell, p8, p9, p10) then
		return Promise.resolve(true)
	end

	if FFlagEnableSystemTrayModals and handleUpsellRouting("notifications", HandleNotificationsPermissions, p8, p9, p10) then
		return Promise.resolve(false)
	end

	return Promise.resolve(false)
end

return handlePreHomePageRouting
