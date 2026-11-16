local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger

local PrivatePlaytesters = require(parent.DataHydration.PrivatePlaytesters)
local getPrivatePlaytestersStore = PrivatePlaytesters.getPrivatePlaytestersStore
local Friends = require(parent.DataHydration.Friends)
local FriendsStore = Friends.FriendsStore
local searchFriendsAsync = require(script.Parent.searchFriendsAsync)
local useUserPicker = require(BuildExperience.Components.UserPicker.useUserPicker)
require(BuildExperience.Components.UserPicker.UserPickerTypes)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
require(script.Parent.PrivateInvitesPickerView)

local function usePrivateInvitesPickerViewModel(data)
	local universeId = data.universeId

	local v = useLocalization({
		addPlaytester = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTER,
		addPlaytesters = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTERS,
		allFriendsAdded = LocalizationStrings.PRIVATE_INVITES_ALL_FRIENDS_ADDED,
		friendsLoadError = LocalizationStrings.PRIVATE_INVITES_FRIENDS_LOAD_ERROR,
		noFriends = LocalizationStrings.PRIVATE_INVITES_NO_FRIENDS,
		searchPlaceholder = LocalizationStrings.PRIVATE_INVITES_SEARCH_PLACEHOLDER
	})

	local sendButtonText = v.addPlaytester
	local addPlaytesters = v.addPlaytesters
	local allFriendsAdded = v.allFriendsAdded
	local friendsLoadError = v.friendsLoadError
	local emptyText = v.noFriends
	local searchPlaceholder = v.searchPlaceholder
	local onInvitesSent = data.onInvitesSent

	local state, setState = React.useState(false)

	local state2, setState2 = React.useState({ userIds = {}, navigateOnDismiss = false })

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current then
			return
		end

		ref.current = true
		sendBuildExperienceEvent("PLAYTEST_PICKER_IMPRESSION", { universeId = universeId })
	end, { universeId })

	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	local v2 = React.useMemo(function()
		return privatePlaytestersStore.getAndFetchInvitedPlayers(universeId)
	end, { privatePlaytestersStore, universeId })
	local v3 = SignalsReact.useSignalState(v2.players)
	local selectionLimit = SignalsReact.useSignalState(v2.status) ~= "Ready" and 0
		or math.max(0, privatePlaytestersStore.MAX_INVITES - #v3)

	local excludeUserIds = React.useMemo(function()
		local result = {}

		for _, v4 in v3 do
			result[v4] = true
		end

		return result
	end, { v3 })

	local v4 = React.useMemo(function()
		return FriendsStore.get()
	end, {})
	local v5 = React.useMemo(function()
		return v4.GetAllFriends()
	end, { v4 })
	local v6 = React.useMemo(function()
		return v4.GetAllFriendsStatus()
	end, { v4 })
	local v7 = SignalsReact.useSignalState(v5)
	local v8 = SignalsReact.useSignalState(v6)

	local browseIds = React.useMemo(function()
		local ids = {}

		if v7 == nil then
			return ids
		end

		for _, friend in v7.friends do
			local id = tonumber(friend.id)

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		return ids
	end, { v7 })
	local browseIsLoading = v8 == "NotReady"
	local loadMoreBrowse = React.useCallback(function()
		v4.FetchMoreFriends()
	end, { v4 })

	local onSearch = React.useCallback(function(p: string, p2: string?)
		return searchFriendsAsync(p, p2, 20)
	end, {})

	local onSubmit = React.useCallback(function(list, p: string?)
		return privatePlaytestersStore.sendInvites(universeId, list, p):andThen(function(p2)
			local added = p2.added

			local rejected = p2.rejected
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
		end):catch(function(p2)
			sendBuildExperienceEvent("PLAYTESTERS_ADD_FAILED", { universeId = universeId }, {
				count = tostring(#list)
			})

			Logger:warning("PrivateInvitesPicker: add playtesters failed for universe {}: {}", universeId, p2)
			setState(true)
		end)
	end, { privatePlaytestersStore, universeId, onInvitesSent })

	local onDismissAddError = React.useCallback(function()
		setState(false)
	end, {})

	local onDismissRejectedInvite = React.useCallback(function()
		local navigateOnDismiss = state2.navigateOnDismiss
		setState2({ userIds = {}, navigateOnDismiss = false })

		if navigateOnDismiss then
			onInvitesSent()
		end
	end, { state2, onInvitesSent })

	local v9 = useUserPicker((React.useMemo(function()
		return {
			browseIds = browseIds,
			browseIsLoading = browseIsLoading,
			loadMoreBrowse = loadMoreBrowse,
			onSearch = onSearch,
			onSubmit = onSubmit,
			selectionLimit = selectionLimit,
			excludeUserIds = excludeUserIds
		}
	end, {
		browseIds,
		browseIsLoading,
		loadMoreBrowse,
		onSearch,
		onSubmit,
		selectionLimit,
		excludeUserIds
	})))

	local state3, setState3 = React.useState(true)
	local onRequestClose = React.useCallback(function()
		setState3(false)
	end, {})

	local state4, setState4 = React.useState(nil)

	local scrollingFrameRef = React.useCallback(function(p)
		setState4(p)
	end, {})
	local loadMore = v9.loadMore
	React.useEffect(function()
		if state4 == nil then
			return
		end

		local v10 = state4
		local function maybeLoadMore() -- 1 equivalent call inferred from this helper
			local v11 = v10.AbsoluteCanvasSize.Y - (v10.CanvasPosition.Y + v10.AbsoluteWindowSize.Y)

			if v10.AbsoluteCanvasSize.Y > 0 and v11 <= 240 then
				loadMore()
			end
		end
		local canvasPositionChangedConnection = v10:GetPropertyChangedSignal("CanvasPosition"):Connect(maybeLoadMore)
		local absoluteCanvasSizeChangedConnection = v10:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(maybeLoadMore)
		local absoluteWindowSizeChangedConnection = v10:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(maybeLoadMore)
		maybeLoadMore() -- inferred equivalent call
		return function()
			canvasPositionChangedConnection:Disconnect()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { state4, loadMore })

	local v10 = {
		isOpen = state3,
		onClose = data.onClose,
		onRequestClose = onRequestClose,
		scrollingFrameRef = scrollingFrameRef,
		searchText = v9.searchText,
		setSearchText = v9.setSearchText,
		searchPlaceholder = searchPlaceholder,
		userIds = v9.userIds,
		isLoading = v9.isLoading,
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

	if v8 == "Failed" then
		emptyText = friendsLoadError
	elseif #browseIds > 0 then
		emptyText = allFriendsAdded
	end

	v10.emptyText = emptyText

	v10.isSelected = v9.isSelected
	v10.canSelect = v9.canSelect
	v10.toggleSelected = v9.toggleSelected
	v10.hasSelection = v9.hasSelection
	v10.submit = v9.submit
	v10.isSubmitting = v9.isSubmitting

	if v9.selectedCount > 1 then
		sendButtonText = addPlaytesters
	end

	v10.sendButtonText = sendButtonText

	v10.hasAddError = state
	v10.onDismissAddError = onDismissAddError

	v10.rejectedInviteUserIds = state2.userIds
	v10.onDismissRejectedInvite = onDismissRejectedInvite
	v10.testId = data.testId
	return v10
end

return usePrivateInvitesPickerViewModel
