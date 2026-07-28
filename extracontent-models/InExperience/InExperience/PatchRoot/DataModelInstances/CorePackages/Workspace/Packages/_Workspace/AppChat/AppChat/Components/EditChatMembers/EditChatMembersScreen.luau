local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(AppChatParent.ArgCheck)
local Roact = require(AppChatParent.Roact)
local withLocalization = require(AppChatParent.Localization).withLocalization
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local TopBarProvider = require(AppChat.TopBarProvider)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagAppChatWideModalTabBarVisible = require(AppChat.Flags.FFlagAppChatWideModalTabBarVisible)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local EditChatMembersContainer = require(script.Parent.EditChatMembersContainer)
local Logger = require(script.Parent.Logger)
local v21 = Roact.PureComponent:extend("EditChatMembersScreen")

v21.defaultProps = {}

local function getTabBarVisible(p1) -- line: 30
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy)
	local v24 = p1 and p1.navigation

	if FFlagAppChatWideModalTabBarVisible and (v24 and v24.getScreenProps) then
		return (v24.getScreenProps("wideMode", false))
	end

	return false
end

function v21.navigationOptions(p2) -- line: 39
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagConnectionsToFriendsRename (copy), UniversalAppPolicy (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
	local v26 = p2 and p2.navigation
	local v27 = not not FFlagAppChatWideModalTabBarVisible and (not not v26 and (not not v26.getScreenProps and v26.getScreenProps("wideMode", false)))

	if FFlagAppChatTopBarConfigDriven() then
		return {
			tabBarVisible = v27
		}
	end

	return {
		backButtonEnabled = true,
		tabBarVisible = v27,
		headerText = {
			shouldLocalize = true,
			raw = if not FFlagConnectionsToFriendsRename then not UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() and "Feature.Chat.Label.AddFriends" or "Feature.Chat.Label.AddConnections" else "Feature.Chat.Label.AddFriends"
		},
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("back"),
		renderRight = function() -- line: 65
			-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
			return Roact.createElement(TopBarProvider, {
				screenName = EnumScreens.EditChatMembers,
				render = function(p3) -- line: 68
					-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
					local v41 = p3.getScreenTopBar(EnumScreens.EditChatMembers)

					ArgCheck.isType(v41, "table", "screenTopBar")

					return withLocalization({
						systemButtonText = "Feature.Chat.Action.Add",
						networkErrorText = "Feature.Chat.Response.NetworkError",
						invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
						cannotExpandToGroupChatActivePartyText = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
					})(function(p4) -- line: 77
						-- upvalues: createSystemMenuButton (copy), v41 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
						return createSystemMenuButton({
							localizedStrings = p4,
							isDisabled = not v41.systemButtonEnabled,
							onActivated = v41.systemButtonActivated,
							testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("add")
						})
					end)
				end
			})
		end
	}
end
function v21.init(p5) -- line: 93
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), Logger (copy), EnumScreens (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), ArgCheck (copy)
	p5.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p5.props.navigation, "Party.ChatMembersPage")

	function p5.navigateToConversation(p6) -- line: 99
		-- upvalues: Logger (copy), p5 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p6)
		p5.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p6
		})
	end
	function p5.navigateToToast(p7) -- line: 104
		-- upvalues: Logger (copy), p5 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p5.props.navigation.navigate(EnumScreens.RoactChatToast, p7)
	end
	function p5.setSystemButtonActivated(p8) -- line: 109
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), p5 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
				systemButtonActivated = p8
			})

			return
		end

		local v37 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v37, "setScreenTopBar in screenProps")
		v37(EnumScreens.EditChatMembers, {
			systemButtonActivated = p8
		})
	end
	function p5.setSystemButtonEnabled(p9) -- line: 123
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), p5 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
				systemButtonEnabled = p9
			})

			return
		end

		local v39 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v39, "setScreenTopBar in screenProps")
		v39(EnumScreens.EditChatMembers, {
			systemButtonEnabled = p9
		})
	end
end
function v21.render(p10) -- line: 138
	-- upvalues: ArgCheck (copy), Logger (copy), Roact (copy), EditChatMembersContainer (copy)
	local v30 = ArgCheck.isNotNil(p10.props.navigation, "navigation in EditChatMembersScreen")
	local v31 = v30.getParam("conversation", nil)

	if not v31 then
		Logger:warning("Conversation info required to open {screen}")

		return nil
	end

	return Roact.createElement(EditChatMembersContainer, {
		topBarHeight = v30.getScreenProps("topBarHeight", 0),
		conversation = v31,
		navigateToConversation = p10.navigateToConversation,
		navigateToToast = p10.navigateToToast,
		setSystemButtonActivated = p10.setSystemButtonActivated,
		setSystemButtonEnabled = p10.setSystemButtonEnabled
	})
end
function v21.didMount(p11) -- line: 157
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), FFlagConnectionsToFriendsRename (copy), UniversalAppPolicy (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
			backButtonEnabled = true,
			systemButtonText = "Feature.Chat.Action.Add",
			headerText = {
				shouldLocalize = true,
				raw = if not FFlagConnectionsToFriendsRename then not UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() and "Feature.Chat.Label.AddFriends" or "Feature.Chat.Label.AddConnections" else "Feature.Chat.Label.AddFriends"
			}
		})
	end

	p11.setSystemButtonEnabled(false)
end
function v21.willUnmount(p12) -- line: 178
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy)
	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).clearScreenTopBar(EnumScreens.EditChatMembers)
	end

	if p12.ixpSubscription then
		p12.ixpSubscription.remove()
	end
end

return v21
