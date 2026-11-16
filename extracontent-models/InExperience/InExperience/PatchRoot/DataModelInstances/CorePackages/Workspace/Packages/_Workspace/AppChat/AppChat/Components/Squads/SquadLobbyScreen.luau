local AppChat = script:FindFirstAncestor("AppChat")

local EnumScreens = require(AppChat.EnumScreens)
local parent = AppChat.Parent
local SharedFlags = require(parent.SharedFlags)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
require(parent.Squads.ModelTypes)
local SquadLobby = require(parent.Squads.SquadLobby)
local SquadAddFriendsIconButton = require(script.Parent.SquadAddFriendsIconButton)
local RoactNavigation = require(parent.RoactNavigation)

local extended = React.PureComponent:extend("SquadLobbyScreen")

local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local withChatPlacementContext = ChatPlacementContext.withChatPlacementContext
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)

local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local squadVoiceChangers = { EnumScreens.SquadLobby, EnumScreens.SquadInviteFriends, EnumScreens.SquadVoiceReportAbuse }

if FFlagEnablePartyVoiceChangersInLua then
	table.insert(squadVoiceChangers, EnumScreens.SquadVoiceChangers)
end

local function fn(p)
	local navigation = p.navigation

	return {
		renderRight = function()
			return React.createElement(SquadAddFriendsIconButton, { navigation = navigation })
		end
	}
end

function extended:init()
	local ixpSubscription

	if FFlagAppChatIxpScreenExposure then
		ixpSubscription = IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.PartyLobbyPage")
	end

	self.ixpSubscription = ixpSubscription

	local navigation = self.props.navigation

	GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadLobby, { backButtonEnabled = true })

	self.state = { isFocused = navigation.isFocused() }

	self.willFocusSubscription = navigation.addListener(RoactNavigation.Events.WillFocus, function()
		self:setState({ isFocused = true })
	end)
	self.didBlurSubscription = navigation.addListener(RoactNavigation.Events.DidBlur, function()
		self:setState({ isFocused = false })
	end)

	self.hasNavigatedAwayFromSquad = false

	function self.navigateToHomePage(_)
		local v = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Home]

		if v then
			v()
		end
	end

	function self.openViewProfile(p: string)
		local v = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v then
			v(p, {})
		end
	end

	function self.openSquadVoiceAbuseReport(reportData)
		self.props.navigation.navigate(EnumScreens.SquadVoiceReportAbuse, {
			reportData = reportData
		})
	end

	if FFlagEnablePartyVoiceChangersInLua then
		function self.openSquadVoiceChangers()
			self.props.navigation.navigate(EnumScreens.SquadVoiceChangers)
		end
	end

	function self.navigateToSquadInviteFriends(conversationId)
		self.props.navigation.navigate(EnumScreens.SquadInviteFriends, {
			conversationId = conversationId
		})
	end

	function self.navigateAwayFromSquad()
		if self.hasNavigatedAwayFromSquad then
			return
		end

		local dangerouslyGetParent = self.props.navigation._dangerouslyGetParent()

		local state = dangerouslyGetParent and dangerouslyGetParent.state

		if state then
			local key = nil

			for i = state.index, 1, -1 do
				local route = state.routes[i]

				if table.find(squadVoiceChangers, route.routeName) then
					key = route.key
				else
					if key then
						self.hasNavigatedAwayFromSquad = true
						self.props.navigation.goBack(key)
					end

					return
				end
			end
		end
	end
end

function extended.willUnmount(data)
	if data.ixpSubscription then
		data.ixpSubscription.remove()
	end

	if data.willFocusSubscription then
		data.willFocusSubscription:remove()
	end

	if data.didBlurSubscription then
		data.didBlurSubscription:remove()
	end
end

function extended.render(data)
	return withChatPlacementContext(function(p)
		local isFocused = data.state.isFocused
		local placementInExperience = ChatPlacementContext.isPlacementInExperience(p.chatPlacement)

		if not isFocused then
			return nil
		end

		local function fn2(navigateToChat)
			local createElement = React.createElement
			local v = {
				navigateToHomePage = data.navigateToHomePage,
				openViewProfile = data.openViewProfile,
				openSquadVoiceAbuseReport = data.openSquadVoiceAbuseReport,
				navigateAwayFromSquad = data.navigateAwayFromSquad,
				navigateToChat = navigateToChat,
				navigateToSquadInviteFriends = data.navigateToSquadInviteFriends,
				openSquadVoiceChangers = 0,
				isInExperience = 0,
				isWideMode = 0
			}
			local openSquadVoiceChangers

			if FFlagEnablePartyVoiceChangersInLua then
				openSquadVoiceChangers = data.openSquadVoiceChangers
			end

			v.openSquadVoiceChangers = openSquadVoiceChangers

			v.isInExperience = placementInExperience
			v.isWideMode = data.props.isWideMode
			return createElement(SquadLobby, v)
		end

		if FFlagExpChatEnableFriendsTab and placementInExperience then
			return React.createElement(ParentContainerContext.Consumer, {
				render = function(p2)
					return fn2(function(p3)
						return p2.openFriendsChatConversation(p3):andThen(function(p4)
							data.navigateAwayFromSquad()
							return p4
						end)
					end)
				end
			})
		end

		return fn2(nil)
	end)
end

local extended2 = React.PureComponent:extend("WideSquadLobbyScreen")
extended2.navigationOptions = fn
function extended2.init(_) end

function extended2.render(p)
	return React.createElement(extended, Cryo.Dictionary.union(p.props, { isWideMode = true }))
end

local extended3 = React.PureComponent:extend("CompactSquadLobbyScreen")
extended3.navigationOptions = fn
function extended3.init(_) end
function extended3.render(p)
	return React.createElement(extended, Cryo.Dictionary.union(p.props, { isWideMode = false }))
end

return { WideSquadLobbyScreen = extended2, CompactSquadLobbyScreen = extended3 }
