local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

if not require(CorePackages.Workspace.Packages.Chrome).Enabled() then
	return nil
end

local Service = require(Chrome.Service)
local Constants = require(Chrome.Integrations.Party.Constants)
local isConnectUnibarEnabled = require(Chrome.Integrations.Connect.isConnectUnibarEnabled)
local isConnectDropdownEnabled = require(Chrome.Integrations.Connect.isConnectDropdownEnabled)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local ConfigureShortcuts = require(Chrome.ChromeShared.Shortcuts.ConfigureShortcuts)
local Constants2 = require(Chrome.ChromeShared.Unibar.Constants)
local buildMenuOrder = require(Chrome.ChromeShared.Unibar.buildMenuOrder)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDebugEnableUnibarDummyIntegrations = SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagEnableInExperienceAvatarSwitcher = SharedFlags.FFlagEnableInExperienceAvatarSwitcher
local FFlagAddMapToNineDot = SharedFlags.FFlagAddMapToNineDot
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagReverseUnibar = require(Chrome.Flags.FFlagReverseUnibar)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial

local function initializeIntegrations() -- line: 35
	-- upvalues: Chrome (copy)
	require(Chrome.Integrations)
end
local function configureUnibar() -- line: 43
	-- upvalues: FFlagAddMapToNineDot (copy), buildMenuOrder (copy), isConnectDropdownEnabled (copy), FFlagRemoveFriendsChatUnibarEntrypoints (copy), FFlagExpChatEnableFriendsTab (copy), ArgoPartyExperimentation (copy), FFlagReverseUnibar (copy), GetFFlagDebugEnableUnibarDummyIntegrations (copy), isConnectUnibarEnabled (copy), Constants (copy), FFlagAppNavMyStatsTab (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), Service (copy), FFlagEnableInExperienceAvatarSwitcher (copy), Constants2 (copy), GuiService (copy), FFlagEnableInExperienceShop (copy)
	local v26

	if FFlagAddMapToNineDot then
		v26 = buildMenuOrder()
	else
		v26 = {
			"leaderboard",
			"emotes",
			"backpack"
		}
		table.insert(v26, "respawn")
		table.insert(v26, 1, "trust_and_safety")

		if isConnectDropdownEnabled() and (not FFlagRemoveFriendsChatUnibarEntrypoints or not FFlagExpChatEnableFriendsTab or not ArgoPartyExperimentation.getIsRenameEnabled()) then
			table.insert(v26, 1, "connect_dropdown")
		end
	end

	local t1 = {
		"nine_dot",
		"chat",
		"toggle_mic_mute"
	}

	if FFlagReverseUnibar then
		table.insert(t1, 3, "join_voice")

		if GetFFlagDebugEnableUnibarDummyIntegrations() then
			table.insert(t1, "dummy_window")
			table.insert(t1, "dummy_window_2")
		end

		if isConnectUnibarEnabled() then
			table.insert(t1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
		end

		local v28 = table.find(t1, "toggle_mic_mute")

		if v28 then
			table.insert(t1, v28, Constants.TOGGLE_MIC_INTEGRATION_ID)
		end
	else
		t1 = {
			"toggle_mic_mute",
			"chat",
			"nine_dot"
		}
		table.insert(t1, 2, "join_voice")

		if GetFFlagDebugEnableUnibarDummyIntegrations() then
			table.insert(t1, 1, "dummy_window")
			table.insert(t1, 1, "dummy_window_2")
		end

		if isConnectUnibarEnabled() then
			table.insert(t1, 1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
		end

		local v29 = table.find(t1, "toggle_mic_mute")

		if v29 then
			table.insert(t1, v29 + 1, Constants.TOGGLE_MIC_INTEGRATION_ID)
		end
	end

	if FFlagAppNavMyStatsTab then
		table.insert(t1, "assistant_build")
	end

	if isInExperienceUIVREnabled and isSpatial() then
		Service:configureMenu({
			{
				"vr_toggle_button",
				"vr_safety_bubble"
			},
			t1
		})
	else
		Service:configureMenu({ t1 })
	end

	if not FFlagAddMapToNineDot then
		if isInExperienceUIVREnabled then
			if not isSpatial() then
				table.insert(v26, 2, "camera_entrypoint")
				table.insert(v26, 2, "selfie_view")
			end
		else
			table.insert(v26, 2, "camera_entrypoint")
			table.insert(v26, 2, "selfie_view")
		end

		if FFlagEnableInExperienceAvatarSwitcher then
			table.insert(v26, 3, Constants2.AVATAR_SWITCHER_ID)
		end

		if not isSpatial() and not GuiService:IsTenFootInterface() then
			table.insert(v26, 4, "music_entrypoint")
		end

		if FFlagEnableInExperienceShop then
			table.insert(v26, 2, Constants2.IN_EXPERIENCE_SHOP_ID)
		end
	end

	Service:configureSubMenu("nine_dot", v26)
end

require(Chrome.Integrations)

if FFlagEnableConsoleExpControls then
	ConfigureShortcuts()
end

configureUnibar()

return nil
