local AppChat = script:FindFirstAncestor("AppChat")
local EnumScreens = require(AppChat.EnumScreens)
local AppChatParent = AppChat.Parent
local SharedFlags = require(AppChatParent.SharedFlags)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)

require(AppChatParent.Squads.ModelTypes)

local SquadLobby = require(AppChatParent.Squads.SquadLobby)
local SquadAddFriendsIconButton = require(script.Parent.SquadAddFriendsIconButton)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local v10 = React.PureComponent:extend("SquadLobbyScreen")
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local withChatPlacementContext = ChatPlacementContext.withChatPlacementContext
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local t1 = {
	EnumScreens.SquadLobby,
	EnumScreens.SquadInviteFriends,
	EnumScreens.SquadVoiceReportAbuse
}

if FFlagEnablePartyVoiceChangersInLua then
	table.insert(t1, EnumScreens.SquadVoiceChangers)
end

local function v19(p1) -- line: 36
	-- upvalues: React (copy), SquadAddFriendsIconButton (copy)
	local navigation = p1.navigation

	return {
		renderRight = function() -- line: 40
			-- upvalues: React (copy), SquadAddFriendsIconButton (copy), navigation (copy)
			return React.createElement(SquadAddFriendsIconButton, {
				navigation = navigation
			})
		end
	}
end

function v10.init(p2) -- line: 48
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), RoactNavigation (copy), FFlagEnablePartyVoiceChangersInLua (copy), t1 (copy)
	p2.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p2.props.navigation, "Party.PartyLobbyPage")

	local navigation = p2.props.navigation

	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadLobby, {
			backButtonEnabled = true
		})
	end

	p2.state = {
		isFocused = navigation.isFocused()
	}
	p2.willFocusSubscription = navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 61
		-- upvalues: p2 (copy)
		p2:setState({
			isFocused = true
		})
	end)
	p2.didBlurSubscription = navigation.addListener(RoactNavigation.Events.DidBlur, function() -- line: 64
		-- upvalues: p2 (copy)
		p2:setState({
			isFocused = false
		})
	end)
	p2.hasNavigatedAwayFromSquad = false

	function p2.navigateToHomePage(_) -- line: 70
		-- upvalues: p2 (copy), EnumScreens (copy)
		local v33 = p2.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.Home]

		if v33 then
			v33()
		end
	end
	function p2.openViewProfile(s1: string) -- line: 80
		-- upvalues: p2 (copy), EnumScreens (copy)
		local v35 = p2.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v35 then
			v35(s1, {})
		end
	end
	function p2.openSquadVoiceAbuseReport(p4) -- line: 88
		-- upvalues: p2 (copy), EnumScreens (copy)
		p2.props.navigation.navigate(EnumScreens.SquadVoiceReportAbuse, {
			reportData = p4
		})
	end

	if FFlagEnablePartyVoiceChangersInLua then
		function p2.openSquadVoiceChangers() -- line: 93
			-- upvalues: p2 (copy), EnumScreens (copy)
			p2.props.navigation.navigate(EnumScreens.SquadVoiceChangers)
		end
	end

	function p2.navigateToSquadInviteFriends(p5) -- line: 98
		-- upvalues: p2 (copy), EnumScreens (copy)
		p2.props.navigation.navigate(EnumScreens.SquadInviteFriends, {
			conversationId = p5
		})
	end
	function p2.navigateAwayFromSquad() -- line: 102
		-- upvalues: p2 (copy), t1 (copy)
		if p2.hasNavigatedAwayFromSquad then
			return
		end

		local v38 = p2.props.navigation._dangerouslyGetParent()

		if v38 then
			local state = v38.state

			if state then
				local key = nil

				for i = state.index, 1, -1 do
					local v42 = state.routes[i]

					if not table.find(t1, v42.routeName) then
						if key then
							p2.hasNavigatedAwayFromSquad = true
							p2.props.navigation.goBack(key)
						end

						return
					end

					key = v42.key
				end
			end
		end
	end
end
function v10.willUnmount(p6) -- line: 130
	if p6.ixpSubscription then
		p6.ixpSubscription.remove()
	end

	if p6.willFocusSubscription then
		p6.willFocusSubscription:remove()
	end

	if p6.didBlurSubscription then
		p6.didBlurSubscription:remove()
	end
end
function v10.render(p7) -- line: 142
	-- upvalues: withChatPlacementContext (copy), React (copy), SquadLobby (copy), FFlagEnablePartyVoiceChangersInLua (copy), ChatPlacementContext (copy)
	return withChatPlacementContext(function(p8) -- line: 143
		-- upvalues: p7 (copy), React (copy), SquadLobby (copy), FFlagEnablePartyVoiceChangersInLua (copy), ChatPlacementContext (copy)
		if not p7.state.isFocused then
			return nil
		end

		return React.createElement(SquadLobby, {
			navigateToHomePage = p7.navigateToHomePage,
			openViewProfile = p7.openViewProfile,
			openSquadVoiceAbuseReport = p7.openSquadVoiceAbuseReport,
			navigateAwayFromSquad = p7.navigateAwayFromSquad,
			navigateToSquadInviteFriends = p7.navigateToSquadInviteFriends,
			openSquadVoiceChangers = if not FFlagEnablePartyVoiceChangersInLua then nil else p7.openSquadVoiceChangers,
			isInExperience = ChatPlacementContext.isPlacementInExperience(p8.chatPlacement),
			isWideMode = p7.props.isWideMode
		})
	end)
end

local v20 = React.PureComponent:extend("WideSquadLobbyScreen")

v20.navigationOptions = v19

function v20.init(_) -- line: 167
end
function v20.render(p10) -- line: 169
	-- upvalues: React (copy), v10 (copy), Cryo (copy)
	return React.createElement(v10, Cryo.Dictionary.union(p10.props, {
		isWideMode = true
	}))
end

local v21 = React.PureComponent:extend("CompactSquadLobbyScreen")

v21.navigationOptions = v19

function v21.init(_) -- line: 175
end
function v21.render(p12) -- line: 176
	-- upvalues: React (copy), v10 (copy), Cryo (copy)
	return React.createElement(v10, Cryo.Dictionary.union(p12.props, {
		isWideMode = false
	}))
end

return {
	WideSquadLobbyScreen = v20,
	CompactSquadLobbyScreen = v21
}
