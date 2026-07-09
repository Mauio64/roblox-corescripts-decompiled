local PreHomePage = script:FindFirstAncestor("PreHomePage")
local PreHomePageParent = PreHomePage.Parent
local PasskeyUpsell = require(PreHomePageParent.PasskeyUpsell)
local PasskeyCheck = PasskeyUpsell.Utils.PasskeyCheck
local CooldownCheck = PasskeyUpsell.Utils.CooldownCheck
local Logger = require(PreHomePageParent.Loggers).Logger
local LinkingProtocol = require(PreHomePageParent.LinkingProtocol).LinkingProtocol
local AppPage = require(PreHomePageParent.RobloxAppEnums).AppPage
local Promise = require(PreHomePageParent.Promise)
local CredentialsProtocol = require(PreHomePageParent.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = CredentialsProtocol.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local AuthAnalytics = require(PreHomePageParent.AuthAnalytics)
local authPageload = AuthAnalytics.Events.authPageload
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local IXPServiceWrapper = require(PreHomePageParent.IXPServiceWrapper).IXPServiceWrapper
local AppBtidLayers = require(PreHomePageParent.ExperimentLayers).AppBtidLayers
local userJustLoggedIn = require(PreHomePage.Common).Checks.userJustLoggedIn

local function getShouldShowPasskeyUpsell() -- line: 24
	-- upvalues: IXPServiceWrapper (copy), AppBtidLayers (copy)
	return IXPServiceWrapper:GetBTIDLayerData(AppBtidLayers.LoginLayer).shouldShowPasskeyUpsell
end
local function canRegisterPasskey() -- line: 29
	-- upvalues: default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), EventStreamConstants (copy), authPageload (copy), Logger (copy)
	return default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p1) -- line: 32
		-- upvalues: EventStreamConstants (copy), authPageload (copy)
		local CredentialsProtocolAvailable = EventStreamConstants.State.CredentialsProtocolAvailable

		if not p1.isAvailable then
			CredentialsProtocolAvailable = EventStreamConstants.State.CredentialsProtocolNotAvailable
		end

		authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, CredentialsProtocolAvailable)

		return p1.isAvailable
	end):catch(function(p2) -- line: 40
		-- upvalues: Logger (copy)
		Logger:warning("Error checking for available credential types. Error: {}", p2)

		return false
	end)
end
local function handlePasskeyUpsell(p3, p4, p5) -- line: 55
	-- upvalues: LinkingProtocol (copy), Logger (copy), authPageload (copy), EventStreamConstants (copy), Promise (copy), userJustLoggedIn (copy), canRegisterPasskey (copy), IXPServiceWrapper (copy), AppBtidLayers (copy), CooldownCheck (copy), PasskeyCheck (copy), AppPage (copy)
	if LinkingProtocol:getLastLuaURL() ~= nil and LinkingProtocol:getLastLuaURL() ~= "" then
		Logger:info("Skipping passkey upsell due to deep link")
		authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, EventStreamConstants.State.FilteredByDeepLink)

		return Promise.resolve(false)
	end

	if not userJustLoggedIn(p4) then
		Logger:info("Skipping passkey upsell due to not just logged in")
		authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, EventStreamConstants.State.FilteredByCachedLogin)

		return Promise.resolve(false)
	end

	return canRegisterPasskey():andThen(function(p6) -- line: 78
		-- upvalues: Logger (copy), IXPServiceWrapper (copy), AppBtidLayers (copy), authPageload (copy), EventStreamConstants (copy), CooldownCheck (copy), p3 (copy), p4 (copy), PasskeyCheck (copy), Promise (copy), p5 (copy), AppPage (copy)
		if not p6 then
			Logger:info("Skipping passkey upsell due to passkey registration not available")

			return false
		end

		local shouldShowPasskeyUpsell = IXPServiceWrapper:GetBTIDLayerData(AppBtidLayers.LoginLayer).shouldShowPasskeyUpsell

		if not shouldShowPasskeyUpsell then
			authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, EventStreamConstants.State.FilteredByIXP)

			return false
		end

		local v30 = CooldownCheck(p3, p4)
		local v31 = PasskeyCheck(p3)

		return Promise.all({
			v30,
			v31
		}):andThen(function(p7) -- line: 97
			-- upvalues: Logger (copy), authPageload (copy), EventStreamConstants (copy), shouldShowPasskeyUpsell (copy), p4 (copy), p5 (copy), AppPage (copy)
			local v33 = p7[1]
			local v34 = p7[2]

			Logger:info("Parallel passkey upsell calls completed. HasCooldown: {}, HasPasskey: {}", v33, v34)

			if v33 then
				authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, EventStreamConstants.State.FilteredByCooldown)
			end

			if v34 then
				authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, EventStreamConstants.State.FilteredByExistingPasskey)
			end

			if not v33 and not v34 then
				authPageload(EventStreamConstants.Context.HandlePreHomePageRouting, EventStreamConstants.State.ShouldSeePasskeyUpsell)

				if shouldShowPasskeyUpsell then
					Logger:info("User has no cooldown and no passkey, routing to upsell screen.")
					p4:dispatch(p5({{
						name = AppPage.PasskeyUpsellScreen,
						extraProps = {
							resetNavigationHistory = p5
						}
					}}))

					return true
				end
			end

			return false
		end, function(p8) -- line: 135
			-- upvalues: Logger (copy)
			Logger:debug("Error checking for passkey: {}", p8)

			return false
		end)
	end)
end

return handlePasskeyUpsell
