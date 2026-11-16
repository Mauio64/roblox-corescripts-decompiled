local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local sortFriendsByCorrectedPresenceAndRank = LuaSocialLibrariesDeps.SocialLibraries.config({}).User.sortFriendsByCorrectedPresenceAndRank

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
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteEvents = GameInvite.GameInviteEvents
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

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local UserModel = UserLib.Models.UserModel

local httpRequest = require(Modules.Common.httpRequest)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local memoize = AppCommonLib.memoize

local Http = require(CorePackages.Workspace.Packages.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagInviteListRerank = SharedFlags.GetFFlagInviteListRerank

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local font = Theme.font(Enum.Font.SourceSans)
local GRAY3 = Constants.Color.GRAY3
local textSize = Theme.textSize(19)

local v = {
	[UserModel.PresenceType.ONLINE] = 3,
	[UserModel.PresenceType.IN_GAME] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 1,
	[UserModel.PresenceType.OFFLINE] = 0
}

local v2 = { SORT_BY_FREQUENCY = 1, SORT_BY_PRESENCE_AND_FREQUENCY = 2 }

local extended = Roact.PureComponent:extend("ConversationList")
extended.defaultProps = { entryHeight = 62, entryPadding = 16 }

function extended:init()
	self.scrollingRef = Roact.createRef()
	function self.inviteUser(p: string)
		return self.props.inviteUser(
			p,
			self.props.analytics,
			self.props.trigger,
			self.props.inviteMessageId,
			self.props.launchData
		)
	end
end

function extended.render(props)
	local analytics = props.props.analytics
	local children = props.props[Roact.Children] or {}

	local entryHeight = props.props.entryHeight
	local entryPadding = props.props.entryPadding

	local friends = props.props.friends
	local friendsRetrievalStatus = props.props.friendsRetrievalStatus
	local layoutOrder = props.props.layoutOrder
	local size = props.props.size
	local zIndex = props.props.zIndex
	local topPadding = props.props.topPadding

	local invites = props.props.invites
	local inviteUser = props.props.inviteUser
	local searchText = props.props.searchText

	if GetFFlagEnableNewInviteSendEndpoint() then
		inviteUser = props.inviteUser
	end

	local fFlagEnableNewInviteMenu = GetFFlagEnableNewInviteMenu()

	children.RowListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, entryPadding)
	})
	local count = 0

	for i, friend in ipairs(friends) do
		local visible = PlayerSearchPredicate(searchText, friend.name, friend.displayName)

		if fFlagEnableNewInviteMenu then
			children["User-" .. tostring(i)] = Roact.createElement(InviteListEntry, {
				analytics = analytics,
				user = friend,
				visible = visible,
				layoutOrder = i,
				inviteUser = inviteUser,
				inviteStatus = invites[friend.id],
				isFullRowActivatable = UserInputService.GamepadEnabled,
				trigger = props.props.trigger,
				inviteMessageId = props.props.inviteMessageId,
				launchData = props.props.launchData
			})
		else
			children["User-" .. tostring(i)] = Roact.createElement(ConversationEntry, {
				analytics = analytics,
				visible = visible,
				size = UDim2.new(1, 0, 0, entryHeight),
				layoutOrder = i,
				zIndex = zIndex,
				title = friend.displayName,
				subtitle = "@" .. friend.name,
				presence = friend.presence,
				users = { friend },
				inviteUser = inviteUser,
				inviteStatus = invites[friend.id]
			})
		end

		if visible then
			count += 1
		end
	end

	if #friends == 0 or friendsRetrievalStatus == RetrievalStatus.Fetching then
		local v3 = LoadingFriendsPage

		if friendsRetrievalStatus == RetrievalStatus.Done then
			v3 = NoFriendsPage
		elseif friendsRetrievalStatus == RetrievalStatus.Failed then
			v3 = FriendsErrorPage
		end

		return Roact.createElement(v3, {
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			Position = UDim2.new(0, 0, 0, topPadding),
			ZIndex = zIndex
		})
	else
		if count == 0 then
			return Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Font = font,
				Size = UDim2.new(1, 0, 0, entryHeight),
				Text = translator:FormatByKey("Feature.SettingsHub.Label.InviteSearchNoResults"),
				TextColor3 = GRAY3,
				TextSize = textSize,
				TextTransparency = 0.22,
				ZIndex = zIndex,
				Position = UDim2.new(0, 0, 0, topPadding)
			})
		end

		local createElement = Roact.createElement
		local scrollingRefsByRef = {}
		scrollingRefsByRef.BackgroundTransparency = 1
		scrollingRefsByRef.LayoutOrder = layoutOrder
		scrollingRefsByRef.Size = size
		scrollingRefsByRef.BorderSizePixel = 0
		scrollingRefsByRef.Position = UDim2.new(0, 0, 0, topPadding)
		local canvasSize

		if fFlagEnableNewInviteMenu then
			canvasSize = UDim2.new()
		else
			canvasSize = UDim2.new(0, 0, 0, count * (entryHeight + entryPadding))
		end

		scrollingRefsByRef.CanvasSize = canvasSize
		local automaticCanvasSize

		if fFlagEnableNewInviteMenu then
			automaticCanvasSize = Enum.AutomaticSize.Y
		end

		scrollingRefsByRef.AutomaticCanvasSize = automaticCanvasSize
		scrollingRefsByRef.ScrollBarThickness = 0
		scrollingRefsByRef.ZIndex = zIndex
		scrollingRefsByRef.Selectable = false
		scrollingRefsByRef[Roact.Ref] = props.scrollingRef
		return createElement("ScrollingFrame", scrollingRefsByRef, children)
	end
