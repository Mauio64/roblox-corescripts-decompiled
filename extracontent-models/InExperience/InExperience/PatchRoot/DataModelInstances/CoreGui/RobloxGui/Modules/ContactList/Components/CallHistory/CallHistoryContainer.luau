local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local useApolloClient = ApolloClient.useApolloClient
local ContactList = RobloxGui.Modules.ContactList
local SetCurrentPage = require(ContactList.Actions.SetCurrentPage)
local Pages = require(ContactList.Enums.Pages)
local dependencies = require(ContactList.dependencies)
local NetworkingCall = dependencies.NetworkingCall
local useDispatch = dependencies.Hooks.useDispatch
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local CallHistoryItem = require(ContactList.Components.CallHistory.CallHistoryItem)
local NoItemView = require(ContactList.Components.ContactListCommon.NoItemView)
local Constants = require(ContactList.Components.ContactListCommon.Constants)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v33 = LocalPlayer and LocalPlayer.UserId or 0

local function CallHistoryContainer(t1: {[any]: any}) -- line: 53
	-- upvalues: useApolloClient (copy), useAnalytics (copy), useDispatch (copy), useStyle (copy), useLocalization (copy), React (copy), RetrievalStatus (copy), useSelector (copy), NetworkingCall (copy), UserProfiles (copy), Cryo (copy), EventNamesEnum (copy), Pages (copy), SetCurrentPage (copy), NoItemView (copy), Constants (copy), v33 (copy), BlockingUtility (copy), CallHistoryItem (copy), Loading (copy), IconSize (copy), Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v36 = useApolloClient()
	local v37 = useAnalytics()
	local v38 = useDispatch()
	local Theme = useStyle().Theme
	local v40 = useLocalization({
		genericErrorLabel = "Feature.Call.Error.Description.Generic",
		noCallsLabel = "Feature.Call.Prompt.FirstCall"
	})
	local v41 = React.useRef(true)
	local v42 = React.useRef(nil)
	local v43 = React.useRef(0)
	local v44, v45 = React.useState(RetrievalStatus.Fetching)
	local v46, v47 = React.useState(false)
	local v48, v49 = React.useState({})
	local v50, v51 = React.useState("")
	local v52 = useSelector(function(p1) -- line: 75
		return p1.LastRemovedFriend.lastRemovedFriendId
	end)
	local v53 = React.useCallback(function(p2) -- line: 79
		return p2.Navigation.currentPage
	end, {})
	local v54 = useSelector(v53)
	local v55 = React.useCallback(function(p3, p4) -- line: 84
		-- upvalues: v41 (copy), v45 (copy), RetrievalStatus (copy), v38 (copy), NetworkingCall (copy), v36 (copy), UserProfiles (copy), Cryo (copy), v49 (copy), v51 (copy)
		v41.current = true
		v45(RetrievalStatus.Fetching)

		local v67 = p4 ~= "" and 8 or 16

		v38(NetworkingCall.GetCallHistory.API({
			cursor = p4,
			limit = v67,
			universeId = game.GameId
		})):andThen(function(p5) -- line: 89
			-- upvalues: p3 (copy), v36 (copy), UserProfiles (copy), Cryo (copy), v49 (copy), v51 (copy), v45 (copy), RetrievalStatus (copy)
			local t2 = {}

			for _, v in ipairs(p3) do
				table.insert(t2, v)
			end

			for _, v in ipairs(p5.responseBody.callRecords) do
				table.insert(t2, v)
			end

			local t3 = {}

			for _, v in ipairs(t2) do
				for _, v2 in ipairs(v.participants) do
					t3[tostring(v2.userId)] = true
				end
			end

			v36:query({
				query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
				variables = {
					userIds = Cryo.Dictionary.keys(t3)
				}
			}):andThen(function() -- line: 110
				-- upvalues: v49 (copy), t2 (copy), v51 (copy), p5 (copy), v45 (copy), RetrievalStatus (copy)
				v49(t2)
				v51(p5.responseBody.nextPageCursor)
				v45(RetrievalStatus.Done)
			end):catch(function() -- line: 116
				-- upvalues: v45 (copy), RetrievalStatus (copy)
				v45(RetrievalStatus.Failed)
			end)
		end, function() -- line: 120
			-- upvalues: v45 (copy), RetrievalStatus (copy)
			v45(RetrievalStatus.Failed)
		end)
	end, { v52 })

	React.useEffect(function() -- line: 126
		-- upvalues: v55 (copy), v49 (copy), v51 (copy)
		v55({}, "")

		return function() -- line: 129
			-- upvalues: v49 (copy), v51 (copy)
			v49({})
			v51("")
		end
	end, { v55 })

	local v56 = React.useCallback(function() -- line: 135
		-- upvalues: v37 (copy), EventNamesEnum (copy), v54 (copy), Pages (copy), v38 (copy), SetCurrentPage (copy)
		v37.fireEvent(EventNamesEnum.PhoneBookNavigate, {
			eventTimestampMs = os.time() * 1000,
			startingPage = v54,
			destinationPage = Pages.FriendList
		})
		v38(SetCurrentPage(Pages.FriendList))
	end, { v54 })

	React.useEffect(function() -- line: 144
		-- upvalues: v44 (copy), RetrievalStatus (copy), v41 (copy)
		if v44 ~= RetrievalStatus.Fetching then
			v41.current = false
		end
	end, { v44 })

	local v57 = React.useMemo(function() -- line: 150
		-- upvalues: v44 (copy), RetrievalStatus (copy), v40 (copy), React (copy), NoItemView (copy), v55 (copy), v48 (copy), v50 (copy), v56 (copy)
		local v68 = if v44 ~= RetrievalStatus.Failed then v40.noCallsLabel else v40.genericErrorLabel

		return React.createElement(NoItemView, {
			imageName = "icons/graphic/findfriends_xlarge",
			isImageEnabled = v44 ~= RetrievalStatus.Failed,
			isFailedButtonEnabled = v44 == RetrievalStatus.Failed,
			onFailedButtonActivated = function() -- line: 162
				-- upvalues: v55 (copy), v48 (copy), v50 (copy)
				v55(v48, v50)
			end,
			isCallButtonEnabled = v44 == RetrievalStatus.Done,
			onCallButtonActivated = v56,
			messageText = v68
		})
	end, {
		v48,
		v55,
		v40.genericErrorLabel,
		v40.noCallsLabel,
		v56,
		v50,
		v44
	})
	local v58 = React.useCallback(function(p6) -- line: 179
		-- upvalues: v43 (copy)
		v43.current = p6.Position.Y
	end, {})
	local v59 = React.useCallback(function(p7) -- line: 183
		-- upvalues: v43 (copy), Constants (copy), v42 (copy), v47 (copy)
		if p7.Position.Y - v43.current > Constants.TOUCH_SLOP and (v42.current and v42.current.CanvasPosition.Y == 0) then
			v47(true)
		end
	end, {})
	local v60 = React.useCallback(function() -- line: 198
		-- upvalues: v47 (copy)
		v47(false)
	end, {})
	local v61 = React.useMemo(function() -- line: 202
		-- upvalues: React (copy), v48 (copy), v33 (copy), BlockingUtility (copy), CallHistoryItem (copy), t1 (copy), v50 (copy), v44 (copy), RetrievalStatus (copy), v57 (copy), Constants (copy), Loading (copy), IconSize (copy)
		local t4 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}
		local t5 = {}

		for _, v in ipairs(v48) do
			local userId = v.participants[1].userId

			if userId == v33 then
				userId = v.participants[2].userId
			end

			if not BlockingUtility:IsPlayerBlockedByUserId(userId) then
				table.insert(t5, v)
			end
		end

		for i, v in ipairs(t5) do
			t4[i] = React.createElement(CallHistoryItem, {
				callRecord = v,
				localUserId = v33,
				showDivider = i ~= #t5,
				dismissCallback = t1.dismissCallback,
				layoutOrder = i
			})
		end

		if v50 ~= "" then
			local v78 = #t4 + 1

			if v44 == RetrievalStatus.Failed then
				t4[v78] = v57

				return t4
			end

			t4[v78] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, Constants.ITEM_HEIGHT),
				LayoutOrder = v78
			}, {
				LoadingSpinner = React.createElement(Loading, {
					size = IconSize.Large,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		end

		return t4
	end, {
		v48,
		v50,
		v57,
		v44
	})
	local v62 = React.useCallback(function(p8) -- line: 255
		-- upvalues: v41 (copy), v44 (copy), RetrievalStatus (copy), v50 (copy), v55 (copy), v48 (copy)
		if not v41.current and (v44 ~= RetrievalStatus.Failed and v50 ~= "" and p8.CanvasPosition.Y >= p8.AbsoluteCanvasSize.Y - p8.AbsoluteSize.Y - 50) then
			v55(v48, v50)
		end
	end, {
		v48,
		v55,
		v50,
		v44
	})

	React.useEffect(function() -- line: 266
		-- upvalues: v61 (copy), Constants (copy), v42 (copy), v62 (copy)
		local v80 = (#v61 - 1) * Constants.ITEM_HEIGHT

		if v42.current and v80 <= v42.current.AbsoluteSize.Y then
			v62(v42.current)
		end
	end, {
		v61,
		v62
	})

	if #v48 == 0 and v44 == RetrievalStatus.Fetching then
		return (React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Constants.ITEM_HEIGHT)
		}, {
			LoadingSpinner = React.createElement(Loading, {
				size = IconSize.Large,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		}))
	end

	if #v48 == 0 then
		return v57
	end

	return (Roact.createFragment({
		React.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ElasticBehavior = Enum.ElasticBehavior.Never,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = not v46 and t1.scrollingEnabled,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			ref = v42,
			[React.Change.CanvasPosition] = v62
		}, v61),
		TouchStartedUserInputConnection = t1.isSmallScreen and (t1.scrollingEnabled and React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchStarted,
			callback = v58
		})),
		TouchMovedUserInputConnection = t1.isSmallScreen and (t1.scrollingEnabled and React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchMoved,
			callback = v59
		})),
		TouchEndedUserInputConnection = t1.isSmallScreen and (t1.scrollingEnabled and React.createElement(ExternalEventConnection, {
			event = UserInputService.TouchEnded,
			callback = v60
		}))
	}))
end

return CallHistoryContainer
