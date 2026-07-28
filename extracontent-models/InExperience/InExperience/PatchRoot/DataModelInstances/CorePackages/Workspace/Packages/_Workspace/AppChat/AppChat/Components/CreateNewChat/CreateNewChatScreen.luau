local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(AppChatParent.ArgCheck)
local Roact = require(AppChatParent.Roact)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local withLocalization = require(AppChatParent.Localization).withLocalization
local TopBarProvider = require(AppChat.TopBarProvider)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagAppChatWideModalTabBarVisible = require(AppChat.Flags.FFlagAppChatWideModalTabBarVisible)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local CreateNewChatContainer = require(script.Parent.CreateNewChatContainer)
local Logger = require(script.Parent.Logger)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagAppChatNewChatFixEnabled = require(AppChatParent.SharedFlags).FFlagAppChatNewChatFixEnabled
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local v24 = Roact.PureComponent:extend("CreateNewChatScreen")

v24.defaultProps = {}

local function getTabBarVisible(p1) -- line: 34
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy)
	local v27 = p1 and p1.navigation

	if FFlagAppChatWideModalTabBarVisible and (v27 and v27.getScreenProps) then
		return (v27.getScreenProps("wideMode", false))
	end

	return false
end

function v24.navigationOptions(p2) -- line: 43
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagIsSquadEnabled (copy), ArgoPartyExperimentation (copy), FFlagAppChatNewChatFixEnabled (copy), FFlagConnectionsToFriendsRename (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
	local v29 = p2 and p2.navigation
	local v30 = not not FFlagAppChatWideModalTabBarVisible and (not not v29 and (not not v29.getScreenProps and v29.getScreenProps("wideMode", false)))

	if FFlagAppChatTopBarConfigDriven() then
		return {
			tabBarVisible = v30
		}
	end

	return {
		backButtonEnabled = true,
		tabBarVisible = v30,
		headerText = {
			shouldLocalize = true,
			raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.ChatWithConnections" or if not ArgoPartyExperimentation.getIsRenameEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.PartyWithFriends" else not FFlagAppChatNewChatFixEnabled and "Feature.Chat.Heading.ChatWithFriends" or "Feature.Chat.Title.NewChat"
		},
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("back"),
		renderRight = function() -- line: 72
			-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), GetFFlagIsSquadEnabled (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
			return Roact.createElement(TopBarProvider, {
				screenName = EnumScreens.CreateNewChat,
				render = function(p3) -- line: 75
					-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), GetFFlagIsSquadEnabled (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
					local v44 = p3.getScreenTopBar(EnumScreens.CreateNewChat)

					ArgCheck.isType(v44, "table", "screenTopBar")

					return withLocalization({
						networkErrorText = "Feature.Chat.Response.NetworkError",
						invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
						systemButtonText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Chat.Action.Create"
					})(function(p4) -- line: 85
						-- upvalues: createSystemMenuButton (copy), v44 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
						return createSystemMenuButton({
							localizedStrings = p4,
							isDisabled = not v44.systemButtonEnabled,
							onActivated = v44.systemButtonActivated,
							testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("create")
						})
					end)
				end
			})
		end
	}
end
function v24.init(p5) -- line: 101
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), Logger (copy), EnumScreens (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), ArgCheck (copy)
	p5.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p5.props.navigation, "Party.ChatMembersPage")

	function p5.navigateToConversation(p6) -- line: 107
		-- upvalues: p5 (copy), Logger (copy), EnumScreens (copy)
		local navigation = p5.props.navigation

		Logger:info("Navigate To Conversation: {} from {screen}", p6)

		if navigation.getScreenProps("wideMode", false) then
			navigation.navigate(EnumScreens.ChatConversation, {
				conversationId = p6
			})

			return
		end

		navigation.replace(EnumScreens.ChatConversation, {
			conversationId = p6
		})
	end
	function p5.navigateToToast(p7) -- line: 118
		-- upvalues: Logger (copy), p5 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p5.props.navigation.navigate(EnumScreens.RoactChatToast, p7)
	end
	function p5.setSystemButtonActivated(p8) -- line: 123
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), p5 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
				systemButtonActivated = p8
			})

			return
		end

		local v40 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v40, "setScreenTopBar in screenProps")
		v40(EnumScreens.CreateNewChat, {
			systemButtonActivated = p8
		})
	end
	function p5.setSystemButtonEnabled(p9) -- line: 137
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), p5 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
				systemButtonEnabled = p9
			})

			return
		end

		local v42 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v42, "setScreenTopBar in screenProps")
		v42(EnumScreens.CreateNewChat, {
			systemButtonEnabled = p9
		})
	end
end
function v24.render(p10) -- line: 152
	-- upvalues: ArgCheck (copy), Roact (copy), CreateNewChatContainer (copy)
	local v33 = ArgCheck.isNotNil(p10.props.navigation, "navigation in CreateNewChatScreen")

	return Roact.createElement(CreateNewChatContainer, {
		topBarHeight = v33.getScreenProps("topBarHeight", 0),
		navigateToConversation = p10.navigateToConversation,
		navigateToToast = p10.navigateToToast,
		setSystemButtonActivated = p10.setSystemButtonActivated,
		setSystemButtonEnabled = p10.setSystemButtonEnabled
	})
end
function v24.didMount(p11) -- line: 164
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), GetFFlagIsSquadEnabled (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), FFlagAppChatNewChatFixEnabled (copy), FFlagConnectionsToFriendsRename (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
			backButtonEnabled = true,
			headerText = {
				shouldLocalize = true,
				raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.ChatWithConnections" or if not ArgoPartyExperimentation.getIsRenameEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.PartyWithFriends" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Heading.PartyWithFriends" or (not FFlagAppChatNewChatFixEnabled and "Feature.Chat.Heading.ChatWithFriends" or "Feature.Chat.Title.NewChat")
			},
			systemButtonText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Chat.Action.Create"
		})
	end

	p11.setSystemButtonEnabled(false)
end
function v24.willUnmount(p12) -- line: 192
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy)
	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).clearScreenTopBar(EnumScreens.CreateNewChat)
	end

	if p12.ixpSubscription then
		p12.ixpSubscription.remove()
	end
end

return v24
