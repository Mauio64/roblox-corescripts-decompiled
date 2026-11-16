local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local Signals = require(Packages.Signals)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagExpChatGuacChatDisabledReason = SharedFlags.GetFFlagExpChatGuacChatDisabledReason
local FFlagExpChatWindowSyncUnibar = SharedFlags.FFlagExpChatWindowSyncUnibar
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell

local defineFastFlag = game:DefineFastFlag("ExpChatOnShowIconChatAvailabilityStatus", false)
local getChatStatusStore

if defineFastFlag then
	local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
	getChatStatusStore = ExpChat.Stores.GetChatStatusStore
end

local UniversalAppPolicy

if GetFFlagExpChatGuacChatDisabledReason() then
	UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
else
	UniversalAppPolicy = nil
end

local function new(p)
	local signal, setCoreGuiEnabled = Signals.createSignal(true)
	local signal2, setLocalUserChat = Signals.createSignal(false)
	local signal3, setChatActiveCalledByDeveloper = Signals.createSignal(false)
	local signal4, setVisibleViaChatSelector = Signals.createSignal(false)
	local v, setGameSettingsChatVisible

	if FFlagExpChatWindowSyncUnibar then
		v, setGameSettingsChatVisible = Signals.createSignal(false)
	else
		v = nil
	end

	local v2

	if GetFFlagExpChatGuacChatDisabledReason() and UniversalAppPolicy then
		v2 = UniversalAppPolicy.getAppFeaturePolicies().getExperienceChatAvailability() == "regionLocked"
	else
		v2 = false
	end

	local v3 = FFlagEnableAEGIS2CommsFAEUpsell and defineFastFlag
	local getIsChatIconVisible = Signals.createComputed(function(p2): boolean
		if not signal(p2) then
			return false
		end

		if
			not v3 and signal2(p2)
			or not FFlagExpChatWindowSyncUnibar and signal4(p2)
			or not FFlagExpChatWindowSyncUnibar and signal3(p2)
		then
			return true
		end

		if
			FFlagExpChatWindowSyncUnibar and v(p2)
			or v3 and p.getChatStatus(p2) ~= "NoOne"
			or GetFFlagExpChatGuacChatDisabledReason() and v2
		then
			return true
		end

		return false
	end)
	local getIsChatWindowVisible

	if FFlagExpChatWindowSyncUnibar then
		getIsChatWindowVisible = Signals.createComputed(function(p2): boolean
			if getIsChatIconVisible(p2) and v(p2) then
				return true
			end

			return false
		end)
	end

	return {
		getIsChatIconVisible = getIsChatIconVisible,
		getIsChatWindowVisible = getIsChatWindowVisible,
		setCoreGuiEnabled = setCoreGuiEnabled,
		setLocalUserChat = setLocalUserChat,
		setChatActiveCalledByDeveloper = setChatActiveCalledByDeveloper,
		setVisibleViaChatSelector = setVisibleViaChatSelector,
		setGameSettingsChatVisible = setGameSettingsChatVisible
	}
end

local v

if defineFastFlag then
	v = getChatStatusStore(false)
end

return { new = new, default = new(v) }
