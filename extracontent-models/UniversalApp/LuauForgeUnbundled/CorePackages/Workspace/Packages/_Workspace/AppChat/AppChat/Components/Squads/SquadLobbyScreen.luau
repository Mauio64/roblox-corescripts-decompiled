local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/ModelTypes")
local SquadLobby = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadLobby")
local SquadAddFriendsIconButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadAddFriendsIconButton")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local extended = React.PureComponent:extend("SquadLobbyScreen")

local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local withChatPlacementContext = ChatPlacementContext.withChatPlacementContext
local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")

local fFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")
local fFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local squadVoiceChangers = { EnumScreens.SquadLobby, EnumScreens.SquadInviteFriends, EnumScreens.SquadVoiceReportAbuse }

if fFlagEnablePartyVoiceChangersInLua then
	table.insert(squadVoiceChangers, EnumScreens.SquadVoiceChangers)
end

local function fn(p2)
	local navigation = p2.navigation

	return {
		renderRight = function()
			return React.createElement(SquadAddFriendsIconButton, { navigation = navigation })
		end
	}
end

function extended:init()
	local v5 = if FFlagAppChatIxpScreenExposure then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		"Party.PartyLobbyPage"
	) else nil
	self.ixpSubscription = v5

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

	function self.navigateToHomePage(p2)
		local v6 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Home]

		if v6 then
			v6()
		end
	end

	function self.openViewProfile(p2)
		local v6 = self.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v6 then
			v6(p2, {})
		end
	end

	function self.openSquadVoiceAbuseReport(p2)
		self.props.navigation.navigate(EnumScreens.SquadVoiceReportAbuse, { reportData = p2 })
	end

	if fFlagEnablePartyVoiceChangersInLua then
		function self.openSquadVoiceChangers()
			self.props.navigation.navigate(EnumScreens.SquadVoiceChangers)
		end
	end

	function self.navigateToSquadInviteFriends(p2)
		self.props.navigation.navigate(EnumScreens.SquadInviteFriends, {
			conversationId = p2
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
	return withChatPlacementContext(function(p2)
		local isFocused = data.state.isFocused
		local placementInExperience = ChatPlacementContext.isPlacementInExperience(p2.chatPlacement)

		if not isFocused then
			return nil
		end

		local function fn2(p3)
			local createElement = React.createElement
			local v6 = {
				navigateToHomePage = data.navigateToHomePage,
				openViewProfile = data.openViewProfile,
				openSquadVoiceAbuseReport = data.openSquadVoiceAbuseReport,
				navigateAwayFromSquad = data.navigateAwayFromSquad,
				navigateToChat = p3,
				navigateToSquadInviteFriends = data.navigateToSquadInviteFriends,
				openSquadVoiceChangers = 0,
				isInExperience = 0,
				isWideMode = 0
			}

			local v7 = if fFlagEnablePartyVoiceChangersInLua then data.openSquadVoiceChangers else nil
			v6.openSquadVoiceChangers = v7

			v6.isInExperience = placementInExperience
			v6.isWideMode = data.props.isWideMode
			return createElement(SquadLobby, v6)
		end

		if fFlagExpChatEnableFriendsTab and placementInExperience then
			return React.createElement(ParentContainerContext.Consumer, {
				render = function(p3)
					return fn2(function(p4)
						return p3.openFriendsChatConversation(p4):andThen(function(p5)
							data.navigateAwayFromSquad()
							return p5
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
function extended2.init(p2) end

function extended2.render(p2)
	return React.createElement(extended, Cryo.Dictionary.union(p2.props, {
		isWideMode = true
	}))
end

local extended3 = React.PureComponent:extend("CompactSquadLobbyScreen")
extended3.navigationOptions = fn
function extended3.init(p2) end
function extended3.render(p2)
	return React.createElement(extended, Cryo.Dictionary.union(p2.props, {
		isWideMode = false
	}))
end

return { WideSquadLobbyScreen = extended2, CompactSquadLobbyScreen = extended3 }
