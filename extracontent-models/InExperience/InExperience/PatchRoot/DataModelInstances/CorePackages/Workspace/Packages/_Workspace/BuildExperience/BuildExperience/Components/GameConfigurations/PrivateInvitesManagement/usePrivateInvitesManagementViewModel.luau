local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local Logger = require(BuildExperienceParent.Loggers).Logger
local getPrivatePlaytestersStore = require(BuildExperienceParent.DataHydration.PrivatePlaytesters).getPrivatePlaytestersStore
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local sharePrivateExperience = require(BuildExperience.utils.sharePrivateExperience)

require(script.Parent.PrivateInvitesManagementView)

local function usePrivateInvitesManagementViewModel(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), sendBuildExperienceEvent (copy), getPrivatePlaytestersStore (copy), SignalsReact (copy), sharePrivateExperience (copy), Logger (copy), LocalizationStrings (copy)
	local universeId = t1.universeId
	local v13 = React.useRef(false)

	React.useEffect(function() -- line: 34
		-- upvalues: v13 (copy), sendBuildExperienceEvent (copy), universeId (copy)
		if v13.current then
			return
		end

		v13.current = true
		sendBuildExperienceEvent("PLAYTEST_MANAGEMENT_IMPRESSION", {
			universeId = universeId
		})
	end, { universeId })

	local v14 = getPrivatePlaytestersStore(false)
	local v15 = React.useMemo(function() -- line: 43
		-- upvalues: v14 (copy), universeId (copy)
		return v14.getAndFetchInvitedPlayers(universeId)
	end, {
		v14,
		universeId
	})
	local v16 = SignalsReact.useSignalState(v15.players)
	local v17, v18 = React.useState({})
	local v19 = React.useCallback(function(n1: number) -- line: 49
		-- upvalues: v18 (copy), v14 (copy), universeId (copy), sendBuildExperienceEvent (copy)
		v18(function(p1) -- line: 50
			-- upvalues: n1 (copy)
			local v26 = table.clone(p1)

			v26[n1] = true

			return v26
		end)
		v14.removeInvite(universeId, n1):andThen(function() -- line: 57
			-- upvalues: sendBuildExperienceEvent (copy), universeId (copy)
			sendBuildExperienceEvent("PLAYTESTER_REMOVED", {
				universeId = universeId
			})
		end):finally(function() -- line: 60
			-- upvalues: v18 (copy), n1 (copy)
			v18(function(p2) -- line: 61
				-- upvalues: n1 (copy)
				local v29 = table.clone(p2)

				v29[n1] = nil

				return v29
			end)
		end)
	end, {
		v14,
		universeId
	})
	local v20 = React.useCallback(function() -- line: 72
		-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), sharePrivateExperience (copy), Logger (copy)
		sendBuildExperienceEvent("PLAYTEST_SHARE_CLICK", {
			universeId = universeId
		}, {
			source = "management_page"
		})
		sharePrivateExperience(universeId):catch(function(p3) -- line: 76
			-- upvalues: Logger (copy), universeId (copy)
			Logger:warning("PrivateInvitesManagement: share link failed for universe {}: {}", universeId, p3)
		end)
	end, { universeId })
	local v21 = React.useCallback(function() -- line: 81
		-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), t1 (copy)
		sendBuildExperienceEvent("ADD_TO_PLAYTEST_CLICK", {
			universeId = universeId
		}, {
			source = "management_page"
		})
		t1.onOpenInvitePicker()
	end, {
		universeId,
		t1.onOpenInvitePicker
	})
	local v22 = #v16
	local MAX_INVITES = v14.MAX_INVITES

	return {
		title = LocalizationStrings.PRIVATE_INVITES_TITLE,
		countText = LocalizationStrings.formatPrivateInvitesCount(v22, MAX_INVITES),
		subtitle = LocalizationStrings.formatPrivateInvitesSubtitle(MAX_INVITES),
		inviteButtonText = LocalizationStrings.PRIVATE_INVITES_INVITE_BUTTON,
		shareWithFriendsTitle = LocalizationStrings.PRIVATE_INVITES_SHARE_WITH_FRIENDS,
		shareWithFriendsButtonText = LocalizationStrings.PRIVATE_INVITES_SHARE_WITH_FRIENDS_BUTTON,
		onShareLink = v20,
		userIds = v16,
		removingUserIds = v17,
		onRemove = v19,
		isInviteDisabled = MAX_INVITES <= v22,
		onOpenInvitePicker = v21,
		layoutOrder = t1.layoutOrder,
		testId = t1.testId
	}
end

return usePrivateInvitesManagementViewModel
