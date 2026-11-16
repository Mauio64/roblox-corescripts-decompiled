local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger

local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience)
local useSharePublishedExperience = sharePublishedExperience.useSharePublishedExperience
local sharePrivateExperience = require(BuildExperience.utils.sharePrivateExperience)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local PrivacyType = UniverseConfiguration.PrivacyType

local signal = Signals.createSignal(nil)

local function useExperienceShareFlow(universeId: number?, p: number?)
	local v = useSharePublishedExperience(universeId)
	local v2 = React.useMemo(function()
		if universeId == nil then
			return signal
		end

		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(universeId).data
	end, { universeId })
	local v3 = SignalsReact.useSignalState(v2)

	local state, setState = React.useState("none")

	local state2, setState2 = React.useState(false)

	local onCancelDialog = React.useCallback(function()
		setState2(false)
		setState("none")
	end, {})

	local v4 = React.useCallback(function()
		if p ~= nil then
			v(p)
		end
	end, { p, v })

	local audience = React.useMemo(function()
		return GameConfigurationLabels.getAudience(v3)
	end, { v3 })

	return {
		onShare = React.useCallback(function()
			if audience == PrivacyType.Private then
				if FFlagBuildExperiencePrivateInvites then
					setState("playtesters")

					if universeId ~= nil then
						sendBuildExperienceEvent("PLAYTEST_SHARE_DIALOG_IMPRESSION", {
							universeId = universeId
						})
					end
				end
			elseif audience == PrivacyType.FriendsOnly then
				setState("friends")
			elseif audience == PrivacyType.Public then
				v4()
			end
		end, { audience, v4, universeId }),
		audience = audience,
		activeDialog = state,
		hasShareError = state2,
		onCancelDialog = onCancelDialog,
		onConfirmFriends = React.useCallback(function()
			setState("none")
			v4()
		end, { v4 }),
		onConfirmPlaytesters = React.useCallback(function()
			if universeId == nil then
				return
			end

			sendBuildExperienceEvent("PLAYTEST_SHARE_CLICK", { universeId = universeId }, {
				source = "playtesters_dialog"
			})

			setState2(false)
			sharePrivateExperience(universeId):andThen(function()
				setState("none")
			end):catch(function(p2)
				Logger:warning("useExperienceShareFlow: private share failed for universe {}: {}", universeId, p2)
				setState2(true)
			end)
		end, { universeId })
	}
end

return useExperienceShareFlow
