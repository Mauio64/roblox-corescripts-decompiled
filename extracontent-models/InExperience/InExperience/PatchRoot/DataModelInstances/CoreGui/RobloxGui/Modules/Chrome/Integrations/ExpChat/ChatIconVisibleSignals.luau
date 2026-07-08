local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local Signals = require(Packages.Signals)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagExpChatGuacChatDisabledReason = SharedFlags.GetFFlagExpChatGuacChatDisabledReason
local FFlagExpChatWindowSyncUnibar = SharedFlags.FFlagExpChatWindowSyncUnibar
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell
local v8 = game:DefineFastFlag("ExpChatOnShowIconChatAvailabilityStatus", false)
local GetChatStatusStore = nil

if v8 then
	GetChatStatusStore = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetChatStatusStore
end

local UniversalAppPolicy = nil

if GetFFlagExpChatGuacChatDisabledReason() then
	UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
end

local function new(p1) -- line: 23
	-- upvalues: Signals (copy), FFlagExpChatWindowSyncUnibar (copy), GetFFlagExpChatGuacChatDisabledReason (copy), UniversalAppPolicy (ref), FFlagEnableAEGIS2CommsFAEUpsell (copy), v8 (copy)
	local v13, v14 = Signals.createSignal(true)
	local v15, v16 = Signals.createSignal(false)
	local v17, v18 = Signals.createSignal(false)
	local v19, v20 = Signals.createSignal(false)
	local u21 = nil
	local v22 = nil

	if FFlagExpChatWindowSyncUnibar then
		local v23

		v23, v22 = Signals.createSignal(false)
		u21 = v23
	end

	local u24 = false

	if GetFFlagExpChatGuacChatDisabledReason() and UniversalAppPolicy then
		u24 = UniversalAppPolicy.getAppFeaturePolicies().getExperienceChatAvailability() == "regionLocked"
	end

	local v25 = FFlagEnableAEGIS2CommsFAEUpsell and v8
	local v26 = Signals.createComputed(function(p2) -- line: 41
		-- upvalues: v13 (copy), v25 (copy), v15 (copy), FFlagExpChatWindowSyncUnibar (copy), v19 (copy), v17 (copy), u21 (ref), p1 (copy), GetFFlagExpChatGuacChatDisabledReason (copy), u24 (ref)
		if not v13(p2) then
			return false
		end

		if not v25 and v15(p2) then
			return true
		end

		if not FFlagExpChatWindowSyncUnibar and v19(p2) then
			return true
		end

		if not FFlagExpChatWindowSyncUnibar and v17(p2) then
			return true
		end

		if FFlagExpChatWindowSyncUnibar and u21(p2) then
			return true
		end

		if v25 and p1.getChatStatus(p2) ~= "NoOne" then
			return true
		end

		if GetFFlagExpChatGuacChatDisabledReason() and u24 then
			return true
		end

		return false
	end)
	local v27 = nil

	if FFlagExpChatWindowSyncUnibar then
		v27 = Signals.createComputed(function(p3) -- line: 73
			-- upvalues: v26 (copy), u21 (ref)
			if v26(p3) and u21(p3) then
				return true
			end

			return false
		end)
	end

	return {
		getIsChatIconVisible = v26,
		getIsChatWindowVisible = v27,
		setCoreGuiEnabled = v14,
		setLocalUserChat = v16,
		setChatActiveCalledByDeveloper = v18,
		setVisibleViaChatSelector = v20,
		setGameSettingsChatVisible = v22
	}
end

return {
	new = new,
	default = new(if not v8 then nil else GetChatStatusStore(false))
}
