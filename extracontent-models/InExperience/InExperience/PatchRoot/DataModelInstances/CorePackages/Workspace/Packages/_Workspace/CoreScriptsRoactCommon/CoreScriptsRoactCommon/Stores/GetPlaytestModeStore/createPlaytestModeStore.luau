local RunService = game:GetService("RunService")
local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local CoreScriptsRoactCommonParent = CoreScriptsRoactCommon.Parent
local Signals = require(CoreScriptsRoactCommonParent.Signals)
local createSignal = Signals.createSignal
local getIsPrivatePlaytesterStore = require(CoreScriptsRoactCommonParent.DataHydration.IsPrivatePlaytester).getIsPrivatePlaytesterStore
local UniverseConfiguration = require(CoreScriptsRoactCommonParent.DataHydration.UniverseConfiguration)
local getUniverseConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore
local PrivacyType = UniverseConfiguration.PrivacyType
local PlaytestModeAnalytics = require(CoreScriptsRoactCommon.Analytics.PlaytestModeAnalytics)
local BuildModeLaunch = require(CoreScriptsRoactCommonParent.BuildExperience.BuildModeLaunch)
local v12 = game:DefineFastFlag("DebugEnablePlaytestMode", false)
local FFlagAddPlaytestModeAnalytics = require(CoreScriptsRoactCommon.Flags.FFlagAddPlaytestModeAnalytics)
local FFlagPlaytestModeExcludeBuildMode = require(CoreScriptsRoactCommon.Flags.FFlagPlaytestModeExcludeBuildMode)
local FFlagPlaytestModeExcludeStudio = require(CoreScriptsRoactCommon.Flags.FFlagPlaytestModeExcludeStudio)

return function() -- line: 31
	-- upvalues: createSignal (copy), Signals (copy), getIsPrivatePlaytesterStore (copy), getUniverseConfigurationStore (copy), PrivacyType (copy), v12 (copy), FFlagPlaytestModeExcludeStudio (copy), RunService (copy), FFlagPlaytestModeExcludeBuildMode (copy), BuildModeLaunch (copy), FFlagAddPlaytestModeAnalytics (copy), PlaytestModeAnalytics (copy)
	local v16, v17 = createSignal(false)
	local v18 = Signals.createComputed(function(p1) -- line: 34
		-- upvalues: getIsPrivatePlaytesterStore (copy)
		local v21 = getIsPrivatePlaytesterStore(p1).getAndFetch(game.GameId).data(p1)

		return v21 ~= nil and v21.isPlaytester == true
	end)
	local v19 = Signals.createComputed(function(p2) -- line: 40
		-- upvalues: getUniverseConfigurationStore (copy), PrivacyType (copy)
		local v23 = getUniverseConfigurationStore(p2).getAndFetchSummary(game.GameId).data(p2)

		return v23 ~= nil and v23.privacyType == PrivacyType.Private
	end)

	return {
		getIsPlaytestMode = Signals.createComputed(function(p3) -- line: 46
			-- upvalues: v12 (copy), FFlagPlaytestModeExcludeStudio (copy), RunService (copy), FFlagPlaytestModeExcludeBuildMode (copy), BuildModeLaunch (copy), v18 (copy), FFlagAddPlaytestModeAnalytics (copy), PlaytestModeAnalytics (copy), v16 (copy), v19 (copy)
			if v12 then
				return true
			end

			if FFlagPlaytestModeExcludeStudio and RunService:IsStudio() then
				return false
			end

			if FFlagPlaytestModeExcludeBuildMode and BuildModeLaunch:hasBuildMode() then
				return false
			end

			if v18(p3) then
				if FFlagAddPlaytestModeAnalytics then
					PlaytestModeAnalytics.logPlaytestModeEnabled("private_playtester")
				end

				return true
			end

			if v16(p3) and v19(p3) then
				if FFlagAddPlaytestModeAnalytics then
					PlaytestModeAnalytics.logPlaytestModeEnabled("private_game")
				end

				return true
			end

			return false
		end),
		setHasEditAccess = v17
	}
end
