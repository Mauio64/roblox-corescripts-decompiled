local CorePackages = game:GetService("CorePackages")
local Chrome = script:FindFirstAncestor("Chrome")
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local PolicyProvider = require(CorePackages.Packages.PolicyProvider)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local registerPartyIntegration = require(script.Parent.registerPartyIntegration)
local Service = require(Chrome.Service)
local isConnectUnibarEnabled = require(Chrome.Integrations.Connect.isConnectUnibarEnabled)
local isConnectDropdownEnabled = require(Chrome.Integrations.Connect.isConnectDropdownEnabled)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local v11 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")

local function canAccessParty() -- line: 18
	-- upvalues: UniversalAppPolicy (copy)
	return UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty()
end
local function shouldEnableIntegrationForParty() -- line: 22
	-- upvalues: GetFFlagIsSquadEnabled (copy), UniversalAppPolicy (copy), isConnectDropdownEnabled (copy)
	return GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty() and isConnectDropdownEnabled())
end

local u14 = nil
local u15 = nil

local function updatePartyIntegration(p1) -- line: 29
	-- upvalues: u14 (ref), registerPartyIntegration (copy), Service (copy), u15 (ref), InExperienceAppChatModal (copy)
	if not u14 then
		u14 = registerPartyIntegration("party_entrypoint", if not p1 then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Pinned)
	end

	if not p1 then
		u14.availability:unavailable()

		if u15 then
			u15()
			u15 = nil

			return
		end
	else
		if InExperienceAppChatModal.default.currentSquadId ~= "" then
			u14.availability:pinned()
		end

		if not u15 then
			local connection = InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2) -- line: 55
				-- upvalues: u14 (ref)
				if p2 == "" then
					u14.availability:unavailable()

					return
				end

				u14.availability:pinned()
			end)

			function u15() -- line: 62
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end
	end
end
local function handlePolicyUpdate() -- line: 69
	-- upvalues: updatePartyIntegration (copy), GetFFlagIsSquadEnabled (copy), UniversalAppPolicy (copy), isConnectDropdownEnabled (copy)
	updatePartyIntegration(GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty() and isConnectDropdownEnabled()))
end

if isConnectUnibarEnabled() then
	updatePartyIntegration(GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty() and isConnectDropdownEnabled()))
	v11.onPolicyChanged(handlePolicyUpdate)
end

return u14
