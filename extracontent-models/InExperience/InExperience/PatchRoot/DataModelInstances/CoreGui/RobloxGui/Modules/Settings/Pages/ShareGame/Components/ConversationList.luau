local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local sortFriendsByCorrectedPresenceAndRank = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({}).User.sortFriendsByCorrectedPresenceAndRank
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = CoreGui.RobloxGui.Modules
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Theme = require(Modules.Settings.Theme)
local Constants = require(ShareGame.Constants)
local GameInviteEvents = require(CorePackages.Workspace.Packages.GameInvite).GameInviteEvents
local ConversationEntry = require(ShareGame.Components.ConversationEntry)
local InviteListEntry = require(ShareGame.Components.InviteListEntry)
local FriendsErrorPage = require(ShareGame.Components.FriendsErrorPage)
local InviteUserIdToPlaceId = require(ShareGame.Thunks.InviteUserIdToPlaceId)
local InviteUserIdToPlaceIdCustomized = require(ShareGame.Thunks.InviteUserIdToPlaceIdCustomized)
local NewInviteMenuExperimentManager = require(ShareGame.NewInviteMenuExperimentManager)
local LoadingFriendsPage = require(ShareGame.Components.LoadingFriendsPage)
local NoFriendsPage = require(ShareGame.Components.NoFriendsPage)
local PlayerSearchPredicate = require(CoreGui.RobloxGui.Modules.InGameMenu.Utility.PlayerSearchPredicate)
local GetFFlagAbuseReportAnalyticsHasLaunchData = require(Modules.Settings.Flags.GetFFlagAbuseReportAnalyticsHasLaunchData)
local GetFFlagEnableNewInviteMenu = require(Modules.Flags.GetFFlagEnableNewInviteMenu)
local GetFFlagEnableNewInviteSendEndpoint = require(Modules.Flags.GetFFlagEnableNewInviteSendEndpoint)
local UserModel = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel
local httpRequest = require(Modules.Common.httpRequest)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local GetFFlagInviteListRerank = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagInviteListRerank
local v33 = require(ShareGame.getTranslator)()
local v34 = Theme.font(Enum.Font.SourceSans)
local GRAY3 = Constants.Color.GRAY3
local v36 = Theme.textSize(19)
local t1 = {
	[UserModel.PresenceType.ONLINE] = 3,
	[UserModel.PresenceType.IN_GAME] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 1,
	[UserModel.PresenceType.OFFLINE] = 0
}
local t2 = {
	SORT_BY_FREQUENCY = 1,
	SORT_BY_PRESENCE_AND_FREQUENCY = 2
}
local v39 = Roact.PureComponent:extend("ConversationList")

v39.defaultProps = {
	entryHeight = 62,
	entryPadding = 16
}

function v39.init(p1) -- line: 76
	-- upvalues: Roact (copy)
	p1.scrollingRef = Roact.createRef()

	function p1.inviteUser(s1: string) -- line: 78
		-- upvalues: p1 (copy)
		return p1.props.inviteUser(s1, p1.props.analytics, p1.props.trigger, p1.props.inviteMessageId, p1.props.launchData)
	end
