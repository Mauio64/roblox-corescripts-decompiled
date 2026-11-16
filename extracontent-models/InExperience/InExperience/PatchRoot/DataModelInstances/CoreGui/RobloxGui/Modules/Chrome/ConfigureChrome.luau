local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)

if not Chrome2.Enabled() then
	return nil
end

local Service = require(Chrome.Service)
local Constants = require(Chrome.Integrations.Party.Constants)
local isConnectUnibarEnabled = require(Chrome.Integrations.Connect.isConnectUnibarEnabled)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local ConfigureShortcuts = require(Chrome.ChromeShared.Shortcuts.ConfigureShortcuts)
local buildMenuOrder = require(Chrome.ChromeShared.Unibar.buildMenuOrder)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDebugEnableUnibarDummyIntegrations = SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local function initializeIntegrations() -- 1 equivalent call inferred from this helper
	require(Chrome.Integrations)
end

local function configureUnibar()
	local menuOrder = buildMenuOrder()

	local v = { "nine_dot", "chat", "toggle_mic_mute" }
	table.insert(v, 3, "join_voice")

	if GetFFlagDebugEnableUnibarDummyIntegrations() then
		table.insert(v, "dummy_window")
		table.insert(v, "dummy_window_2")
	end

	if isConnectUnibarEnabled() then
		table.insert(v, "party_entrypoint")
	end

	local index = table.find(v, "toggle_mic_mute")

	if index then
		table.insert(v, index, Constants.TOGGLE_MIC_INTEGRATION_ID)
	end

	if FFlagAppNavMyStatsTab then
		table.insert(v, "assistant_build")
	end

	if isInExperienceUIVREnabled and isSpatial() then
		Service:configureMenu({
			{ "vr_toggle_button", "vr_safety_bubble" },
			v
		})
	else
		Service:configureMenu({ v })
	end

	Service:configureSubMenu("nine_dot", menuOrder)
end

initializeIntegrations() -- inferred equivalent call

local function fn() -- 1 equivalent call inferred from this helper
	ConfigureShortcuts()
end

if FFlagEnableConsoleExpControls then
	fn() -- inferred equivalent call
end

configureUnibar()

return nil
