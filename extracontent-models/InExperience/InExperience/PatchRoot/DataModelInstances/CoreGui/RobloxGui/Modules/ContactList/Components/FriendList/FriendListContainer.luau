local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local GetFFlagSuggestedCalleeBugFixEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagSuggestedCalleeBugFixEnabled
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local useApolloClient = ApolloClient.useApolloClient
local ContactList = RobloxGui.Modules.ContactList
local dependencies = require(ContactList.dependencies)
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local FindFriendsFromUserId = dependencies.NetworkingFriends.FindFriendsFromUserId
local SearchFriendsByQuery = dependencies.NetworkingFriends.SearchFriendsByQuery
local GetSuggestedCallees = dependencies.NetworkingCall.GetSuggestedCallees
local useStyle = UIBlox.Core.Style.useStyle
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local FriendListItem = require(ContactList.Components.FriendList.FriendListItem)
local SectionHeader = require(ContactList.Components.FriendList.SectionHeader)
local NoItemView = require(ContactList.Components.ContactListCommon.NoItemView)
local Constants = require(ContactList.Components.ContactListCommon.Constants)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v37 = LocalPlayer and LocalPlayer.UserId or 0

local function FriendListContainer(t1: {[any]: any}) -- line: 62
	-- upvalues: useApolloClient (copy), useAnalytics (copy), useDispatch (copy), useStyle (copy), useLocalization (copy), React (copy), RetrievalStatus (copy), GetFFlagSuggestedCalleeBugFixEnabled (copy), GetSuggestedCallees (copy), useSelector (copy), v37 (copy), HttpService (copy), EventNamesEnum (copy), FindFriendsFromUserId (copy), SearchFriendsByQuery (copy), Promise (copy), Cryo (copy), UserProfiles (copy), NoItemView (copy), Constants (copy), SectionHeader (copy), BlockingUtility (copy), FriendListItem (copy), Loading (copy), IconSize (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v40 = useApolloClient()
	local v41 = useAnalytics()
	local v42 = useDispatch()
	local Theme = useStyle().Theme
	local v44 = useLocalization({
		genericErrorLabel = "Feature.Call.Error.Description.Generic",
		noFriendsLabel = "Feature.Call.Description.NoFriendsFound",
		addFriendsLabel = "Feature.Call.Prompt.AddFriends",
		suggestedFriendsTitle = "Feature.Call.Label.Suggested",
		suggestedFriendsDescription = "Feature.Call.Description.SuggestedFriends",
		friendsTitle = "Feature.Call.Label.Friends",
		friendsDescription = "Feature.Call.Description.Friends"
	})
	local v45 = React.useRef(true)
	local v46 = React.useRef(nil)
	local v47 = React.useRef(0)
	local v48, v49 = React.useState(RetrievalStatus.Fetching)
	local v50, v51 = React.useState(false)
	local v52, v53 = React.useState({})
	local v54, v55 = React.useState(nil)
	local v56 = React.useRef("")
	local u57 = if not GetFFlagSuggestedCalleeBugFixEnabled() then React.useRef(v42(GetSuggestedCallees.API()):catch(function() -- line: 97
	end)) else React.useMemo(function() -- line: 93
		-- upvalues: v42 (copy), GetSuggestedCallees (copy)
		return v42(GetSuggestedCallees.API()):catch(function() -- line: 94
		end)
	end, {})
	local v58 = React.useMemo(function() -- line: 100
		-- upvalues: t1 (copy)
		return string.gsub(t1.searchText, "%s+", "")
	end, { t1.searchText })
	local v59 = useSelector(function(p1) -- line: 104
		return p1.LastRemovedFriend.lastRemovedFriendId
	end)
	local v60 = React.useCallback(function(p2, p3) -- line: 110
		-- upvalues: v37 (copy), v45 (copy), v49 (copy), RetrievalStatus (copy), v56 (copy), HttpService (copy), v41 (copy), EventNamesEnum (copy), v58 (copy), v42 (copy), FindFriendsFromUserId (copy), SearchFriendsByQuery (copy), Promise (copy), GetFFlagSuggestedCalleeBugFixEnabled (copy), u57 (ref), Cryo (copy), v40 (copy), UserProfiles (copy), v53 (copy), v55 (copy)
		if v37 then
			v45.current = true
			v49(RetrievalStatus.Fetching)

			local v74 = v56.current ~= "" and 0.5 or 0
			local guid = HttpService:GenerateGUID(false)

			v56.current = guid

			local function v76() -- line: 119
				-- upvalues: v56 (copy), guid (copy), v41 (copy), EventNamesEnum (copy), v58 (copy), v42 (copy), FindFriendsFromUserId (copy), v37 (copy), p3 (copy), SearchFriendsByQuery (copy), Promise (copy), GetFFlagSuggestedCalleeBugFixEnabled (copy), u57 (ref), p2 (copy), Cryo (copy), v40 (copy), UserProfiles (copy), v53 (copy), v55 (copy), v49 (copy), RetrievalStatus (copy)
				if v56.current ~= guid then
					return
				end

				v41.fireEvent(EventNamesEnum.PhoneBookSearchAttempted, {
					eventTimestampMs = os.time() * 1000,
					searchQueryString = v58
				})

				local v104 = v42(if v58 ~= "" then SearchFriendsByQuery.API(v37, {
					userSort = "CombinedName",
					limit = 20,
					cursor = p3,
					query = v58
				}) else FindFriendsFromUserId.API(v37, {
					userSort = "CombinedName",
					limit = 20,
					cursor = p3
				}))

				Promise.all({
					v104,
					if not GetFFlagSuggestedCalleeBugFixEnabled() then u57.current else u57
				}):andThen(function(p4) -- line: 147
					-- upvalues: v56 (copy), guid (copy), v41 (copy), EventNamesEnum (copy), v58 (copy), p2 (copy), Cryo (copy), v40 (copy), UserProfiles (copy), v53 (copy), v55 (copy), v49 (copy), RetrievalStatus (copy)
					if v56.current ~= guid then
						return
					end

					local v107 = p4[1]
					local v108 = p4[2]

					v41.fireEvent(EventNamesEnum.PhoneBookSearchFinished, {
						eventTimestampMs = os.time() * 1000,
						searchQueryString = v58,
						searchResultCount = #v107.responseBody.PageItems
					})

					local t2 = {}

					for _, v in ipairs(p2) do
						table.insert(t2, v)
					end

					for _, v in ipairs(v107.responseBody.PageItems) do
						table.insert(t2, v)
					end

					local v114 = Cryo.List.map(t2, function(p5) -- line: 169
						return (tostring(p5.id))
					end)

					if v58 == "" and v108 ~= nil then
						for _, v in ipairs(v108.responseBody.suggestedCallees) do
							table.insert(v114, (tostring(v.userId)))
						end
					end

					v40:query({
						query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
						variables = {
							userIds = v114
						}
					}):andThen(function() -- line: 188
						-- upvalues: v56 (copy), guid (copy), v53 (copy), t2 (copy), v55 (copy), v107 (copy), v49 (copy), RetrievalStatus (copy)
						if v56.current ~= guid then
							return
						end

						v53(t2)
						v55(v107.responseBody.NextCursor)
						v49(RetrievalStatus.Done)
					end):catch(function(_) -- line: 197
						-- upvalues: v56 (copy), guid (copy), v49 (copy), RetrievalStatus (copy)
						if v56.current ~= guid then
							return
						end

						v49(RetrievalStatus.Failed)
					end)
				end, function() -- line: 203
					-- upvalues: v56 (copy), guid (copy), v49 (copy), RetrievalStatus (copy)
					if v56.current ~= guid then
						return
					end

					v49(RetrievalStatus.Failed)
				end)
			end

			if v74 == 0 then
				v76()

				return
			end

			delay(v74, v76)
		end
	end, {
		v58,
		v59,
		if not GetFFlagSuggestedCalleeBugFixEnabled() then nil else u57
	})

	React.useEffect(function() -- line: 223
		-- upvalues: v60 (copy), v53 (copy), v55 (copy)
		v60({}, "")

		return function() -- line: 226
			-- upvalues: v53 (copy), v55 (copy)
			v53({})
			v55(nil)
		end
	end, { v60 })
	React.useEffect(function() -- line: 233
		-- upvalues: v48 (copy), RetrievalStatus (copy), v45 (copy)
		if v48 ~= RetrievalStatus.Fetching then
			v45.current = false
		end
	end, { v48 })

	local v61 = React.useCallback(function(p7) -- line: 239
		return p7.Call.suggestedCallees.suggestedCallees
	end, {})
	local v62 = useSelector(v61, function(p8, p9) -- line: 245
		if #p8 ~= #p9 then
			return false
		end

		for i, v in ipairs(p8) do
			if v.userId ~= p9[i].userId then
				return false
			end
		end

		return true
	end) or {}
	local v63 = React.useMemo(function() -- line: 261
		-- upvalues: v48 (copy), RetrievalStatus (copy), v44 (copy), t1 (copy), React (copy), NoItemView (copy), v60 (copy), v52 (copy), v54 (copy)
		local v82 = if v48 ~= RetrievalStatus.Failed then if t1.searchText == "" then v44.addFriendsLabel else v44.noFriendsLabel else v44.genericErrorLabel

		return React.createElement(NoItemView, {
			isCallButtonEnabled = false,
			isImageEnabled = v48 ~= RetrievalStatus.Failed,
			imageName = t1.searchText ~= "" and "icons/status/oof_xlarge" or "icons/graphic/findfriends_xlarge",
			isFailedButtonEnabled = v48 == RetrievalStatus.Failed,
			onFailedButtonActivated = function() -- line: 277
				-- upvalues: v60 (copy), v52 (copy), v54 (copy)
				v60(v52, v54)
			end,
			onCallButtonActivated = function() -- line: 281
			end,
			messageText = v82
		})
	end, {
		t1.searchText,
		v52,
		v60,
		v44.addFriendsLabel,
		v44.genericErrorLabel,
		v44.noFriendsLabel,
		v54,
		v48
	})
	local v64 = React.useCallback(function(p10) -- line: 295
		-- upvalues: v47 (copy)
		v47.current = p10.Position.Y
	end, {})
	local v65 = React.useCallback(function(p11) -- line: 299
		-- upvalues: v47 (copy), Constants (copy), v46 (copy), v51 (copy)
		if p11.Position.Y - v47.current > Constants.TOUCH_SLOP and (v46.current and v46.current.CanvasPosition.Y == 0) then
			v51(true)
		end
	end, {})
	local v66 = React.useMemo(function() -- line: 313
		-- upvalues: Cryo (copy), v52 (copy), v62 (copy)
		local v85 = Cryo.List.join(v52, v62)

		return Cryo.List.map(v85, function(p12) -- line: 315
			return (tostring(p12.id or p12.userId))
		end)
	end)
	local v67 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v66,
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v68 = React.useCallback(function() -- line: 325
		-- upvalues: v51 (copy)
		v51(false)
	end, {})
	local v69 = React.useMemo(function() -- line: 329
		-- upvalues: React (copy), v62 (copy), v58 (copy), SectionHeader (copy), v44 (copy), BlockingUtility (copy), v67 (copy), UserProfiles (copy), FriendListItem (copy), t1 (copy), v52 (copy), v54 (copy), v48 (copy), RetrievalStatus (copy), v63 (copy), Constants (copy), Loading (copy), IconSize (copy)
		local t3 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}

		if #v62 ~= 0 and v58 == "" then
			t3[#t3 + 1] = React.createElement(SectionHeader, {
				name = v44.suggestedFriendsTitle,
				description = v44.suggestedFriendsDescription,
				layoutOrder = #t3 + 1
			})

			local t4 = {}

			for _, v in ipairs(v62) do
				if not BlockingUtility:IsPlayerBlockedByUserId(v.userId) then
					table.insert(t4, v)
				end
			end

			for i, v in ipairs(t4) do
				local s1 = ""
				local s2 = ""

				if v67.data then
					s1 = UserProfiles.Selectors.getCombinedNameFromId(v67.data, v.userId)
					s2 = UserProfiles.Selectors.getUsernameFromId(v67.data, v.userId)
				end

				t3[#t3 + 1] = React.createElement(FriendListItem, {
					isSuggestedUser = true,
					userId = v.userId,
					combinedName = s1,
					userName = s2,
					userPresenceType = v.userPresenceType,
					lastLocation = v.lastLocation,
					dismissCallback = t1.dismissCallback,
					layoutOrder = #t3 + 1,
					showDivider = i ~= #t4,
					itemListIndex = i
				})
			end
		end

		if #v52 ~= 0 then
			t3[#t3 + 1] = React.createElement(SectionHeader, {
				name = v44.friendsTitle,
				description = v44.friendsDescription,
				layoutOrder = #t3 + 1
			})
		end

		local t5 = {}

		for _, v in ipairs(v52) do
			if not BlockingUtility:IsPlayerBlockedByUserId(v.id) then
				table.insert(t5, v)
			end
		end

		for i, v in ipairs(t5) do
			local s3 = ""
			local s4 = ""

			if v67.data then
				s3 = UserProfiles.Selectors.getCombinedNameFromId(v67.data, v.id)
				s4 = UserProfiles.Selectors.getUsernameFromId(v67.data, v.id)
			end

			t3[#t3 + 1] = React.createElement(FriendListItem, {
				isSuggestedUser = false,
				userId = v.id,
				combinedName = s3,
				userName = s4,
				dismissCallback = t1.dismissCallback,
				layoutOrder = #t3 + 1,
				showDivider = i ~= #t5,
				searchQueryString = v58,
				itemListIndex = i
			})
		end

		if v54 ~= nil then
			local v101 = #t3 + 1

			if v48 == RetrievalStatus.Failed then
				t3[v101] = v63

				return t3
			end

			t3[v101] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Constants.ITEM_HEIGHT),
				LayoutOrder = v101
			}, {
				LoadingSpinner = React.createElement(Loading, {
					size = IconSize.Large,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		end

		return t3
	end, {
		v52,
		v54,
		v63,
		v48,
		v67.data,
		v62,
		v58,
		v44.friendsDescription,
		v44.friendsTitle,
		v44.suggestedFriendsDescription,
		v44.suggestedFriendsTitle
	})
	local v70 = React.useCallback(function(p13) -- line: 450
		-- upvalues: v45 (copy), v48 (copy), RetrievalStatus (copy), v54 (copy), v60 (copy), v52 (copy)
		if not v45.current and (v48 ~= RetrievalStatus.Failed and v54 ~= nil and p13.CanvasPosition.Y >= p13.AbsoluteCanvasSize.Y - p13.AbsoluteSize.Y - 50) then
			v60(v52, v54)
		end
	end, {
		v52,
		v60,
		v54,
		v48
	})

	React.useEffect(function() -- line: 461
		-- upvalues: v69 (copy), Constants (copy), v46 (copy), v70 (copy)
		local v103 = (#v69 - 1) * Constants.ITEM_HEIGHT

		if v46.current and v103 <= v46.current.AbsoluteSize.Y then
			v70(v46.current)
		end
	end, {
		v69,
		v70
	})

	return if #v52 ~= 0 or v48 ~= RetrievalStatus.Fetching then if #v52 ~= 0 then Roact.createFragment({
		FriendsScrollingFrame = React.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ElasticBehavior = Enum.ElasticBehavior.Never,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = not v50 and t1.scrollingEnabled,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			ref = v46,
			[React.Change.CanvasPosition] = v70
		}, v69),
		TouchStartedUserInputConnection = t1.isSmallScreen and (t1.scrollingEnabled and React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchStarted,
			callback = v64
		})),
		TouchMovedUserInputConnection = t1.isSmallScreen and (t1.scrollingEnabled and React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchMoved,
			callback = v65
		})),
		TouchEndedUserInputConnection = t1.isSmallScreen and (t1.scrollingEnabled and React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchEnded,
			callback = v68
		}))
	}) else v63 else React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Constants.ITEM_HEIGHT)
	}, {
		LoadingSpinner = React.createElement(Loading, {
			size = IconSize.Large,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	})
end

return FriendListContainer
