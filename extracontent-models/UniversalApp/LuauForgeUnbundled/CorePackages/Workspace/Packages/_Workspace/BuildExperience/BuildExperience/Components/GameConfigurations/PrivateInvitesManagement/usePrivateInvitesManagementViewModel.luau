local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local getPrivatePlaytestersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PrivatePlaytesters").getPrivatePlaytestersStore
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local useBuildPageImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useBuildPageImpression")
local FFlagBuildExperiencePageImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePageImpressions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PrivateInvitesManagement/PrivateInvitesManagementView")

local function usePrivateInvitesManagementViewModel(data)
	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	local v5 = React.useMemo(function()
		return privatePlaytestersStore.getAndFetchInvitedPlayers(data.universeId)
	end, { privatePlaytestersStore, data.universeId })
	local v6 = SignalsReact.useSignalState(v5.players)
	local count = #v6
	local MAX_INVITES = privatePlaytestersStore.MAX_INVITES
	local v7 = useLocalization({
		count = {
			LocalizationStrings.PRIVATE_INVITES_COUNT,
			COUNT = count,
			MAX_INVITES = MAX_INVITES
		},
		inviteButton = LocalizationStrings.PRIVATE_INVITES_INVITE_BUTTON,
		subtitle = {
			LocalizationStrings.PRIVATE_INVITES_SUBTITLE,
			MAX_INVITES = MAX_INVITES
		},
		title = LocalizationStrings.PRIVATE_INVITES_TITLE
	})

	local inviteButton = v7.inviteButton
	local count2 = v7.count
	local subtitle = v7.subtitle
	local title = v7.title
	local universeId = data.universeId

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current then
			return
		end

		ref.current = true
		sendBuildExperienceEvent("PLAYTEST_MANAGEMENT_IMPRESSION", { universeId = universeId })
	end, { universeId })

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("invite-management", { universeId = universeId })
	end

	local state, setState = React.useState({})

	local v8 = React.useCallback(function(p2)
		setState(function(p3)
			local clone = table.clone(p3)
			clone[p2] = true
			return clone
		end)

		privatePlaytestersStore.removeInvite(universeId, p2):andThen(function()
			sendBuildExperienceEvent("PLAYTESTER_REMOVED", { universeId = universeId })
		end):finally(function()
			setState(function(p3)
				local clone = table.clone(p3)
				clone[p2] = nil
				return clone
			end)
		end)
	end, { privatePlaytestersStore, universeId })

	local v9 = React.useCallback(function()
		sendBuildExperienceEvent("ADD_TO_PLAYTEST_CLICK", { universeId = universeId }, {
			source = "management_page"
		})

		data.onOpenInvitePicker()
	end, { universeId, data.onOpenInvitePicker })

	return {
		title = title,
		countText = count2,
		subtitle = subtitle,
		inviteButtonText = inviteButton,
		userIds = v6,
		removingUserIds = state,
		onRemove = v8,
		isInviteDisabled = MAX_INVITES <= count,
		onOpenInvitePicker = v9,
		layoutOrder = data.layoutOrder,
		testId = data.testId
	}
end

return usePrivateInvitesManagementViewModel