end

local function handleBinding(p)
	if GetFFlagEnableNewInviteMenu() and not UserInputService.GamepadEnabled then
		return
	end

	local value = p.scrollingRef:getValue()

	if value and value:FindFirstAncestorOfClass("ScreenGui").Enabled and GuiService.SelectedCoreObject == nil then
		GuiService:AddSelectionParent("invitePrompt", value)

		for _, guiObject in ipairs(value:GetChildren()) do
			if guiObject:IsA("GuiObject") and guiObject.LayoutOrder == 1 then
				GuiService.SelectedCoreObject = guiObject
				return
			end
		end
	end
end

extended.didUpdate = handleBinding

if GetFFlagEnableNewInviteSendEndpoint() then
	function extended.didMount(p)
		if p.props.analytics and p.props.trigger == Constants.Triggers.GameMenu then
			local isLaunchDataProvided = p.props.launchData ~= nil and p.props.launchData ~= ""
			p.props.analytics:sendEvent(
				p.props.trigger,
				GameInviteEvents.ModalOpened,
				GetFFlagAbuseReportAnalyticsHasLaunchData() and {
					isLaunchDataProvided = isLaunchDataProvided
				} or nil
			)
		end

		handleBinding(p)
	end
else
	extended.didMount = handleBinding
end

local v3 = memoize(function(items)
	local function friendPreference(p, p2): boolean
		local v3 = v[p.presence]
		local v4 = v[p2.presence]

		if v3 == v4 then
			return p.name:lower() < p2.name:lower()
		end

		return v4 < v3
	end

	local result = {}

	for _, item in pairs(items) do
		if item.isFriend then
			result[#result + 1] = item
		end
	end

	table.sort(result, friendPreference)

	return result
end)

local v4 = memoize(function(items)
	local result = {}

	for _, item in pairs(items) do
		if item.isFriend then
			result[#result + 1] = item
		end
	end

	table.sort(result, sortFriendsByCorrectedPresenceAndRank)

	return result
end)

local v5 = memoize(function(items)
	local function friendPreference(p, p2): boolean
		local friendFrequentRank = tonumber(p.friendFrequentRank) or 0
		local friendFrequentRank2 = tonumber(p2.friendFrequentRank) or 0

		if friendFrequentRank == friendFrequentRank2 then
			return p.name:lower() < p2.name:lower()
		end

		return friendFrequentRank < friendFrequentRank2
	end

	local result = {}

	for _, item in pairs(items) do
		if item.isFriend then
			result[#result + 1] = item
		end
	end

	table.sort(result, friendPreference)

	return result
end)

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local v6 = v3

	if GetFFlagInviteListRerank() then
		local v7 = NewInviteMenuExperimentManager.default:getInviteListSortOrder() or 0

		if v7 == v2.SORT_BY_FREQUENCY then
			v6 = v5
		elseif v7 == v2.SORT_BY_PRESENCE_AND_FREQUENCY then
			v6 = v4
		else
			v6 = v3
		end
	end

	return {
		friends = v6(data.Users),
		friendsRetrievalStatus = data.Friends.retrievalStatus[tostring(Players.LocalPlayer.UserId)],
		invites = data.Invites
	}
end, function(callback)
	return {
		inviteUser = function(p: string, p2, p3: string, p4: string?, p5: string?)
			local v6 = httpRequest(HttpRbxApiService)
			local placeId = tostring(game.PlaceId)

			if GetFFlagEnableNewInviteSendEndpoint() then
				return callback(InviteUserIdToPlaceIdCustomized(v6, p, placeId, p2, p3, p4, p5))
			end

			return callback(InviteUserIdToPlaceId(v6, p, placeId))
		end
	}
end)(extended)
