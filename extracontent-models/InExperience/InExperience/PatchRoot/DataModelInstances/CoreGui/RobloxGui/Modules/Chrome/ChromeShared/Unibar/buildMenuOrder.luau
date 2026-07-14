local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Constants = require(script.Parent.Constants)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local isConnectDropdownEnabled = require(Chrome.Integrations.Connect.isConnectDropdownEnabled)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInExperienceAvatarSwitcher = SharedFlags.FFlagEnableInExperienceAvatarSwitcher
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FIntSideSheetVariant = SharedFlags.FIntSideSheetVariant
local v19 = if not FFlagIntegrateTraversalHistoryInSideSheet then nil else require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).Traversal
local v20 = not not v19 and v19.Flags.FFlagAddTraversalHistory

local function reorder(t1: {[any]: any}, s1: string, n1: number) -- line: 33
	if t1[s1] ~= nil then
		t1[s1] = n1
	end
end
local function buildMenuOrder() -- line: 40
	-- upvalues: isConnectDropdownEnabled (copy), FFlagRemoveFriendsChatUnibarEntrypoints (copy), ArgoPartyExperimentation (copy), FFlagExpChatEnableFriendsTab (copy), isSpatial (copy), GuiService (copy), isInExperienceUIVREnabled (copy), v20 (copy), FFlagIntegrateTraversalHistoryInSideSheet (copy), FFlagAddInviteFriendsIntegration (copy), Constants (copy), FFlagEnableInExperienceAvatarSwitcher (copy), FFlagEnableInExperienceShop (copy), InExperienceSideSheet (copy), FFlagEnableSideSheet (copy), FIntSideSheetVariant (copy)
	local v26 = isConnectDropdownEnabled() and not (FFlagRemoveFriendsChatUnibarEntrypoints and (ArgoPartyExperimentation.getIsRenameEnabled() and FFlagExpChatEnableFriendsTab))
	local v27 = not isSpatial() and not GuiService:IsTenFootInterface()
	local v28 = not isInExperienceUIVREnabled or not isSpatial()
	local v29 = v20 and FFlagIntegrateTraversalHistoryInSideSheet
	local t2 = {
		invite_friends = if not FFlagAddInviteFriendsIntegration then nil else 10,
		people = 20,
		settings = 30,
		trust_and_safety = 40,
		connect_dropdown = if not v26 then nil else 50,
		[Constants.AVATAR_SWITCHER_ID] = if not FFlagEnableInExperienceAvatarSwitcher then nil else 60,
		[Constants.IN_EXPERIENCE_SHOP_ID] = if not FFlagEnableInExperienceShop then nil else 70,
		leaderboard = 80,
		emotes = 90,
		backpack = 100,
		traversal_history = if not v29 then nil else 110,
		help = 120,
		camera_entrypoint = if not v28 then nil else 130,
		gallery = 140,
		selfie_view = if not v28 then nil else 150,
		music_entrypoint = if not v27 then nil else 160,
		[InExperienceSideSheet.Enums.ActionBinding.Leave] = 180,
		[InExperienceSideSheet.Enums.ActionBinding.Respawn] = 190
	}

	if FFlagEnableSideSheet and FIntSideSheetVariant == 0 then
		if t2.settings ~= nil then
			t2.settings = 103
		end

		if t2.trust_and_safety ~= nil then
			t2.trust_and_safety = 106
		end

		local IN_EXPERIENCE_SHOP_ID = Constants.IN_EXPERIENCE_SHOP_ID

		if t2[IN_EXPERIENCE_SHOP_ID] ~= nil then
			t2[IN_EXPERIENCE_SHOP_ID] = 143
		end

		if t2.backpack ~= nil then
			t2.backpack = 146
		end
	end

	if not FFlagEnableSideSheet then
		if t2.connect_dropdown ~= nil then
			t2.connect_dropdown = 10
		end

		local IN_EXPERIENCE_SHOP_ID = Constants.IN_EXPERIENCE_SHOP_ID

		if t2[IN_EXPERIENCE_SHOP_ID] ~= nil then
			t2[IN_EXPERIENCE_SHOP_ID] = 20
		end

		if t2.selfie_view ~= nil then
			t2.selfie_view = 30
		end

		local AVATAR_SWITCHER_ID = Constants.AVATAR_SWITCHER_ID

		if t2[AVATAR_SWITCHER_ID] ~= nil then
			t2[AVATAR_SWITCHER_ID] = 40
		end

		if t2.music_entrypoint ~= nil then
			t2.music_entrypoint = 50
		end

		if t2.camera_entrypoint ~= nil then
			t2.camera_entrypoint = 60
		end

		if t2.trust_and_safety ~= nil then
			t2.trust_and_safety = 70
		end

		t2.respawn = 110
		t2.invite_friends = nil
		t2.people = nil
		t2.settings = nil
		t2.traversal_history = nil
		t2.help = nil
		t2.gallery = nil
		t2[InExperienceSideSheet.Enums.ActionBinding.Leave] = nil
		t2[InExperienceSideSheet.Enums.ActionBinding.Respawn] = nil
	end

	local t3 = {}

	for v35 in t2 do
		table.insert(t3, v35)
	end

	table.sort(t3, function(p1, p2) -- line: 109
		-- upvalues: t2 (copy)
		return t2[p1] < t2[p2]
	end)

	return t3
end

return buildMenuOrder
