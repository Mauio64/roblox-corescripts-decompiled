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
local useBuildPageImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useBuildPageImpression")
local FFlagBuildExperiencePageImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePageImpressions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerView")
local FFlagBuildExperiencePlaytesterAddTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePlaytesterAddTelemetry")

local v5 = {
	[1] = "invalid_universe",
	[2] = "unauthorized",
	[48] = "invalid_request",
	[49] = "limit_exceeded",
	[50] = "update_failed",
	[51] = "safety_check"
}

local function getAddFailureParameters(p2, p3)
	if type(p2) ~= "table" then
		p2 = nil
	end

	local responseCode = if p2 ~= nil then tonumber(p2.responseCode) else nil
	local response = if not (p2 == nil or type(p2.response) ~= "table") then p2.response else nil

	local statusCode = if response ~= nil then tonumber(response.statusCode) else nil

	local addFailureParameters = {
		count = tostring(p3),
		reason = responseCode == nil and "unknown" or v5[responseCode] or "unknown"
	}

	if responseCode ~= nil then
		addFailureParameters.errorCode = tostring(responseCode)
	end

	if statusCode ~= nil then
		addFailureParameters.httpStatus = tostring(statusCode)
	end

	return addFailureParameters
end

local function usePrivateInvitesPickerViewModel(data)
	local universeId = data.universeId

	local v6 = useLocalization({
		addPlaytester = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTER,
		addPlaytesters = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTERS,
		allFriendsAdded = LocalizationStrings.PRIVATE_INVITES_ALL_FRIENDS_ADDED,
		friendsLoadError = LocalizationStrings.PRIVATE_INVITES_FRIENDS_LOAD_ERROR,
		noFriends = LocalizationStrings.PRIVATE_INVITES_NO_FRIENDS,
		searchPlaceholder = LocalizationStrings.PRIVATE_INVITES_SEARCH_PLACEHOLDER
	})

	local v7 = v6.addPlaytester
	local addPlaytesters = v6.addPlaytesters
	local allFriendsAdded = v6.allFriendsAdded
	local friendsLoadError = v6.friendsLoadError
	local v8 = v6.noFriends
	local searchPlaceholder = v6.searchPlaceholder
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

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("invite-picker", { universeId = universeId })
	end

	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	local v9 = React.useMemo(function()
		return privatePlaytestersStore.getAndFetchInvitedPlayers(universeId)
	end, { privatePlaytestersStore, universeId })
	local v10 = SignalsReact.useSignalState(v9.players)
	local v11 = SignalsReact.useSignalState(v9.status)

	local v12 = v11 ~= "Ready" and 0 or math.max(0, privatePlaytestersStore.MAX_INVITES - #v10)

	local v13 = React.useMemo(function()
		local result = {}

		for k, v14 in v10 do
			result[v14] = true
		end

		return result
	end, { v10 })

	local v14 = React.useMemo(function()
		return friendsStore.get()
	end, {})
	local v15 = React.useMemo(function()
		return v14.GetAllFriends()
	end, { v14 })
	local v16 = React.useMemo(function()
		return v14.GetAllFriendsStatus()
	end, { v14 })
	local v17 = SignalsReact.useSignalState(v15)
	local v18 = SignalsReact.useSignalState(v16)

	local v19 = React.useMemo(function()
		local ids = {}

		if v17 == nil then
			return ids
		end

		for k, friend in v17.friends do
			local id = tonumber(friend.id)

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		return ids
	end, { v17 })
	local v20 = v18 == "NotReady"
	local v21 = React.useCallback(function()
		v14.FetchMoreFriends()
	end, { v14 })

	local v22 = React.useCallback(function(p2, p3)
		return searchFriendsAsync(p2, p3, 20)
	end, {})
	local ref2

	if FFlagBuildExperiencePlaytesterAddTelemetry then
		ref2 = React.useRef({
			searched = false,
			addAttempts = 0,
			addFailures = 0,
			addedCount = 0,
			dismissReported = false
		})
	else
		ref2 = nil
	end

	local v23 = React.useCallback(function(list, p2)
		if FFlagBuildExperiencePlaytesterAddTelemetry and ref2 ~= nil then
			ref2.current.addAttempts += 1
		end

		return privatePlaytestersStore.sendInvites(universeId, list, p2):andThen(function(p3)
			local added = p3.added

			if FFlagBuildExperiencePlaytesterAddTelemetry and ref2 ~= nil then
				ref2.current.addedCount += #added
			end

			local rejected = p3.rejected
			local v27 = {
				count = tostring(#added),
				rejectedCount = 0,
				requestedCount = 0
			}

			local v28 = if FFlagBuildExperiencePlaytesterAddTelemetry then tostring(#rejected) else nil
			v27.rejectedCount = v28

			local v29 = if FFlagBuildExperiencePlaytesterAddTelemetry then tostring(#list) else nil
			v27.requestedCount = v29
			sendBuildExperienceEvent("PLAYTESTERS_ADDED", { universeId = universeId }, v27)

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
			if FFlagBuildExperiencePlaytesterAddTelemetry and ref2 ~= nil then
				ref2.current.addFailures += 1
			end

			local v27 = if FFlagBuildExperiencePlaytesterAddTelemetry then getAddFailureParameters(p3, #list) else {
				count = tostring(#list)
			}
			sendBuildExperienceEvent("PLAYTESTERS_ADD_FAILED", { universeId = universeId }, v27)

			logger:warning(
				"PrivateInvitesPicker: add playtesters failed for universe {}: {}",
				universeId,
				p3
			)
			setState(true)
		end)
	end, { privatePlaytestersStore, universeId, onInvitesSent })

	local v24 = React.useCallback(function()
		setState(false)
	end, {})

	local v25 = React.useCallback(function()
		local navigateOnDismiss = state2.navigateOnDismiss
		setState2({ userIds = {}, navigateOnDismiss = false })

		if navigateOnDismiss then
			onInvitesSent()
		end
	end, { state2, onInvitesSent })

	local v27 = useUserPicker((React.useMemo(function()
		return {
			browseIds = v19,
			browseIsLoading = v20,
			loadMoreBrowse = v21,
			onSearch = v22,
			onSubmit = v23,
			selectionLimit = v12,
			excludeUserIds = v13
		}
	end, { v19, v20, v21, v22, v23, v12, v13 })))

	local v28 = if FFlagBuildExperiencePlaytesterAddTelemetry then string.find(v27.searchText, "%S") ~= nil else nil

	if FFlagBuildExperiencePlaytesterAddTelemetry then
		React.useEffect(function()
			if ref2 ~= nil and v28 then
				ref2.current.searched = true
			end
		end, { v28 })
	end

	local onClose = data.onClose
	local selectedCount = v27.selectedCount
	local v29 = FFlagBuildExperiencePlaytesterAddTelemetry and #v27.userIds or nil
	local v30

	if FFlagBuildExperiencePlaytesterAddTelemetry then
		v30 = React.useCallback(function()
			local current = if ref2 ~= nil then ref2.current else nil

			if current ~= nil and not current.dismissReported then
				current.dismissReported = true
				local count = 0

				for k, v31 in v19 do
					if not v13[v31] then
						count += 1
					end
				end

				local v31 = v18 == "Failed" and "load_error"
					or v20 and "loading"
					or v11 == "Failed" and "invited_load_error"
					or v11 == "Ready"
					and (#v19 == 0 and "no_friends" or count == 0 and "all_added" or "none")
					or "invited_loading"

				sendBuildExperienceEvent("PLAYTEST_PICKER_DISMISSED", { universeId = universeId }, {
					friendsLoaded = tostring(#v19),
					availableCount = tostring(count),
					invitedCount = tostring(#v10),
					selectedCount = tostring(selectedCount),
					emptyState = v31,
					searched = current.searched and "true" or "false",
					searchActive = v28 and "true" or "false",
					visibleCount = tostring(v29),
					addAttempts = tostring(current.addAttempts),
					addFailures = tostring(current.addFailures),
					addedCount = tostring(current.addedCount)
				})
			end

			onClose()
		end, {
			v19,
			v13,
			v18,
			v20,
			v11,
			v10,
			selectedCount,
			v28,
			v29,
			universeId,
			onClose
		})
	end

	local state3, setState3 = React.useState(true)
	local v31 = React.useCallback(function()
		setState3(false)
	end, {})

	local state4, setState4 = React.useState(nil)

	local v32 = React.useCallback(function(p2)
		setState4(p2)
	end, {})
	local loadMore = v27.loadMore
	React.useEffect(function()
		if state4 == nil then
			return
		end

		local v33 = state4
		local function maybeLoadMore()
			local v34 = v33.AbsoluteCanvasSize.Y - (v33.CanvasPosition.Y + v33.AbsoluteWindowSize.Y)

			if v33.AbsoluteCanvasSize.Y > 0 and v34 <= 240 then
				loadMore()
			end
		end
		local canvasPositionChangedConnection = v33:GetPropertyChangedSignal("CanvasPosition"):Connect(maybeLoadMore)
		local absoluteCanvasSizeChangedConnection = v33:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(maybeLoadMore)
		local absoluteWindowSizeChangedConnection = v33:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(maybeLoadMore)
		local v34 = v33.AbsoluteCanvasSize.Y - (v33.CanvasPosition.Y + v33.AbsoluteWindowSize.Y)

		if v33.AbsoluteCanvasSize.Y > 0 and v34 <= 240 then
			loadMore()
		end

		return function()
			canvasPositionChangedConnection:Disconnect()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { state4, loadMore })

	if not FFlagBuildExperiencePlaytesterAddTelemetry or v30 == nil then
		v30 = data.onClose
	end

	local v33 = {
		isOpen = state3,
		onClose = v30,
		onRequestClose = v31,
		scrollingFrameRef = v32,
		searchText = v27.searchText,
		setSearchText = v27.setSearchText,
		searchPlaceholder = searchPlaceholder,
		userIds = v27.userIds,
		isLoading = v27.isLoading,
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

	if v18 == "Failed" then
		v8 = friendsLoadError
	elseif #v19 > 0 then
		v8 = allFriendsAdded
	end

	v33.emptyText = v8

	v33.isSelected = v27.isSelected
	v33.canSelect = v27.canSelect
	v33.toggleSelected = v27.toggleSelected
	v33.hasSelection = v27.hasSelection
	v33.submit = v27.submit
	v33.isSubmitting = v27.isSubmitting

	if v27.selectedCount > 1 then
		v7 = addPlaytesters
	end

	v33.sendButtonText = v7

	v33.hasAddError = state
	v33.onDismissAddError = v24

	v33.rejectedInviteUserIds = state2.userIds
	v33.onDismissRejectedInvite = v25
	v33.testId = data.testId
	return v33
end

return usePrivateInvitesPickerViewModel
