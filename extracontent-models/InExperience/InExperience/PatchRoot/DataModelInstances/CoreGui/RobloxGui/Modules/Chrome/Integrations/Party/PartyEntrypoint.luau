local CorePackages = game:GetService("CorePackages")
local Chrome = script:FindFirstAncestor("Chrome")

local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

local registerPartyIntegration = require(script.Parent.registerPartyIntegration)

local Service = require(Chrome.Service)
local isConnectUnibarEnabled = require(Chrome.Integrations.Connect.isConnectUnibarEnabled)
local isConnectDropdownEnabled = require(Chrome.Integrations.Connect.isConnectDropdownEnabled)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")

local function canAccessParty() -- 1 equivalent call inferred from this helper
	return UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty()
end

local function shouldEnableIntegrationForParty() -- 1 equivalent call inferred from this helper
	return GetFFlagIsSquadEnabled() and canAccessParty() and isConnectDropdownEnabled() -- inferred equivalent call
end

local v = nil
local fn = nil

local function updatePartyIntegration(p)
	if not v then
		local v2

		if p then
			v2 = Service.AvailabilitySignal.Pinned
		else
			v2 = Service.AvailabilitySignal.Unavailable
		end

		v = registerPartyIntegration("party_entrypoint", v2)
	end

	if p then
		if InExperienceAppChatModal.default.currentSquadId ~= "" then
			v.availability:pinned()
		end

		if not fn then
			local eventConnection = InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2)
				if p2 == "" then
					v.availability:unavailable()
				else
					v.availability:pinned()
				end
			end)
			fn = function()
				eventConnection:Disconnect()
			end
		end
	else
		v.availability:unavailable()

		if fn then
			fn()
			fn = nil
		end
	end
end

local function handlePolicyUpdate() -- 1 equivalent call inferred from this helper
	updatePartyIntegration(shouldEnableIntegrationForParty()) -- inferred equivalent call
end

if isConnectUnibarEnabled() then
	handlePolicyUpdate() -- inferred equivalent call
	memStorageService.onPolicyChanged(handlePolicyUpdate)
end

return v
