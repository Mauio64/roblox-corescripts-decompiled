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
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDebugEnableUnibarDummyIntegrations = SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagEnableInExperienceAvatarSwitcher = SharedFlags.FFlagEnableInExperienceAvatarSwitcher
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagSideSheetSwapGalleryOrder = SharedFlags.FFlagSideSheetSwapGalleryOrder
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagReverseUnibar = require(Chrome.Flags.FFlagReverseUnibar)
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet
local FFlagAddTraversalHistory = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).Traversal.Flags.FFlagAddTraversalHistory
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial

local function initializeIntegrations() -- line: 42
	-- upvalues: Chrome (copy)
	require(Chrome.Integrations)
end
local function configureUnibar() -- line: 50
	-- upvalues: FFlagEnableSideSheet (copy), isConnectDropdownEnabled (copy), FFlagRemoveFriendsChatUnibarEntrypoints (copy), FFlagExpChatEnableFriendsTab (copy), ArgoPartyExperimentation (copy), FFlagReverseUnibar (copy), GetFFlagDebugEnableUnibarDummyIntegrations (copy), isConnectUnibarEnabled (copy), Constants (copy), FFlagAppNavMyStatsTab (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), Service (copy), FFlagEnableInExperienceAvatarSwitcher (copy), Constants2 (copy), GuiService (copy), FFlagSideSheetSwapGalleryOrder (copy), FFlagAddTraversalHistory (copy), FFlagIntegrateTraversalHistoryInSideSheet (copy), FFlagAddInviteFriendsIntegration (copy), InExperienceSideSheet (copy), FFlagEnableInExperienceShop (copy)
	local t1 = {
		"leaderboard",
		"emotes",
		"backpack"
	}

	if not FFlagEnableSideSheet then
		table.insert(t1, "respawn")
	end

	table.insert(t1, 1, "trust_and_safety")

	if isConnectDropdownEnabled() and (not FFlagRemoveFriendsChatUnibarEntrypoints or not FFlagExpChatEnableFriendsTab or not ArgoPartyExperimentation.getIsRenameEnabled()) then
		table.insert(t1, 1, "connect_dropdown")
	end

	local t2 = {
		"nine_dot",
		"chat",
		"toggle_mic_mute"
	}

	if FFlagReverseUnibar then
		table.insert(t2, 3, "join_voice")

		if GetFFlagDebugEnableUnibarDummyIntegrations() then
			table.insert(t2, "dummy_window")
			table.insert(t2, "dummy_window_2")
		end

		if isConnectUnibarEnabled() then
			table.insert(t2, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
		end

		local v32 = table.find(t2, "toggle_mic_mute")

		if v32 then
			table.insert(t2, v32, Constants.TOGGLE_MIC_INTEGRATION_ID)
		end
	else
		t2 = {
			"toggle_mic_mute",
			"chat",
			"nine_dot"
		}
		table.insert(t2, 2, "join_voice")

		if GetFFlagDebugEnableUnibarDummyIntegrations() then
			table.insert(t2, 1, "dummy_window")
			table.insert(t2, 1, "dummy_window_2")
		end

		if isConnectUnibarEnabled() then
			table.insert(t2, 1, not ArgoPartyExperimentation.getIsRenameEnabled() and "connect_unibar" or "party_entrypoint")
		end

		local v33 = table.find(t2, "toggle_mic_mute")

		if v33 then
			table.insert(t2, v33 + 1, Constants.TOGGLE_MIC_INTEGRATION_ID)
		end
	end

	if FFlagAppNavMyStatsTab then
		table.insert(t2, "assistant_build")
	end

	if isInExperienceUIVREnabled and isSpatial() then
		Service:configureMenu({
			{
				"vr_toggle_button",
				"vr_safety_bubble"
			},
			t2
		})
	else
		Service:configureMenu({ t2 })
	end

	if isInExperienceUIVREnabled then
		if not isSpatial() then
			table.insert(t1, 2, "camera_entrypoint")
			table.insert(t1, 2, "selfie_view")
		end
	else
		table.insert(t1, 2, "camera_entrypoint")
		table.insert(t1, 2, "selfie_view")
	end

	if FFlagEnableInExperienceAvatarSwitcher then
		table.insert(t1, 3, Constants2.AVATAR_SWITCHER_ID)
	end

	if not isSpatial() and not GuiService:IsTenFootInterface() then
		table.insert(t1, 4, "music_entrypoint")
	end

	if FFlagEnableSideSheet then
		table.insert(t1, "people")
		table.insert(t1, "settings")

		if FFlagSideSheetSwapGalleryOrder then
			table.insert(t1, "gallery")
			table.remove(t1, table.find(t1, "trust_and_safety"))
			table.insert(t1, "trust_and_safety")
		else
			table.remove(t1, table.find(t1, "trust_and_safety"))
			table.insert(t1, "trust_and_safety")
			table.insert(t1, "gallery")
		end

		table.insert(t1, "help")

		if FFlagAddTraversalHistory and FFlagIntegrateTraversalHistoryInSideSheet then
			table.insert(t1, "traversal_history")
		end

		if FFlagAddInviteFriendsIntegration then
			table.insert(t1, 2, "invite_friends")
		end

		table.insert(t1, InExperienceSideSheet.Enums.ActionBinding.Leave)
		table.insert(t1, InExperienceSideSheet.Enums.ActionBinding.Respawn)
	end

	if FFlagEnableInExperienceShop then
		table.insert(t1, 2, Constants2.IN_EXPERIENCE_SHOP_ID)
	end

	Service:configureSubMenu("nine_dot", t1)
end

require(Chrome.Integrations)

if FFlagEnableConsoleExpControls then
	ConfigureShortcuts()
end

configureUnibar()

return nil
