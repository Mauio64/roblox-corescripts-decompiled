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
local useBuildPageImpression = require(BuildExperience.Telemetry.useBuildPageImpression)
local FFlagBuildExperiencePageImpressions = require(BuildExperience.Flags.FFlagBuildExperiencePageImpressions)
require(script.Parent.PrivateInvitesPickerView)
local FFlagBuildExperiencePlaytesterAddTelemetry = require(BuildExperience.Flags.FFlagBuildExperiencePlaytesterAddTelemetry)

local v = {
	[1] = "invalid_universe",
	[2] = "unauthorized",
	[48] = "invalid_request",
	[49] = "limit_exceeded",
	[50] = "update_failed",
	[51] = "safety_check"
}

local function getAddFailureParameters(p, p2: number)
	if type(p) ~= "table" then
		p = nil
	end

	local responseCode

	if p ~= nil then
		responseCode = tonumber(p.responseCode)
	end

	local response

	if not (p == nil or type(p.response) ~= "table") then
		response = p.response
	end

	local statusCode

	if response ~= nil then
		statusCode = tonumber(response.statusCode)
	end

	local addFailureParameters = {
		count = tostring(p2),
		reason = responseCode == nil and "unknown" or v[responseCode] or "unknown"
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

	local v2 = useLocalization({
		addPlaytester = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTER,
		addPlaytesters = LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTERS,
		allFriendsAdded = LocalizationStrings.PRIVATE_INVITES_ALL_FRIENDS_ADDED,
		friendsLoadError = LocalizationStrings.PRIVATE_INVITES_FRIENDS_LOAD_ERROR,
		noFriends = LocalizationStrings.PRIVATE_INVITES_NO_FRIENDS,
		searchPlaceholder = LocalizationStrings.PRIVATE_INVITES_SEARCH_PLACEHOLDER
	})

	local sendButtonText = v2.addPlaytester
	local addPlaytesters = v2.addPlaytesters
	local allFriendsAdded = v2.allFriendsAdded
	local friendsLoadError = v2.friendsLoadError
	local emptyText = v2.noFriends
	local searchPlaceholder = v2.searchPlaceholder
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

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("invite-picker", { universeId = universeId })
	end

	local privatePlaytestersStore = getPrivatePlaytestersStore(false)
	local v3 = React.useMemo(function()
		return privatePlaytestersStore.getAndFetchInvitedPlayers(universeId)
	end, { privatePlaytestersStore, universeId })
	local v4 = SignalsReact.useSignalState(v3.players)
	local v5 = SignalsReact.useSignalState(v3.status)

	local selectionLimit = v5 ~= "Ready" and 0 or math.max(0, privatePlaytestersStore.MAX_INVITES - #v4)

	local excludeUserIds = React.useMemo(function()
		local result = {}

		for _, v6 in v4 do
			result[v6] = true
		end

		return result
	end, { v4 })

	local v6 = React.useMemo(function()
		return FriendsStore.get()
	end, {})
	local v7 = React.useMemo(function()
		return v6.GetAllFriends()
	end, { v6 })
	local v8 = React.useMemo(function()
		return v6.GetAllFriendsStatus()
	end, { v6 })
	local v9 = SignalsReact.useSignalState(v7)
	local v10 = SignalsReact.useSignalState(v8)

	local browseIds = React.useMemo(function()
		local ids = {}

		if v9 == nil then
			return ids
		end

		for _, friend in v9.friends do
			local id = tonumber(friend.id)

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		return ids
	end, { v9 })
	local browseIsLoading = v10 == "NotReady"
	local loadMoreBrowse = React.useCallback(function()
		v6.FetchMoreFriends()
	end, { v6 })

	local onSearch = React.useCallback(function(p: string, p2: string?)
		return searchFriendsAsync(p, p2, 20)
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

	local onSubmit = React.useCallback(function(list, p: string?)
		if FFlagBuildExperiencePlaytesterAddTelemetry and ref2 ~= nil then
			ref2.current.addAttempts += 1
		end

		return privatePlaytestersStore.sendInvites(universeId, list, p):andThen(function(p2)
			local added = p2.added

			if FFlagBuildExperiencePlaytesterAddTelemetry and ref2 ~= nil then
				ref2.current.addedCount += #added
			end

			local rejected = p2.rejected
			local v11 = {
				count = tostring(#added),
				rejectedCount = 0,
				requestedCount = 0
			}
			local rejectedCount

			if FFlagBuildExperiencePlaytesterAddTelemetry then
				rejectedCount = tostring(#rejected)
			end

			v11.rejectedCount = rejectedCount
			local requestedCount

			if FFlagBuildExperiencePlaytesterAddTelemetry then
				requestedCount = tostring(#list)
			end

			v11.requestedCount = requestedCount
			sendBuildExperienceEvent("PLAYTESTERS_ADDED", { universeId = universeId }, v11)

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
			if FFlagBuildExperiencePlaytesterAddTelemetry and ref2 ~= nil then
				ref2.current.addFailures += 1
			end

			local v11

			if FFlagBuildExperiencePlaytesterAddTelemetry then
				v11 = getAddFailureParameters(p2, #list)
			else
				v11 = {
					count = tostring(#list)
				}
			end

			sendBuildExperienceEvent("PLAYTESTERS_ADD_FAILED", { universeId = universeId }, v11)

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

	local v11 = useUserPicker((React.useMemo(function()
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
	local v12

	if FFlagBuildExperiencePlaytesterAddTelemetry then
		v12 = string.find(v11.searchText, "%S") ~= nil
	else
		v12 = nil
	end

	if FFlagBuildExperiencePlaytesterAddTelemetry then
		React.useEffect(function()
			if ref2 ~= nil and v12 then
				ref2.current.searched = true
			end
		end, { v12 })
	end

	local onClose = data.onClose
	local selectedCount = v11.selectedCount
	local v13 = FFlagBuildExperiencePlaytesterAddTelemetry and #v11.userIds or nil
	local onClose2

	if FFlagBuildExperiencePlaytesterAddTelemetry then
		onClose2 = React.useCallback(function()
			local current

			if ref2 ~= nil then
				current = ref2.current
			end

			if current ~= nil and not current.dismissReported then
				current.dismissReported = true
				local count = 0

				for _, v14 in browseIds do
					if not excludeUserIds[v14] then
						count += 1
					end
				end

				local emptyState = v10 == "Failed" and "load_error"
					or browseIsLoading and "loading"
					or v5 == "Failed" and "invited_load_error"
					or v5 == "Ready" and (#browseIds == 0 and "no_friends" or count == 0 and "all_added" or "none")
					or "invited_loading"

				sendBuildExperienceEvent("PLAYTEST_PICKER_DISMISSED", { universeId = universeId }, {
					friendsLoaded = tostring(#browseIds),
					availableCount = tostring(count),
					invitedCount = tostring(#v4),
					selectedCount = tostring(selectedCount),
					emptyState = emptyState,
					searched = current.searched and "true" or "false",
					searchActive = v12 and "true" or "false",
					visibleCount = tostring(v13),
					addAttempts = tostring(current.addAttempts),
					addFailures = tostring(current.addFailures),
					addedCount = tostring(current.addedCount)
				})
			end

			onClose()
		end, {
			browseIds,
			excludeUserIds,
			v10,
			browseIsLoading,
			v5,
			v4,
			selectedCount,
			v12,
			v13,
			universeId,
			onClose
		})
	end

	local state3, setState3 = React.useState(true)
	local onRequestClose = React.useCallback(function()
		setState3(false)
	end, {})

	local state4, setState4 = React.useState(nil)

	local scrollingFrameRef = React.useCallback(function(p)
		setState4(p)
	end, {})
	local loadMore = v11.loadMore
	React.useEffect(function()
		if state4 == nil then
			return
		end

		local v14 = state4
		local function maybeLoadMore() -- 1 equivalent call inferred from this helper
			local v15 = v14.AbsoluteCanvasSize.Y - (v14.CanvasPosition.Y + v14.AbsoluteWindowSize.Y)

			if v14.AbsoluteCanvasSize.Y > 0 and v15 <= 240 then
				loadMore()
			end
		end
		local canvasPositionChangedConnection = v14:GetPropertyChangedSignal("CanvasPosition"):Connect(maybeLoadMore)
		local absoluteCanvasSizeChangedConnection = v14:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(maybeLoadMore)
		local absoluteWindowSizeChangedConnection = v14:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(maybeLoadMore)
		maybeLoadMore() -- inferred equivalent call
		return function()
			canvasPositionChangedConnection:Disconnect()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { state4, loadMore })

	if not FFlagBuildExperiencePlaytesterAddTelemetry or onClose2 == nil then
		onClose2 = data.onClose
	end

	local v14 = {
		isOpen = state3,
		onClose = onClose2,
		onRequestClose = onRequestClose,
		scrollingFrameRef = scrollingFrameRef,
		searchText = v11.searchText,
		setSearchText = v11.setSearchText,
		searchPlaceholder = searchPlaceholder,
		userIds = v11.userIds,
		isLoading = v11.isLoading,
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

	if v10 == "Failed" then
		emptyText = friendsLoadError
	elseif #browseIds > 0 then
		emptyText = allFriendsAdded
	end

	v14.emptyText = emptyText

	v14.isSelected = v11.isSelected
	v14.canSelect = v11.canSelect
	v14.toggleSelected = v11.toggleSelected
	v14.hasSelection = v11.hasSelection
	v14.submit = v11.submit
	v14.isSubmitting = v11.isSubmitting

	if v11.selectedCount > 1 then
		sendButtonText = addPlaytesters
	end

	v14.sendButtonText = sendButtonText

	v14.hasAddError = state
	v14.onDismissAddError = onDismissAddError

	v14.rejectedInviteUserIds = state2.userIds
	v14.onDismissRejectedInvite = onDismissRejectedInvite
	v14.testId = data.testId
	return v14
end

return usePrivateInvitesPickerViewModel
