local AppStorageService = game:GetService("AppStorageService")
local RunService = game:GetService("RunService")

local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local parent = CoreScriptsRoactCommon.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local IsPrivatePlaytester = require(parent.DataHydration.IsPrivatePlaytester)
local getIsPrivatePlaytesterStore = IsPrivatePlaytester.getIsPrivatePlaytesterStore

local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local getUniverseConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore
local PrivacyType = UniverseConfiguration.PrivacyType

local PlaytestModeAnalytics = require(CoreScriptsRoactCommon.Analytics.PlaytestModeAnalytics)

local BuildModeLaunch = require(parent.BuildExperiencePlaytestLaunch.BuildModeLaunch)

local defineFastFlag = game:DefineFastFlag("DebugEnablePlaytestMode", false)
local FFlagAddPlaytestModeAnalytics = require(CoreScriptsRoactCommon.Flags.FFlagAddPlaytestModeAnalytics)
local FFlagPlaytestModeExcludeBuildMode = require(CoreScriptsRoactCommon.Flags.FFlagPlaytestModeExcludeBuildMode)
local FFlagPlaytestModeExcludeStudio = require(CoreScriptsRoactCommon.Flags.FFlagPlaytestModeExcludeStudio)
local FFlagPlaytestModeIncludeTeamTest = require(CoreScriptsRoactCommon.Flags.FFlagPlaytestModeIncludeTeamTest)
local SharedFlags = require(parent.SharedFlags)
local FFlagPlaytestModeTooltipOncePerWeek = SharedFlags.FFlagPlaytestModeTooltipOncePerWeek

local SharedFlags2 = require(parent.SharedFlags)
local FFlagPlaytestModeTooltipOnlyPrivateTesters = SharedFlags2.FFlagPlaytestModeTooltipOnlyPrivateTesters

return function()
	local signal, setHasEditAccess = createSignal(false)

	local function getHasTooltipCooldownExpired(): boolean
		local success, result = pcall(function()
			return AppStorageService:GetItem("PlaytestModeTooltipSeenAt")
		end)

		if not success or type(result) ~= "string" then
			return true
		end

		local v = tonumber(result)
		return v == nil or os.time() - v >= 604800
	end

	local function markTooltipSeen()
		pcall(function()
			AppStorageService:SetItem("PlaytestModeTooltipSeenAt", (tostring(os.time())))
			AppStorageService:Flush()
		end)
	end

	local computed = Signals.createComputed(function(p): boolean
		local data = getIsPrivatePlaytesterStore(p).getAndFetch(game.GameId).data(p)
		return data ~= nil and data.isPlaytester == true
	end)

	local computed2 = Signals.createComputed(function(p): boolean
		local data = getUniverseConfigurationStore(p).getAndFetchSummary(game.GameId).data(p)
		return data ~= nil and data.privacyType == PrivacyType.Private
	end)

	local v = {
		getIsPlaytestMode = Signals.createComputed(function(p): boolean
			if defineFastFlag then
				return true
			end

			if FFlagPlaytestModeExcludeBuildMode and BuildModeLaunch:hasBuildMode() then
				return false
			end

			if FFlagPlaytestModeIncludeTeamTest and RunService:IsTeamTest() then
				if FFlagAddPlaytestModeAnalytics then
					if RunService:IsStudio() then
						PlaytestModeAnalytics.logPlaytestModeEnabled("studio_team_test")
					else
						PlaytestModeAnalytics.logPlaytestModeEnabled("team_test_server")
					end
				end

				return true
			elseif computed(p) then
				if FFlagAddPlaytestModeAnalytics then
					PlaytestModeAnalytics.logPlaytestModeEnabled("private_playtester")
				end

				return true
			elseif signal(p) and computed2(p) and not (FFlagPlaytestModeExcludeStudio and RunService:IsStudio()) then
				if FFlagAddPlaytestModeAnalytics then
					PlaytestModeAnalytics.logPlaytestModeEnabled("private_game")
				end

				return true
			else
				return false
			end
		end),
		getIsPrivatePlaytester = 0,
		setHasEditAccess = 0,
		getHasTooltipCooldownExpired = 0,
		markTooltipSeen = 0
	}
	local getIsPrivatePlaytester

	if FFlagPlaytestModeTooltipOnlyPrivateTesters then
		getIsPrivatePlaytester = computed
	end

	v.getIsPrivatePlaytester = getIsPrivatePlaytester

	v.setHasEditAccess = setHasEditAccess

	if not FFlagPlaytestModeTooltipOncePerWeek then
		getHasTooltipCooldownExpired = nil
	end

	v.getHasTooltipCooldownExpired = getHasTooltipCooldownExpired

	if not FFlagPlaytestModeTooltipOncePerWeek then
		markTooltipSeen = nil
	end

	v.markTooltipSeen = markTooltipSeen
	return v
end
