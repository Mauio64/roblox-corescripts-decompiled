local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")
local ConfigurationActionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/ConfigurationActionTelemetry")
local FFlagBuildExperienceActionOutcomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceActionOutcomeTelemetry")

local action = ConfigurationActionTelemetry.Action
local failureReason = ConfigurationActionTelemetry.FailureReason

local function useArchiveGameFlow(p2)
	local state, setState = React.useState(nil)

	local context = if FFlagBuildExperienceActionOutcomeTelemetry then p2.context else nil

	local v5 = React.useCallback(function(p3)
		setState(p3)
	end, {})

	local v6 = React.useCallback(function()
		setState(nil)
	end, {})

	local v7 = React.useCallback(function()
		if state ~= nil then
			local v8 = FFlagBuildExperienceActionOutcomeTelemetry and { universeId = state } or nil

			if FFlagBuildExperienceActionOutcomeTelemetry then
				ConfigurationActionTelemetry.sendClick(action.ArchiveGame, v8, context)
			end

			local archiveGame = GameConfigurationActions.archiveGame(state)

			if FFlagBuildExperienceActionOutcomeTelemetry then
				archiveGame:andThen(function()
					ConfigurationActionTelemetry.sendSuccess(action.ArchiveGame, v8, context)
				end):catch(function(p3)
					ConfigurationActionTelemetry.sendFailure(
						action.ArchiveGame,
						v8,
						{ reason = failureReason.RequestFailed, error = p3 },
						context
					)
				end)
			end
		end

		setState(nil)
	end, { state, context })

	return {
		isOpen = state ~= nil,
		requestArchive = v5,
		confirm = v7,
		cancel = v6
	}
end

return useArchiveGameFlow