end
function v39.render(p2) -- line: 89
	-- upvalues: Roact (copy), GetFFlagEnableNewInviteSendEndpoint (copy), GetFFlagEnableNewInviteMenu (copy), PlayerSearchPredicate (copy), InviteListEntry (copy), UserInputService (copy), ConversationEntry (copy), RetrievalStatus (copy), LoadingFriendsPage (copy), NoFriendsPage (copy), FriendsErrorPage (copy), v34 (copy), v33 (copy), GRAY3 (copy), v36 (copy)
	local analytics = p2.props.analytics
	local v47 = p2.props[Roact.Children] or {}
	local entryHeight = p2.props.entryHeight
	local entryPadding = p2.props.entryPadding
	local friends = p2.props.friends
	local friendsRetrievalStatus = p2.props.friendsRetrievalStatus
	local layoutOrder = p2.props.layoutOrder
	local size = p2.props.size
	local zIndex = p2.props.zIndex
	local topPadding = p2.props.topPadding
	local invites = p2.props.invites
	local inviteUser = p2.props.inviteUser
	local searchText = p2.props.searchText

	if GetFFlagEnableNewInviteSendEndpoint() then
		inviteUser = p2.inviteUser
	end

	local v59 = GetFFlagEnableNewInviteMenu()

	v47.RowListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, entryPadding)
	})

	local n1 = 0

	for i, v in ipairs(friends) do
		local v63 = PlayerSearchPredicate(searchText, v.name, v.displayName)

		if v59 then
			v47["User-" .. tostring(i)] = Roact.createElement(InviteListEntry, {
				analytics = analytics,
				user = v,
				visible = v63,
				layoutOrder = i,
				inviteUser = inviteUser,
				inviteStatus = invites[v.id],
				isFullRowActivatable = UserInputService.GamepadEnabled,
				trigger = p2.props.trigger,
				inviteMessageId = p2.props.inviteMessageId,
				launchData = p2.props.launchData
			})
		else
			v47["User-" .. tostring(i)] = Roact.createElement(ConversationEntry, {
				analytics = analytics,
				visible = v63,
				size = UDim2.new(1, 0, 0, entryHeight),
				layoutOrder = i,
				zIndex = zIndex,
				title = v.displayName,
				subtitle = "@" .. v.name,
				presence = v.presence,
				users = { v },
				inviteUser = inviteUser,
				inviteStatus = invites[v.id]
			})
		end

		if v63 then
			n1 += 1
		end
	end

	if #friends == 0 or friendsRetrievalStatus == RetrievalStatus.Fetching then
		local v64 = LoadingFriendsPage

		if friendsRetrievalStatus == RetrievalStatus.Done then
			v64 = NoFriendsPage
		elseif friendsRetrievalStatus == RetrievalStatus.Failed then
			v64 = FriendsErrorPage
		end

		return Roact.createElement(v64, {
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			Position = UDim2.new(0, 0, 0, topPadding),
			ZIndex = zIndex
		})
	end

	if n1 == 0 then
		return Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextTransparency = 0.22,
			LayoutOrder = layoutOrder,
			Font = v34,
			Size = UDim2.new(1, 0, 0, entryHeight),
			Text = v33:FormatByKey("Feature.SettingsHub.Label.InviteSearchNoResults"),
			TextColor3 = GRAY3,
			TextSize = v36,
			ZIndex = zIndex,
			Position = UDim2.new(0, 0, 0, topPadding)
		})
	end

	return Roact.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Size = size,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, topPadding),
		CanvasSize = if not v59 then UDim2.new(0, 0, 0, n1 * (entryHeight + entryPadding)) else UDim2.new(),
		AutomaticCanvasSize = if not v59 then nil else Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		ZIndex = zIndex,
		Selectable = false,
		[Roact.Ref] = p2.scrollingRef
	}, v47)
end

local function handleBinding(p3) -- line: 211
	-- upvalues: GetFFlagEnableNewInviteMenu (copy), UserInputService (copy), GuiService (copy)
	if GetFFlagEnableNewInviteMenu() and not UserInputService.GamepadEnabled then
		return
	end

	local v66 = p3.scrollingRef:getValue()

	if v66 and v66:FindFirstAncestorOfClass("ScreenGui").Enabled and GuiService.SelectedCoreObject == nil then
		GuiService:AddSelectionParent("invitePrompt", v66)

		for _, child in ipairs(v66:GetChildren()) do
			if child:IsA("GuiObject") and child.LayoutOrder == 1 then
				GuiService.SelectedCoreObject = child

				return
			end
		end
	end
end

v39.didUpdate = handleBinding

