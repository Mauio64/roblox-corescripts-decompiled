local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local module2 = require("@luauforge/bundled/guy")

local module3 = require("@luauforge/bundled/guA")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableAccountSwitchSsoLogin = SharedFlags.FFlagEnableAccountSwitchSsoLogin
local fFlagEnableAccountSwitcherExternalIdentityButtons = SharedFlags.FFlagEnableAccountSwitcherExternalIdentityButtons

local appStorageUtilities = AuthCommon.Utils.AppStorageUtilities

local v5 = nil
local owner = nil
local v6 = nil

local function getOwner()
	assert(owner, "SharedExternalIdentityClient used before a session owner was set")
	return owner
end

local function getOrCreateClient()
	if v5 ~= nil then
		return v5
	end

	local v7 = module2.create({
		requests = module2.createRequests(nil, nil, {
			usesBrowserSignIn = function()
				assert(owner, "SharedExternalIdentityClient used before a session owner was set")

				return owner.isBrowserSignInEnabled()
			end
		}),
		completeSession = function()
			if not fFlagEnableAccountSwitcherExternalIdentityButtons then
				assert(owner, "SharedExternalIdentityClient used before a session owner was set")

				return owner.completeSession()
			end

			local v8 = v6
			v6 = nil
			assert(owner, "SharedExternalIdentityClient used before a session owner was set")

			return owner.completeSession(v8)
		end,
		redeemTicket = function(p2)
			v6 = nil
			local redeemAuthenticationTicket = AuthCommon.Http.Requests.RedeemAuthenticationTicket
			assert(owner, "SharedExternalIdentityClient used before a session owner was set")

			local v8 = redeemAuthenticationTicket(owner.getNetworking(), p2)

			if fFlagEnableAccountSwitcherExternalIdentityButtons then
				v8 = v8:andThen(function(p3)
					v6 = if p3.responseBody then p3.responseBody.accountBlob else nil
					return p3
				end)
			end

			if module3 or fFlagEnableAccountSwitchSsoLogin then
				return v8:andThen(function(p3)
					local accountBlob = if p3.responseBody then p3.responseBody.accountBlob else nil

					if accountBlob then
						appStorageUtilities.setAccountBlob(accountBlob)
						appStorageUtilities.flush()
					end

					return p3
				end)
			end

			return v8
		end
	})

	v5 = v7
	return v7
end

local function getCapabilitiesAsync()
	return getOrCreateClient().getCapabilitiesAsync()
end

local v7 = {
	acquire = function(p2)
		owner = p2
		return getOrCreateClient()
	end,
	getCapabilitiesAsync = 0
}

if not fFlagEnableAccountSwitcherExternalIdentityButtons then
	getCapabilitiesAsync = nil
end

v7.getCapabilitiesAsync = getCapabilitiesAsync
return v7
