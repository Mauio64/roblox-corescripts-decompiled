local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local getPrivatePlaytestersStore = require(BuildExperienceParent.DataHydration.PrivatePlaytesters).getPrivatePlaytestersStore
local FriendsStore = require(BuildExperienceParent.DataHydration.Friends).FriendsStore
local searchFriendsAsync = require(script.Parent.searchFriendsAsync)
local useUserPicker = require(BuildExperience.Components.UserPicker.useUserPicker)

require(BuildExperience.Components.UserPicker.UserPickerTypes)

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

require(script.Parent.PrivateInvitesPickerView)

local function usePrivateInvitesPickerViewModel(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), sendBuildExperienceEvent (copy), getPrivatePlaytestersStore (copy), SignalsReact (copy), FriendsStore (copy), searchFriendsAsync (copy), useUserPicker (copy), LocalizationStrings (copy)
	local universeId = t1.universeId
	local onInvitesSent = t1.onInvitesSent
	local v15 = React.useRef(false)

	React.useEffect(function() -- line: 44
		-- upvalues: v15 (copy), sendBuildExperienceEvent (copy), universeId (copy)
		if v15.current then
			return
		end

		v15.current = true
		sendBuildExperienceEvent("PLAYTEST_PICKER_IMPRESSION", {
			universeId = universeId
		})
	end, { universeId })

	local v16 = getPrivatePlaytestersStore(false)
	local v17 = React.useMemo(function() -- line: 53
		-- upvalues: v16 (copy), universeId (copy)
		return v16.getAndFetchInvitedPlayers(universeId)
	end, {
		v16,
		universeId
	})
	local v18 = SignalsReact.useSignalState(v17.players)
	local v19 = SignalsReact.useSignalState(v17.status) ~= "Ready" and 0 or math.max(0, v16.MAX_INVITES - #v18)
	local v20 = React.useMemo(function() -- line: 66
		-- upvalues: v18 (copy)
		local t2 = {}

		for _, v42 in v18 do
			t2[v42] = true
		end

		return t2
	end, { v18 })
	local v21 = React.useMemo(function() -- line: 76
		-- upvalues: FriendsStore (copy)
		return FriendsStore.get()
	end, {})
	local v22 = React.useMemo(function() -- line: 79
		-- upvalues: v21 (copy)
		return v21.GetAllFriends()
	end, { v21 })
	local v23 = React.useMemo(function() -- line: 82
		-- upvalues: v21 (copy)
		return v21.GetAllFriendsStatus()
	end, { v21 })
	local v24 = SignalsReact.useSignalState(v22)
	local v25 = SignalsReact.useSignalState(v23)
	local v26 = React.useMemo(function() -- line: 88
		-- upvalues: v24 (copy)
		local t3 = {}

		if v24 ~= nil then
			for _, v45 in v24.friends do
				local num = tonumber(v45.id)

				if num ~= nil then
					table.insert(t3, num)
				end
			end
		end

		return t3
	end, { v24 })
	local v27 = v25 == "NotReady"
	local v28 = React.useCallback(function() -- line: 102
		-- upvalues: v21 (copy)
		v21.FetchMoreFriends()
	end, { v21 })
	local v29 = React.useCallback(function(s1: string, s2: string?) -- line: 108
		-- upvalues: searchFriendsAsync (copy)
		return searchFriendsAsync(s1, s2, 20)
	end, {})
	local v30 = React.useCallback(function(t4: {[any]: any}, s3: string?) -- line: 112
		-- upvalues: v16 (copy), universeId (copy), sendBuildExperienceEvent (copy), onInvitesSent (copy)
		return v16.sendInvites(universeId, t4, s3):andThen(function() -- line: 115
			-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), t4 (copy), onInvitesSent (copy)
			sendBuildExperienceEvent("PLAYTESTERS_ADDED", {
				universeId = universeId
			}, {
				count = tostring(#t4)
			})
			onInvitesSent()
		end):catch(function(p1) -- line: 121
			-- upvalues: sendBuildExperienceEvent (copy), universeId (copy), t4 (copy)
			sendBuildExperienceEvent("PLAYTESTERS_ADD_FAILED", {
				universeId = universeId
			}, {
				count = tostring(#t4)
			})
			error(p1)
		end)
	end, {
		v16,
		universeId,
		onInvitesSent
	})
	local v31 = React.useMemo(function() -- line: 132
		-- upvalues: v26 (copy), v27 (copy), v28 (copy), v29 (copy), v30 (copy), v19 (copy), v20 (copy)
		return {
			browseIds = v26,
			browseIsLoading = v27,
			loadMoreBrowse = v28,
			onSearch = v29,
			onSubmit = v30,
			selectionLimit = v19,
			excludeUserIds = v20
		}
	end, {
		v26,
		v27,
		v28,
		v29,
		v30,
		v19,
		v20
	})
	local v32 = useUserPicker(v31)
	local v33, v34 = React.useState(true)
	local v35 = React.useCallback(function() -- line: 159
		-- upvalues: v34 (copy)
		v34(false)
	end, {})
	local v36, v37 = React.useState(nil)
	local v38 = React.useCallback(function(p2) -- line: 168
		-- upvalues: v37 (copy)
		v37(p2)
	end, {})
	local loadMore = v32.loadMore

	React.useEffect(function() -- line: 172
		-- upvalues: v36 (copy), loadMore (copy)
		if v36 == nil then
			return
		end

		local v52 = v36

		local function maybeLoadMore() -- line: 177
			-- upvalues: v52 (copy), loadMore (copy)
			local v59 = v52.AbsoluteCanvasSize.Y - (v52.CanvasPosition.Y + v52.AbsoluteWindowSize.Y)

			if v52.AbsoluteCanvasSize.Y > 0 and v59 <= 240 then
				loadMore()
			end
		end

		local connection = v52:GetPropertyChangedSignal("CanvasPosition"):Connect(maybeLoadMore)
		local connection2 = v52:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(maybeLoadMore)
		local connection3 = v52:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(maybeLoadMore)
		local v57 = v52.AbsoluteCanvasSize.Y - (v52.CanvasPosition.Y + v52.AbsoluteWindowSize.Y)

		if v52.AbsoluteCanvasSize.Y > 0 and v57 <= 240 then
			loadMore()
		end

		return function() -- line: 188
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		v36,
		loadMore
	})

	return {
		isOpen = v33,
		onClose = t1.onClose,
		onRequestClose = v35,
		scrollingFrameRef = v38,
		searchText = v32.searchText,
		setSearchText = v32.setSearchText,
		searchPlaceholder = LocalizationStrings.PRIVATE_INVITES_SEARCH_PLACEHOLDER,
		userIds = v32.userIds,
		isLoading = v32.isLoading,
		emptyText = if v25 ~= "Failed" then if not (#v26 > 0) then LocalizationStrings.PRIVATE_INVITES_NO_FRIENDS else LocalizationStrings.PRIVATE_INVITES_ALL_FRIENDS_ADDED else LocalizationStrings.PRIVATE_INVITES_FRIENDS_LOAD_ERROR,
		isSelected = v32.isSelected,
		canSelect = v32.canSelect,
		toggleSelected = v32.toggleSelected,
		hasSelection = v32.hasSelection,
		submit = v32.submit,
		isSubmitting = v32.isSubmitting,
		sendButtonText = if not (v32.selectedCount > 1) then LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTER else LocalizationStrings.PRIVATE_INVITES_ADD_PLAYTESTERS,
		testId = t1.testId
	}
end

return usePrivateInvitesPickerViewModel
