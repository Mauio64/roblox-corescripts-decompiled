local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local Logger = require(BuildExperienceParent.Loggers).Logger
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience).sharePublishedExperience
local sharePrivateExperience = require(BuildExperience.utils.sharePrivateExperience)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local PrivacyType = UniverseConfiguration.PrivacyType
local v14 = Signals.createSignal(nil)

local function useExperienceShareFlow(n1: number?, n2: number?) -- line: 59
	-- upvalues: React (copy), UniverseConfiguration (copy), SignalsReact (copy), v14 (copy), sharePublishedExperience (copy), GameConfigurationLabels (copy), PrivacyType (copy), FFlagBuildExperiencePrivateInvites (copy), sendBuildExperienceEvent (copy), sharePrivateExperience (copy), Logger (copy)
	local v18 = React.useMemo(function() -- line: 60
		-- upvalues: n1 (copy), UniverseConfiguration (copy)
		if n1 ~= nil then
			return (UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(n1))
		end

		return nil
	end, { n1 })
	local v19 = SignalsReact.useSignalState(if v18 == nil then v14 else v18.data)
	local v20, v21 = React.useState("none")
	local v22, v23 = React.useState(false)
	local v24 = React.useCallback(function() -- line: 75
		-- upvalues: v23 (copy), v21 (copy)
		v23(false)
		v21("none")
	end, {})
	local v25 = React.useCallback(function() -- line: 80
		-- upvalues: n2 (copy), sharePublishedExperience (copy)
		if n2 ~= nil then
			sharePublishedExperience(n2)
		end
	end, { n2 })
	local v26 = React.useMemo(function() -- line: 89
		-- upvalues: GameConfigurationLabels (copy), v19 (copy)
		return GameConfigurationLabels.getAudience(v19)
	end, { v19 })
	local v27 = React.useCallback(function() -- line: 95
		-- upvalues: v26 (copy), PrivacyType (copy), FFlagBuildExperiencePrivateInvites (copy), v21 (copy), n1 (copy), sendBuildExperienceEvent (copy), v25 (copy)
		if v26 == PrivacyType.Private then
			if FFlagBuildExperiencePrivateInvites then
				v21("playtesters")

				if n1 ~= nil then
					sendBuildExperienceEvent("PLAYTEST_SHARE_DIALOG_IMPRESSION", {
						universeId = n1
					})

					return
				end
			end
		else
			if v26 == PrivacyType.FriendsOnly then
				v21("friends")

				return
			end

			if v26 == PrivacyType.Public then
				v25()
			end
		end
	end, {
		v26,
		v25,
		n1
	})
	local v28 = React.useCallback(function() -- line: 115
		-- upvalues: v21 (copy), v25 (copy)
		v21("none")
		v25()
	end, { v25 })
	local v29 = React.useCallback(function() -- line: 120
		-- upvalues: n1 (copy), sendBuildExperienceEvent (copy), v23 (copy), sharePrivateExperience (copy), v21 (copy), Logger (copy)
		if n1 == nil then
			return
		end

		sendBuildExperienceEvent("PLAYTEST_SHARE_CLICK", {
			universeId = n1
		}, {
			source = "playtesters_dialog"
		})
		v23(false)
		sharePrivateExperience(n1):andThen(function() -- line: 132
			-- upvalues: v21 (copy)
			v21("none")
		end):catch(function(p1) -- line: 135
			-- upvalues: Logger (copy), n1 (copy), v23 (copy)
			Logger:warning("useExperienceShareFlow: private share failed for universe {}: {}", n1, p1)
			v23(true)
		end)
	end, { n1 })

	return {
		onShare = v27,
		audience = v26,
		activeDialog = v20,
		hasShareError = v22,
		onCancelDialog = v24,
		onConfirmFriends = v28,
		onConfirmPlaytesters = v29
	}
end

return useExperienceShareFlow
