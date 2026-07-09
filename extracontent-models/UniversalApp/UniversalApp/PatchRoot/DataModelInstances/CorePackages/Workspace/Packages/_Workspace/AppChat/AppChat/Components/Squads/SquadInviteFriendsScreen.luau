local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RoactRodux = require(AppChatParent.RoactRodux)
local SharedFlags = require(AppChatParent.SharedFlags)
local ArgCheck = require(AppChatParent.ArgCheck)
local withLocalization = require(AppChatParent.Localization).withLocalization
local TopBarProvider = require(AppChat.TopBarProvider)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local EnumScreens = require(AppChat.EnumScreens)
local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local NavProps = require(AppChat.Constants).NavProps
local SquadInviteFriends = require(AppChatParent.Squads.SquadInviteFriends)
local SquadInviteFriendsContainer = require(AppChatParent.Squads.SquadInviteFriendsContainer)
local v18 = React.PureComponent:extend("SquadInviteFriendsScreen")

if not FFlagEnablePartyQuickStartButton then
	function v18.navigationOptions(_) -- line: 29
		return {
			headerText = {
				raw = "Feature.Squads.Label.InviteToSquad",
				shouldLocalize = true
			}
		}
	end
end

local function navigationOptions(p2) -- line: 39
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), NavProps (copy), React (copy), TopBarProvider (copy), EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy)
	if FFlagAppChatTopBarConfigDriven() then
		return {}
	end

	if not p2.navigation or (not p2.navigation.getScreenProps or not p2.navigation.getScreenProps(NavProps.WIDE_MODE, false)) then
		return {}
	end

	return {
		renderRight = function() -- line: 53
			-- upvalues: React (copy), TopBarProvider (copy), EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy)
			return React.createElement(TopBarProvider, {
				screenName = EnumScreens.SquadInviteFriends,
				render = function(p3) -- line: 56
					-- upvalues: EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy)
					local v34 = p3.getScreenTopBar(EnumScreens.SquadInviteFriends)

					return withLocalization({
						systemButtonText = "Feature.Squads.Action.Add"
					})(function(p4) -- line: 61
						-- upvalues: createSystemMenuButton (copy), v34 (copy)
						return createSystemMenuButton({
							localizedStrings = p4,
							isDisabled = not v34.systemButtonEnabled,
							onActivated = v34.systemButtonActivated
						})
					end)
				end
			})
		end
	}
end

v18.navigationOptions = navigationOptions

function v18.init(p5) -- line: 75
	-- upvalues: NavProps (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), FFlagEnablePartyQuickStartButton (copy), FFlagAppChatTopBarSignalsStore (copy), ArgCheck (copy)
	p5.wideMode = p5.props.navigation.getScreenProps(NavProps.WIDE_MODE, false)

	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadInviteFriends, {
			backButtonEnabled = true,
			systemButtonText = "Feature.Squads.Action.Add",
			headerText = if not FFlagEnablePartyQuickStartButton then nil else {
				raw = "Feature.Squads.Action.Add",
				shouldLocalize = true
			}
		})
	end

	function p5.onSelectedFriendsChanged(p6, p7) -- line: 91
		-- upvalues: p5 (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), NavProps (copy), ArgCheck (copy)
		if not p5.wideMode then
			return
		end

		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.SquadInviteFriends, {
				systemButtonEnabled = p6,
				systemButtonActivated = p7
			})

			return
		end

		local v32 = p5.props.navigation.getScreenProps(NavProps.SET_SCREEN_TOP_BAR, nil)

		ArgCheck.isNotNil(v32, "setScreenTopBar in screenProps")

		if not v32 then
			return
		end

		v32(EnumScreens.SquadInviteFriends, {
			systemButtonEnabled = p6,
			systemButtonActivated = p7
		})
	end
end
function v18.render(p8) -- line: 117
	-- upvalues: React (copy), FFlagEnablePartyQuickStartButton (copy), SquadInviteFriendsContainer (copy), SquadInviteFriends (copy)
	return React.createElement(if not FFlagEnablePartyQuickStartButton then SquadInviteFriends else SquadInviteFriendsContainer, {
		participants = p8.props.participants,
		onSelectedFriendsChanged = if not p8.wideMode then nil else p8.onSelectedFriendsChanged,
		shouldHideFooterButton = p8.wideMode
	})
end
function v18.didMount(p9) -- line: 127
	if p9.wideMode then
		p9.onSelectedFriendsChanged(false, nil)
	end
end

local v20 = RoactRodux.connect(function(p10, p11) -- line: 133
	local v28 = p11.navigation.getParam("conversationId")
	local v29 = p10.ChatAppReducer.Conversations[v28]

	return {
		participants = v29 and v29.participants or nil
	}
end)(v18)

v20.navigationOptions = navigationOptions

return v20
