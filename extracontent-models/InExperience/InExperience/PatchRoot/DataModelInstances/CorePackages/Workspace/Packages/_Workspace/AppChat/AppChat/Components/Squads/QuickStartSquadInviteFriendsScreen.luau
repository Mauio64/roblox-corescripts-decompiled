local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local resetForSquadLobbyForCompactMode = require(AppChat.Utils.resetForSquadLobbyForCompactMode)
local resetForSquadLobbyForWideMode = require(AppChat.Utils.resetForSquadLobbyForWideMode)
local ArgCheck = require(AppChatParent.ArgCheck)
local React = require(AppChatParent.React)
local withLocalization = require(AppChatParent.Localization).withLocalization
local TopBarProvider = require(AppChat.TopBarProvider)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local EnumScreens = require(AppChat.EnumScreens)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local NavProps = require(AppChat.Constants).NavProps
local QuickStartSquadInviteFriendsContainer = require(AppChatParent.Squads.QuickStartSquadInviteFriendsContainer)
local v16 = React.PureComponent:extend("QuickStartSquadInviteFriendsScreen")

function v16.navigationOptions(p1) -- line: 24
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), NavProps (copy), React (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
	if FFlagAppChatTopBarConfigDriven() then
		return {
			backButtonEnabled = true
		}
	end

	local v18 = p1.navigation and (p1.navigation.getScreenProps and p1.navigation.getScreenProps(NavProps.WIDE_MODE, false))

	return {
		backButtonEnabled = true,
		headerText = {
			raw = "Feature.Squads.Action.Party",
			shouldLocalize = true
		},
		renderRight = if not v18 then nil else function() -- line: 43
			-- upvalues: React (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
			return React.createElement(TopBarProvider, {
				screenName = EnumScreens.QuickStartSquadInviteFriends,
				render = function(p2) -- line: 46
					-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
					local v33 = p2.getScreenTopBar(EnumScreens.QuickStartSquadInviteFriends)

					ArgCheck.isType(v33, "table", "screenTopBar")

					return withLocalization({
						systemButtonText = "Feature.Squads.Action.Start"
					})(function(p3) -- line: 52
						-- upvalues: createSystemMenuButton (copy), v33 (copy)
						return createSystemMenuButton({
							localizedStrings = p3,
							isDisabled = not v33.systemButtonEnabled,
							onActivated = v33.systemButtonActivated
						})
					end)
				end
			})
		end
	}
end
function v16.init(p4) -- line: 66
	-- upvalues: NavProps (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), resetForSquadLobbyForWideMode (copy), resetForSquadLobbyForCompactMode (copy), FFlagAppChatTopBarSignalsStore (copy), ArgCheck (copy)
	p4.wideMode = p4.props.navigation.getScreenProps(NavProps.WIDE_MODE, false)

	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.QuickStartSquadInviteFriends, {
			backButtonEnabled = true,
			systemButtonText = "Feature.Squads.Action.Start",
			headerText = {
				raw = "Feature.Squads.Action.Party",
				shouldLocalize = true
			}
		})
	end

	function p4.navigateIntoSquadLobby(p5) -- line: 80
		-- upvalues: p4 (copy), NavProps (copy), resetForSquadLobbyForWideMode (copy), resetForSquadLobbyForCompactMode (copy)
		local v27 = p4.props.navigation.getScreenProps(NavProps.WIDE_MODE, false)
		local v28 = p4.props.navigation.getParam("partyAttemptId", nil)

		if v27 then
			resetForSquadLobbyForWideMode(p4.props.navigation, p5, {
				squadCreateOrJoinAttemptId = v28
			})

			return
		end

		resetForSquadLobbyForCompactMode(p4.props.navigation, p5, {
			squadCreateOrJoinAttemptId = v28
		})
	end
	function p4.onSelectedFriendsChanged(p6, p7) -- line: 94
		-- upvalues: p4 (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), NavProps (copy), ArgCheck (copy)
		if not p4.wideMode then
			return
		end

		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.QuickStartSquadInviteFriends, {
				systemButtonEnabled = p6,
				systemButtonActivated = p7
			})

			return
		end

		local v31 = p4.props.navigation.getScreenProps(NavProps.SET_SCREEN_TOP_BAR, nil)

		ArgCheck.isNotNil(v31, "setScreenTopBar in screenProps")

		if not v31 then
			return
		end

		v31(EnumScreens.QuickStartSquadInviteFriends, {
			systemButtonEnabled = p6,
			systemButtonActivated = p7
		})
	end
end
function v16.render(p8) -- line: 120
	-- upvalues: ArgCheck (copy), React (copy), QuickStartSquadInviteFriendsContainer (copy)
	local v21 = ArgCheck.isNotNil(p8.props.navigation, "navigation in CreateNewChatScreen")
	local v22 = v21.getScreenProps("topBarHeight", 0)
	local v23 = v21.getScreenProps("wideMode", false)
	local v24 = p8.props.navigation.getParam("partyAttemptId", nil)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, not v23 and 0 or -v22)
	}, { React.createElement(QuickStartSquadInviteFriendsContainer, {
		navigateIntoSquadLobby = p8.navigateIntoSquadLobby,
		partyAttemptId = v24,
		onSelectedFriendsChanged = p8.onSelectedFriendsChanged,
		shouldHideFooterButton = p8.wideMode
	}) })
end
function v16.didMount(p9) -- line: 138
	if p9.wideMode then
		p9.onSelectedFriendsChanged(false, nil)
	end
end

return v16
