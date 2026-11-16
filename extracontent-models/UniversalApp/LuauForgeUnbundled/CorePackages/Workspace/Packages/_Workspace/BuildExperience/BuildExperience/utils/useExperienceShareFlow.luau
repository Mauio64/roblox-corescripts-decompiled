local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Loggers").Logger

local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local GameConfigurationLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels")
local useSharePublishedExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/sharePublishedExperience").useSharePublishedExperience
local sharePrivateExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/sharePrivateExperience")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagBuildExperiencePrivateInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrivateInvites")
local privacyType = UniverseConfiguration.PrivacyType

local signal = Signals.createSignal(nil)

local function useExperienceShareFlow(p2, p3)
	local v5 = useSharePublishedExperience(p2)
	local v6 = React.useMemo(function()
		if p2 == nil then
			return signal
		end

		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(p2).data
	end, { p2 })
	local v7 = SignalsReact.useSignalState(v6)

	local state, setState = React.useState("none")

	local state2, setState2 = React.useState(false)

	local v8 = React.useCallback(function()
		setState2(false)
		setState("none")
	end, {})

	local v9 = React.useCallback(function()
		if p3 ~= nil then
			v5(p3)
		end
	end, { p3, v5 })

	local v10 = React.useMemo(function()
		return GameConfigurationLabels.getAudience(v7)
	end, { v7 })

	return {
		onShare = React.useCallback(function()
			if v10 == privacyType.Private then
				if FFlagBuildExperiencePrivateInvites then
					setState("playtesters")

					if p2 ~= nil then
						sendBuildExperienceEvent("PLAYTEST_SHARE_DIALOG_IMPRESSION", { universeId = p2 })
					end
				end
			elseif v10 == privacyType.FriendsOnly then
				setState("friends")
			elseif v10 == privacyType.Public then
				v9()
			end
		end, { v10, v9, p2 }),
		audience = v10,
		activeDialog = state,
		hasShareError = state2,
		onCancelDialog = v8,
		onConfirmFriends = React.useCallback(function()
			setState("none")
			v9()
		end, { v9 }),
		onConfirmPlaytesters = React.useCallback(function()
			if p2 == nil then
				return
			end

			sendBuildExperienceEvent("PLAYTEST_SHARE_CLICK", { universeId = p2 }, {
				source = "playtesters_dialog"
			})

			setState2(false)
			sharePrivateExperience(p2):andThen(function()
				setState("none")
			end):catch(function(p4)
				logger:warning("useExperienceShareFlow: private share failed for universe {}: {}", p2, p4)
				setState2(true)
			end)
		end, { p2 })
	}
end

return useExperienceShareFlow
