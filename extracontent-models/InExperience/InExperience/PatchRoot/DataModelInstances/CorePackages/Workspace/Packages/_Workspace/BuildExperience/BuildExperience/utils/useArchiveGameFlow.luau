local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local ConfigurationActionTelemetry = require(BuildExperience.Telemetry.ConfigurationActionTelemetry)
local FFlagBuildExperienceActionOutcomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceActionOutcomeTelemetry)

local Action = ConfigurationActionTelemetry.Action
local FailureReason = ConfigurationActionTelemetry.FailureReason

local function useArchiveGameFlow(p)
	local state, setState = React.useState(nil)
	local context

	if FFlagBuildExperienceActionOutcomeTelemetry then
		context = p.context
	else
		context = nil
	end

	local requestArchive = React.useCallback(function(p2: number)
		setState(p2)
	end, {})

	local cancel = React.useCallback(function()
		setState(nil)
	end, {})

	local confirm = React.useCallback(function()
		if state ~= nil then
			local v = FFlagBuildExperienceActionOutcomeTelemetry and { universeId = state } or nil

			if FFlagBuildExperienceActionOutcomeTelemetry then
				ConfigurationActionTelemetry.sendClick(Action.ArchiveGame, v, context)
			end

			local archiveGame = GameConfigurationActions.archiveGame(state)

			if FFlagBuildExperienceActionOutcomeTelemetry then
				archiveGame:andThen(function()
					ConfigurationActionTelemetry.sendSuccess(Action.ArchiveGame, v, context)
				end):catch(function(err)
					ConfigurationActionTelemetry.sendFailure(
						Action.ArchiveGame,
						v,
						{ reason = FailureReason.RequestFailed, error = err },
						context
					)
				end)
			end
		end

		setState(nil)
	end, { state, context })

	return {
		isOpen = state ~= nil,
		requestArchive = requestArchive,
		confirm = confirm,
		cancel = cancel
	}
end

return useArchiveGameFlow