if GetFFlagEnableNewInviteSendEndpoint() then
	function v39.didMount(p4) -- line: 237
		-- upvalues: Constants (copy), GameInviteEvents (copy), GetFFlagAbuseReportAnalyticsHasLaunchData (copy), handleBinding (copy)
		if p4.props.analytics and p4.props.trigger == Constants.Triggers.GameMenu then
			local v70 = p4.props.launchData ~= nil and p4.props.launchData ~= ""

			p4.props.analytics:sendEvent(p4.props.trigger, GameInviteEvents.ModalOpened, if not GetFFlagAbuseReportAnalyticsHasLaunchData() then nil else {
				isLaunchDataProvided = v70
			})
		end

		handleBinding(p4)
	end
else
	v39.didMount = handleBinding
end

local v41 = memoize(function(p5) -- line: 256
	-- upvalues: t1 (copy)
	local t3 = {}

	local function friendPreference(p6, p7) -- line: 258
		-- upvalues: t1 (copy)
		local v94 = t1[p6.presence]
		local v95 = t1[p7.presence]

		if v94 == v95 then
			return p6.name:lower() < p7.name:lower()
		end

		return v95 < v94
	end

	for _, v in pairs(p5) do
		if v.isFriend then
			t3[#t3 + 1] = v
		end
	end

	table.sort(t3, friendPreference)

	return t3
end)
local v42 = memoize(function(p8) -- line: 280
	-- upvalues: sortFriendsByCorrectedPresenceAndRank (copy)
	local t4 = {}

	for _, v in pairs(p8) do
		if v.isFriend then
			t4[#t4 + 1] = v
		end
	end

	table.sort(t4, sortFriendsByCorrectedPresenceAndRank)

	return t4
end)
local v43 = memoize(function(p9) -- line: 293
	local t5 = {}

	local function friendPreference(p10, p11) -- line: 295
		local v98 = tonumber(p10.friendFrequentRank) or 0
		local v99 = tonumber(p11.friendFrequentRank) or 0

		if v98 == v99 then
			return p10.name:lower() < p11.name:lower()
		end

		return v98 < v99
	end

	for _, v in pairs(p9) do
		if v.isFriend then
			t5[#t5 + 1] = v
		end
	end

	table.sort(t5, friendPreference)

	return t5
end)

return RoactRodux.UNSTABLE_connect2(function(p12, _) -- line: 329
	-- upvalues: v41 (copy), GetFFlagInviteListRerank (copy), NewInviteMenuExperimentManager (copy), t2 (copy), v43 (copy), v42 (copy), Players (copy)
	local v88 = v41

	if GetFFlagInviteListRerank() then
		local v89 = NewInviteMenuExperimentManager.default:getInviteListSortOrder() or 0

		v88 = if v89 ~= t2.SORT_BY_FREQUENCY then if v89 ~= t2.SORT_BY_PRESENCE_AND_FREQUENCY then v41 else v42 else v43
	end

	return {
		friends = v88(p12.Users),
		friendsRetrievalStatus = p12.Friends.retrievalStatus[tostring(Players.LocalPlayer.UserId)],
		invites = p12.Invites
	}
end, function(p14) -- line: 341
	-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetFFlagEnableNewInviteSendEndpoint (copy), InviteUserIdToPlaceIdCustomized (copy), InviteUserIdToPlaceId (copy)
	return {
		inviteUser = function(s2: string, p15, s3: string, s4: string?, s5: string?) -- line: 343
			-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetFFlagEnableNewInviteSendEndpoint (copy), p14 (copy), InviteUserIdToPlaceIdCustomized (copy), InviteUserIdToPlaceId (copy)
			local v105 = httpRequest(HttpRbxApiService)
			local str = tostring(game.PlaceId)

			if GetFFlagEnableNewInviteSendEndpoint() then
				return p14(InviteUserIdToPlaceIdCustomized(v105, s2, str, p15, s3, s4, s5))
			end

			return p14(InviteUserIdToPlaceId(v105, s2, str))
		end
	}
end)(v39)
