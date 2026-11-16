local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local Constants = require(script.Parent.Constants)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)

local isConnectDropdownEnabled = require(Chrome.Integrations.Connect.isConnectDropdownEnabled)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local isTenFootInterface = AppCommonLib2.isTenFootInterface

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInExperienceAvatarSwitcher = SharedFlags.FFlagEnableInExperienceAvatarSwitcher
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatCanShowFriendsTab = SharedFlags.FFlagExpChatCanShowFriendsTab
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local FFlagEnableSideSheetRobuxWidget = require(Chrome.Flags.FFlagEnableSideSheetRobuxWidget)
local traversal

if FFlagIntegrateTraversalHistoryInSideSheet then
	local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
	traversal = CoreScriptsRoactCommon.Traversal
end

local v

if traversal then
	v = traversal.Flags.FFlagAddTraversalHistory
else
	v = false
end

local function reorder(p, p2: string, p3: number) -- 8 equivalent calls inferred from this helper
	if p[p2] ~= nil then
		p[p2] = p3
	end
end

local function buildMenuOrder()
	local v2 = isConnectDropdownEnabled()

	if v2 then
		v2 = not (FFlagRemoveFriendsChatUnibarEntrypoints and FFlagExpChatCanShowFriendsTab)
	end

	local v3 = not (isSpatial() or isTenFootInterface())
	local v4 = not (isInExperienceUIVREnabled and isSpatial())

	local v5 = {
		RobuxWidget = FFlagEnableSideSheetRobuxWidget and isSideSheetEnabled and 5 or nil,
		invite_friends = FFlagAddInviteFriendsIntegration and 10 or nil,
		people = 20,
		settings = 30,
		trust_and_safety = 40,
		connect_dropdown = v2 and 50 or nil,
		[Constants.AVATAR_SWITCHER_ID] = FFlagEnableInExperienceAvatarSwitcher and 60 or nil,
		[Constants.SWITCH_SERVER_ID] = (FFlagShowSwitchServerButton or isPioneerLaunch()) and 65 or nil,
		[Constants.IN_EXPERIENCE_SHOP_ID] = FFlagEnableInExperienceShop and 70 or nil,
		leaderboard = 80,
		emotes = 90,
		backpack = 100,
		traversal_history = v and FFlagIntegrateTraversalHistoryInSideSheet and 110 or nil,
		help = 120,
		camera_entrypoint = v4 and 130 or nil,
		gallery = 140,
		selfie_view = v4 and 150 or nil,
		music_entrypoint = v3 and 160 or nil,
		AccountUpsell = isPioneerLaunch() and 170 or nil,
		[InExperienceSideSheet.Enums.ActionBinding.Leave] = 180,
		[InExperienceSideSheet.Enums.ActionBinding.Respawn] = 190
	}

	if isPioneerLaunch() then
		v5.connect_dropdown = nil
		v5[Constants.AVATAR_SWITCHER_ID] = nil
		v5.emotes = nil
		v5.traversal_history = nil
		v5.camera_entrypoint = nil
		v5.gallery = nil
		reorder(v5, Constants.SWITCH_SERVER_ID, 200) -- inferred equivalent call
	elseif not isSideSheetEnabled then
		reorder(v5, "connect_dropdown", 10) -- inferred equivalent call
		reorder(v5, Constants.IN_EXPERIENCE_SHOP_ID, 20) -- inferred equivalent call
		reorder(v5, "selfie_view", 30) -- inferred equivalent call
		reorder(v5, Constants.AVATAR_SWITCHER_ID, 40) -- inferred equivalent call
		reorder(v5, "music_entrypoint", 50) -- inferred equivalent call
		reorder(v5, "camera_entrypoint", 60) -- inferred equivalent call
		reorder(v5, "trust_and_safety", 70) -- inferred equivalent call
		v5.respawn = 110

		v5.invite_friends = nil
		v5.people = nil
		v5.settings = nil
		v5.traversal_history = nil
		v5.help = nil
		v5.gallery = nil
		v5[InExperienceSideSheet.Enums.ActionBinding.Leave] = nil
		v5[InExperienceSideSheet.Enums.ActionBinding.Respawn] = nil
		v5[Constants.SWITCH_SERVER_ID] = nil
	end

	local menuOrder = {}

	for k in v5 do
		table.insert(menuOrder, k)
	end

	table.sort(menuOrder, function(a, b): boolean
		return v5[a] < v5[b]
	end)

	return menuOrder
end

return buildMenuOrder
