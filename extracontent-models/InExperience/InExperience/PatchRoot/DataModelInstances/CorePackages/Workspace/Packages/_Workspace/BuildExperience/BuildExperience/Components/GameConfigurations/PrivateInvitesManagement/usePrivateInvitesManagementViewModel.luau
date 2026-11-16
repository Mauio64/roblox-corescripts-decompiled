local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local PrivatePlaytesters = require(parent.DataHydration.PrivatePlaytesters)
local getPrivatePlaytestersStore = PrivatePlaytesters.getPrivatePlaytestersStore
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
require(script.Parent.PrivateInvitesManagementView)

local function usePrivateInvitesManagementViewModel(data)
	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	local v = React.useMemo(function()
		return privatePlaytestersStore.getAndFetchInvitedPlayers(data.universeId)
	end, { privatePlaytestersStore, data.universeId })
	local userIds = SignalsReact.useSignalState(v.players)
	local count = #userIds
	local MAX_INVITES = privatePlaytestersStore.MAX_INVITES
	local v2 = useLocalization({
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

	local inviteButton = v2.inviteButton
	local count2 = v2.count
	local subtitle = v2.subtitle
	local title = v2.title
	local universeId = data.universeId

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current then
			return
		end

		ref.current = true
		sendBuildExperienceEvent("PLAYTEST_MANAGEMENT_IMPRESSION", { universeId = universeId })
	end, { universeId })

	local state, setState = React.useState({})

	local onRemove = React.useCallback(function(p: number)
		setState(function(p2)
			local clone = table.clone(p2)
			clone[p] = true
			return clone
		end)

		privatePlaytestersStore.removeInvite(universeId, p):andThen(function()
			sendBuildExperienceEvent("PLAYTESTER_REMOVED", { universeId = universeId })
		end):finally(function()
			setState(function(p2)
				local clone = table.clone(p2)
				clone[p] = nil
				return clone
			end)
		end)
	end, { privatePlaytestersStore, universeId })

	local onOpenInvitePicker = React.useCallback(function()
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
		userIds = userIds,
		removingUserIds = state,
		onRemove = onRemove,
		isInviteDisabled = MAX_INVITES <= count,
		onOpenInvitePicker = onOpenInvitePicker,
		layoutOrder = data.layoutOrder,
		testId = data.testId
	}
end

return usePrivateInvitesManagementViewModel
