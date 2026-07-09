local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(AppChatParent.ArgCheck)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
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
local FFlagAppChatUseNewSelectChatMembersIxpEnabled = require(AppChat.Flags.FFlagAppChatUseNewSelectChatMembersIxpEnabled)
local FStringAppChatUseNewSelectChatMembersIxpLayer = require(AppChat.Flags.FStringAppChatUseNewSelectChatMembersIxpLayer)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local v25 = Roact.PureComponent:extend("CreateNewChatScreen")

v25.defaultProps = {}

local function getTabBarVisible(p1) -- line: 36
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy)
	local v28 = p1 and p1.navigation

	if FFlagAppChatWideModalTabBarVisible and (v28 and v28.getScreenProps) then
		return (v28.getScreenProps("wideMode", false))
	end

	return false
end

function v25.navigationOptions(p2) -- line: 45
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy), FFlagAppChatTopBarConfigDriven (copy), GetFFlagIsSquadEnabled (copy), ArgoPartyExperimentation (copy), FFlagConnectionsToFriendsRename (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
	local v30 = p2 and p2.navigation
	local v31 = not not FFlagAppChatWideModalTabBarVisible and (not not v30 and (not not v30.getScreenProps and v30.getScreenProps("wideMode", false)))

	if FFlagAppChatTopBarConfigDriven() then
		return {
			tabBarVisible = v31
		}
	end

	return {
		backButtonEnabled = true,
		tabBarVisible = v31,
		headerText = {
			shouldLocalize = true,
			raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.ChatWithConnections" or if not ArgoPartyExperimentation.getIsRenameEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.PartyWithFriends" else "Feature.Chat.Heading.ChatWithFriends"
		},
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("back"),
		renderRight = function() -- line: 72
			-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), GetFFlagIsSquadEnabled (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
			return Roact.createElement(TopBarProvider, {
				screenName = EnumScreens.CreateNewChat,
				render = function(p3) -- line: 75
					-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), GetFFlagIsSquadEnabled (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
					local v45 = p3.getScreenTopBar(EnumScreens.CreateNewChat)

					ArgCheck.isType(v45, "table", "screenTopBar")

					return withLocalization({
						networkErrorText = "Feature.Chat.Response.NetworkError",
						invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
						systemButtonText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Chat.Action.Create"
					})(function(p4) -- line: 85
						-- upvalues: createSystemMenuButton (copy), v45 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
						return createSystemMenuButton({
							localizedStrings = p4,
							isDisabled = not v45.systemButtonEnabled,
							onActivated = v45.systemButtonActivated,
							testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("create")
						})
					end)
				end
			})
		end
	}
end
function v25.init(p5) -- line: 101
	-- upvalues: FFlagAppChatUseNewSelectChatMembersIxpEnabled (copy), RoactNavigation (copy), IXPService (copy), FStringAppChatUseNewSelectChatMembersIxpLayer (copy), Logger (copy), EnumScreens (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), ArgCheck (copy)
	p5.ixpSubscription = if not FFlagAppChatUseNewSelectChatMembersIxpEnabled then nil else p5.props.navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 103
		-- upvalues: IXPService (copy), FStringAppChatUseNewSelectChatMembersIxpLayer (copy)
		IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatUseNewSelectChatMembersIxpLayer)
	end)

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

		local v41 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v41, "setScreenTopBar in screenProps")
		v41(EnumScreens.CreateNewChat, {
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

		local v43 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v43, "setScreenTopBar in screenProps")
		v43(EnumScreens.CreateNewChat, {
			systemButtonEnabled = p9
		})
	end
end
function v25.render(p10) -- line: 152
	-- upvalues: ArgCheck (copy), Roact (copy), CreateNewChatContainer (copy)
	local v34 = ArgCheck.isNotNil(p10.props.navigation, "navigation in CreateNewChatScreen")

	return Roact.createElement(CreateNewChatContainer, {
		topBarHeight = v34.getScreenProps("topBarHeight", 0),
		navigateToConversation = p10.navigateToConversation,
		navigateToToast = p10.navigateToToast,
		setSystemButtonActivated = p10.setSystemButtonActivated,
		setSystemButtonEnabled = p10.setSystemButtonEnabled
	})
end
function v25.didMount(p11) -- line: 164
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), GetFFlagIsSquadEnabled (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), FFlagConnectionsToFriendsRename (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
			backButtonEnabled = true,
			headerText = {
				shouldLocalize = true,
				raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.ChatWithConnections" or if not ArgoPartyExperimentation.getIsRenameEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.PartyWithFriends" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Heading.PartyWithFriends" or "Feature.Chat.Heading.ChatWithFriends"
			},
			systemButtonText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Chat.Action.Create"
		})
	end

	p11.setSystemButtonEnabled(false)
end
function v25.willUnmount(p12) -- line: 190
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), FFlagAppChatUseNewSelectChatMembersIxpEnabled (copy)
	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).clearScreenTopBar(EnumScreens.CreateNewChat)
	end

	if FFlagAppChatUseNewSelectChatMembersIxpEnabled then
		p12.ixpSubscription.remove()
	end
end

return v25
