local CorePackages = game:GetService("CorePackages")
local Chrome = script:FindFirstAncestor("Chrome")
local Service = require(Chrome.Service)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local registerConnectIntegration = require(script.Parent.registerConnectIntegration)
local isConnectUnibarEnabled = require(script.Parent.isConnectUnibarEnabled)
local isConnectDropdownEnabled = require(script.Parent.isConnectDropdownEnabled)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local FIntSideSheetVariant = require(CorePackages.Workspace.Packages.SharedFlags).FIntSideSheetVariant
local FFlagEnableSideSheet = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSideSheet
local ConnectIconDropdown = require(script.Parent.ConnectIconDropdown)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local v13 = require(CorePackages.Packages.PolicyProvider).GetPolicyImplementations.MemStorageService("app-policy")

local function canAccessParty() -- line: 26
	-- upvalues: UniversalAppPolicy (copy)
	return UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty()
end
local function shouldEnableIntegrationForParty() -- line: 30
	-- upvalues: GetFFlagIsSquadEnabled (copy), UniversalAppPolicy (copy), isConnectDropdownEnabled (copy)
	return GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty() and isConnectDropdownEnabled())
end

local u16 = nil
local u17 = nil
local v18 = FFlagEnableSideSheet and (FIntSideSheetVariant == 0 and ConnectIconDropdown ~= nil)

local function updateConnectIntegration(p1) -- line: 41
	-- upvalues: u16 (ref), registerConnectIntegration (copy), Service (copy), u17 (ref), InExperienceAppChatModal (copy), v18 (copy), ConnectIconDropdown (copy)
	if not u16 then
		u16 = registerConnectIntegration("connect_unibar", if not p1 then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Pinned)
	end

	if not p1 then
		u16.availability:unavailable()

		if u17 then
			u17()
			u17 = nil

			return
		end
	else
		if InExperienceAppChatModal.default.currentSquadId ~= "" then
			u16.availability:pinned()

			if v18 then
				ConnectIconDropdown.availability:unavailable()
			end
		end

		if not u17 then
			local connection = InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2) -- line: 72
				-- upvalues: u16 (ref), v18 (copy), ConnectIconDropdown (copy)
				if p2 == "" then
					u16.availability:unavailable()

					if v18 then
						ConnectIconDropdown.availability:available()

						return
					end
				else
					u16.availability:pinned()

					if v18 then
						ConnectIconDropdown.availability:unavailable()
					end
				end
			end)

			function u17() -- line: 85
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end
	end
end
local function handlePolicyUpdate() -- line: 92
	-- upvalues: updateConnectIntegration (copy), GetFFlagIsSquadEnabled (copy), UniversalAppPolicy (copy), isConnectDropdownEnabled (copy)
	updateConnectIntegration(GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty() and isConnectDropdownEnabled()))
end

if isConnectUnibarEnabled() then
	updateConnectIntegration(GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanAccessParty() and isConnectDropdownEnabled()))
	v13.onPolicyChanged(handlePolicyUpdate)
end

return u16
