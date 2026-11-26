local module = require("@luauforge/bundled/giA")
local passkeyCheck = module.Utils.PasskeyCheck
local cooldownCheck = module.Utils.CooldownCheck
local logger = require("@luauforge/bundled/gir").Logger
local linkingProtocol = require("@luauforge/bundled/gjj").LinkingProtocol
local appPage = require("@luauforge/bundled/gjk").AppPage
local module2 = require("@luauforge/bundled/gis")
local module3 = require("@luauforge/bundled/gjl")
local default = module3.CredentialsProtocol.default

local getFIntLuaAppCredentialsProtocolAvailableTimeout = module3.Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local module4 = require("@luauforge/bundled/gjm")
local authPageload = module4.Events.authPageload
local eventStreamConstants = module4.EventStreamConstants
local ixpServiceWrapper = require("@luauforge/bundled/gjn").IXPServiceWrapper
local appBtidLayers = require("@luauforge/bundled/gjo").AppBtidLayers

local userJustLoggedIn = require("@luauforge/bundled/giu").Checks.userJustLoggedIn

local function getShouldShowPasskeyUpsell()
	return ixpServiceWrapper:GetBTIDLayerData(appBtidLayers.LoginLayer).shouldShowPasskeyUpsell
end

local function canRegisterPasskey()
	return default:isAvailable(
		default.CredentialsTypes.FIDO2,
		getFIntLuaAppCredentialsProtocolAvailableTimeout()
	):andThen(function(p2)
		local v5 = eventStreamConstants.State.CredentialsProtocolAvailable

		if not p2.isAvailable then
			v5 = eventStreamConstants.State.CredentialsProtocolNotAvailable
		end

		authPageload(eventStreamConstants.Context.HandlePreHomePageRouting, v5)
		return p2.isAvailable
	end):catch(function(p2): boolean
		logger:warning("Error checking for available credential types. Error: {}", p2)
		return false
	end)
end

local function handlePasskeyUpsell(p2, object, callback)
	local v5 = not (linkingProtocol:getLastLuaURL() == nil) and linkingProtocol:getLastLuaURL() ~= ""

	if v5 then
		logger:info("Skipping passkey upsell due to deep link")
		authPageload(
			eventStreamConstants.Context.HandlePreHomePageRouting,
			eventStreamConstants.State.FilteredByDeepLink
		)
	else
		if userJustLoggedIn(object) then
			return canRegisterPasskey():andThen(function(p3)
				if not p3 then
					logger:info("Skipping passkey upsell due to passkey registration not available")
					return false
				end

				local shouldShowPasskeyUpsell = ixpServiceWrapper:GetBTIDLayerData(appBtidLayers.LoginLayer).shouldShowPasskeyUpsell

				if shouldShowPasskeyUpsell then
					local v6 = { cooldownCheck(p2, object), (passkeyCheck(p2)) }
					return module2.all(v6):andThen(function(list): boolean
						local item = list[1]
						local item2 = list[2]
						logger:info(
							"Parallel passkey upsell calls completed. HasCooldown: {}, HasPasskey: {}",
							item,
							item2
						)

						if item then
							authPageload(
								eventStreamConstants.Context.HandlePreHomePageRouting,
								eventStreamConstants.State.FilteredByCooldown
							)
						end

						if item2 then
							authPageload(
								eventStreamConstants.Context.HandlePreHomePageRouting,
								eventStreamConstants.State.FilteredByExistingPasskey
							)
						end

						if item or item2 then
							return false
						end

						authPageload(
							eventStreamConstants.Context.HandlePreHomePageRouting,
							eventStreamConstants.State.ShouldSeePasskeyUpsell
						)

						if shouldShowPasskeyUpsell then
							logger:info("User has no cooldown and no passkey, routing to upsell screen.")
							object:dispatch(callback({
								{
									name = appPage.PasskeyUpsellScreen,
									extraProps = { resetNavigationHistory = callback }
								}
							}))

							return true
						end

						return false
					end, function(p4): boolean
						logger:debug("Error checking for passkey: {}", p4)
						return false
					end)
				end

				authPageload(
					eventStreamConstants.Context.HandlePreHomePageRouting,
					eventStreamConstants.State.FilteredByIXP
				)

				return false
			end)
		end

		logger:info("Skipping passkey upsell due to not just logged in")
		authPageload(
			eventStreamConstants.Context.HandlePreHomePageRouting,
			eventStreamConstants.State.FilteredByCachedLogin
		)
	end

	return module2.resolve(false)
end

return handlePasskeyUpsell
