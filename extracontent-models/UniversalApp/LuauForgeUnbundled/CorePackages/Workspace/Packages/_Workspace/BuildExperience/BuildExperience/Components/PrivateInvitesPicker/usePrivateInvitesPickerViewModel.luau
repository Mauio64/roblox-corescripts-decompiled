local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Loggers").Logger

local getPrivatePlaytestersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PrivatePlaytesters").getPrivatePlaytestersStore
local friendsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/Friends").FriendsStore
local searchFriendsAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/searchFriendsAsync")
local useUserPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/useUserPicker")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/UserPickerTypes")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerView")

local function usePrivateInvitesPickerViewModel(data)
	local universeId = data.universeId

	local v5 = useLocalization({
		addPlaytester = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTER,
		addPlaytesters = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTERS,
		allFriendsAdded = LocalizationStrings.PRIVATE_INVITES_ALL_FRIENDS_ADDED,
		friendsLoadError = LocalizationStrings.PRIVATE_INVITES_FRIENDS_LOAD_ERROR,
		noFriends = LocalizationStrings.PRIVATE_INVITES_NO_FRIENDS,
		searchPlaceholder = LocalizationStrings.PRIVATE_INVITES_SEARCH_PLACEHOLDER
	})

	local v6 = v5.addPlaytester
	local addPlaytesters = v5.addPlaytesters
	local allFriendsAdded = v5.allFriendsAdded
	local friendsLoadError = v5.friendsLoadError
	local v7 = v5.noFriends
	local searchPlaceholder = v5.searchPlaceholder
	local onInvitesSent = data.onInvitesSent

	local state, setState = React.useState(false)

	local state2, setState2 = React.useState({
		userIds = {},
		navigateOnDismiss = false
	})

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current then
			return
		end

		ref.current = true
		sendBuildExperienceEvent("PLAYTEST_PICKER_IMPRESSION", { universeId = universeId })
	end, { universeId })

	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	local v8 = React.useMemo(function()
		return privatePlaytestersStore.getAndFetchInvitedPlayers(universeId)
	end, { privatePlaytestersStore, universeId })
	local v9 = SignalsReact.useSignalState(v8.players)
	local v10 = SignalsReact.useSignalState(v8.status) ~= "Ready" and 0
		or math.max(0, privatePlaytestersStore.MAX_INVITES - #v9)

	local v11 = React.useMemo(function()
		local result = {}

		for k, v12 in v9 do
			result[v12] = true
		end

		return result
	end, { v9 })

	local v12 = React.useMemo(function()
		return friendsStore.get()
	end, {})
	local v13 = React.useMemo(function()
		return v12.GetAllFriends()
	end, { v12 })
	local v14 = React.useMemo(function()
		return v12.GetAllFriendsStatus()
	end, { v12 })
	local v15 = SignalsReact.useSignalState(v13)
	local v16 = SignalsReact.useSignalState(v14)

	local v17 = React.useMemo(function()
		local ids = {}

		if v15 == nil then
			return ids
		end

		for k, friend in v15.friends do
			local id = tonumber(friend.id)

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		return ids
	end, { v15 })
	local v18 = v16 == "NotReady"
	local v19 = React.useCallback(function()
		v12.FetchMoreFriends()
	end, { v12 })

	local v20 = React.useCallback(function(p2, p3)
		return searchFriendsAsync(p2, p3, 20)
	end, {})

	local v21 = React.useCallback(function(list, p2)
		return privatePlaytestersStore.sendInvites(universeId, list, p2):andThen(function(p3)
			local added = p3.added

			local rejected = p3.rejected
			sendBuildExperienceEvent("PLAYTESTERS_ADDED", { universeId = universeId }, {
				count = tostring(#added)
			})

			if #added == 0 then
				if #rejected > 0 then
					setState2({ userIds = rejected, navigateOnDismiss = false })
				else
					onInvitesSent()
				end
			elseif #rejected > 0 then
				setState2({ userIds = rejected, navigateOnDismiss = true })
			else
				onInvitesSent()
			end
		end):catch(function(p3)
			sendBuildExperienceEvent("PLAYTESTERS_ADD_FAILED", { universeId = universeId }, {
				count = tostring(#list)
			})

			logger:warning(
				"PrivateInvitesPicker: add playtesters failed for universe {}: {}",
				universeId,
				p3
			)
			setState(true)
		end)
	end, { privatePlaytestersStore, universeId, onInvitesSent })

	local v22 = React.useCallback(function()
		setState(false)
	end, {})

	local v23 = React.useCallback(function()
		local navigateOnDismiss = state2.navigateOnDismiss
		setState2({ userIds = {}, navigateOnDismiss = false })

		if navigateOnDismiss then
			onInvitesSent()
		end
	end, { state2, onInvitesSent })

	local v25 = useUserPicker((React.useMemo(function()
		return {
			browseIds = v17,
			browseIsLoading = v18,
			loadMoreBrowse = v19,
			onSearch = v20,
			onSubmit = v21,
			selectionLimit = v10,
			excludeUserIds = v11
		}
	end, { v17, v18, v19, v20, v21, v10, v11 })))

	local state3, setState3 = React.useState(true)
	local v26 = React.useCallback(function()
		setState3(false)
	end, {})

	local state4, setState4 = React.useState(nil)

	local v27 = React.useCallback(function(p2)
		setState4(p2)
	end, {})
	local loadMore = v25.loadMore
	React.useEffect(function()
		if state4 == nil then
			return
		end

		local v28 = state4
		local function maybeLoadMore()
			local v29 = v28.AbsoluteCanvasSize.Y - (v28.CanvasPosition.Y + v28.AbsoluteWindowSize.Y)

			if v28.AbsoluteCanvasSize.Y > 0 and v29 <= 240 then
				loadMore()
			end
		end
		local canvasPositionChangedConnection = v28:GetPropertyChangedSignal("CanvasPosition"):Connect(maybeLoadMore)
		local absoluteCanvasSizeChangedConnection = v28:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(maybeLoadMore)
		local absoluteWindowSizeChangedConnection = v28:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(maybeLoadMore)
		local v29 = v28.AbsoluteCanvasSize.Y - (v28.CanvasPosition.Y + v28.AbsoluteWindowSize.Y)

		if v28.AbsoluteCanvasSize.Y > 0 and v29 <= 240 then
			loadMore()
		end

		return function()
			canvasPositionChangedConnection:Disconnect()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { state4, loadMore })

	local v28 = {
		isOpen = state3,
		onClose = data.onClose,
		onRequestClose = v26,
		scrollingFrameRef = v27,
		searchText = v25.searchText,
		setSearchText = v25.setSearchText,
		searchPlaceholder = searchPlaceholder,
		userIds = v25.userIds,
		isLoading = v25.isLoading,
		emptyText = 0,
		isSelected = 0,
		canSelect = 0,
		toggleSelected = 0,
		hasSelection = 0,
		submit = 0,
		isSubmitting = 0,
		sendButtonText = 0,
		hasAddError = 0,
		onDismissAddError = 0,
		rejectedInviteUserIds = 0,
		onDismissRejectedInvite = 0,
		testId = 0
	}

	if v16 == "Failed" then
		v7 = friendsLoadError
	elseif #v17 > 0 then
		v7 = allFriendsAdded
	end

	v28.emptyText = v7

	v28.isSelected = v25.isSelected
	v28.canSelect = v25.canSelect
	v28.toggleSelected = v25.toggleSelected
	v28.hasSelection = v25.hasSelection
	v28.submit = v25.submit
	v28.isSubmitting = v25.isSubmitting

	if v25.selectedCount > 1 then
		v6 = addPlaytesters
	end

	v28.sendButtonText = v6

	v28.hasAddError = state
	v28.onDismissAddError = v22

	v28.rejectedInviteUserIds = state2.userIds
	v28.onDismissRejectedInvite = v23
	v28.testId = data.testId
	return v28
end

return usePrivateInvitesPickerViewModel
