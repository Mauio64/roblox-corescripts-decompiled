local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(AppChatParent.ArgCheck)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local withLocalization = require(AppChatParent.Localization).withLocalization
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local TopBarProvider = require(AppChat.TopBarProvider)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagAppChatWideModalTabBarVisible = require(AppChat.Flags.FFlagAppChatWideModalTabBarVisible)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagAppChatUseNewSelectChatMembersIxpEnabled = require(AppChat.Flags.FFlagAppChatUseNewSelectChatMembersIxpEnabled)
local FStringAppChatUseNewSelectChatMembersIxpLayer = require(AppChat.Flags.FStringAppChatUseNewSelectChatMembersIxpLayer)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local EditChatMembersContainer = require(script.Parent.EditChatMembersContainer)
local Logger = require(script.Parent.Logger)
local v23 = Roact.PureComponent:extend("EditChatMembersScreen")

v23.defaultProps = {}

local function getTabBarVisible(p1) -- line: 31
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy)
	local v26 = p1 and p1.navigation

	if FFlagAppChatWideModalTabBarVisible and (v26 and v26.getScreenProps) then
		return (v26.getScreenProps("wideMode", false))
	end

	return false
end

function v23.navigationOptions(p2) -- line: 40
	-- upvalues: FFlagAppChatWideModalTabBarVisible (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagConnectionsToFriendsRename (copy), UniversalAppPolicy (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy)
	local v28 = p2 and p2.navigation
	local v29 = not not FFlagAppChatWideModalTabBarVisible and (not not v28 and (not not v28.getScreenProps and v28.getScreenProps("wideMode", false)))

	if FFlagAppChatTopBarConfigDriven() then
		return {
			tabBarVisible = v29
		}
	end

	return {
		backButtonEnabled = true,
		tabBarVisible = v29,
		headerText = {
			shouldLocalize = true,
			raw = if not FFlagConnectionsToFriendsRename then not UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections() and "Feature.Chat.Label.AddFriends" or "Feature.Chat.Label.AddConnections" else "Feature.Chat.Label.AddFriends"
		},
		backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("back"),
		renderRight = function() -- line: 66
			-- upvalues: Roact (copy), TopBarProvider (copy), EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
			return Roact.createElement(TopBarProvider, {
				screenName = EnumScreens.EditChatMembers,
				render = function(p3) -- line: 69
					-- upvalues: EnumScreens (copy), ArgCheck (copy), withLocalization (copy), createSystemMenuButton (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
					local v43 = p3.getScreenTopBar(EnumScreens.EditChatMembers)

					ArgCheck.isType(v43, "table", "screenTopBar")

					return withLocalization({
						systemButtonText = "Feature.Chat.Action.Add",
						networkErrorText = "Feature.Chat.Response.NetworkError",
						invalidParticipantText = "Feature.Chat.Toast.Error.InvalidUserSelected",
						cannotExpandToGroupChatActivePartyText = "Feature.Squads.Description.OneOnOneExpandedChatFeaturesActivePartyError"
					})(function(p4) -- line: 78
						-- upvalues: createSystemMenuButton (copy), v43 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
						return createSystemMenuButton({
							localizedStrings = p4,
							isDisabled = not v43.systemButtonEnabled,
							onActivated = v43.systemButtonActivated,
							testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.selectChatMembersTopBarActionButton("add")
						})
					end)
				end
			})
		end
	}
end
function v23.init(p5) -- line: 94
	-- upvalues: FFlagAppChatUseNewSelectChatMembersIxpEnabled (copy), RoactNavigation (copy), IXPService (copy), FStringAppChatUseNewSelectChatMembersIxpLayer (copy), Logger (copy), EnumScreens (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), ArgCheck (copy)
	p5.ixpSubscription = if not FFlagAppChatUseNewSelectChatMembersIxpEnabled then nil else p5.props.navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 96
		-- upvalues: IXPService (copy), FStringAppChatUseNewSelectChatMembersIxpLayer (copy)
		IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatUseNewSelectChatMembersIxpLayer)
	end)

	function p5.navigateToConversation(p6) -- line: 100
		-- upvalues: Logger (copy), p5 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p6)
		p5.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p6
		})
	end
	function p5.navigateToToast(p7) -- line: 105
		-- upvalues: Logger (copy), p5 (copy), EnumScreens (copy)
		Logger:info("Navigate To Toast from {screen}")
		p5.props.navigation.navigate(EnumScreens.RoactChatToast, p7)
	end
	function p5.setSystemButtonActivated(p8) -- line: 110
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), p5 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
				systemButtonActivated = p8
			})

			return
		end

		local v39 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v39, "setScreenTopBar in screenProps")
		v39(EnumScreens.EditChatMembers, {
			systemButtonActivated = p8
		})
	end
	function p5.setSystemButtonEnabled(p9) -- line: 124
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), p5 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore or FFlagAppChatTopBarConfigDriven() then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
				systemButtonEnabled = p9
			})

			return
		end

		local v41 = p5.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v41, "setScreenTopBar in screenProps")
		v41(EnumScreens.EditChatMembers, {
			systemButtonEnabled = p9
		})
	end
end
function v23.render(p10) -- line: 139
	-- upvalues: ArgCheck (copy), Logger (copy), Roact (copy), EditChatMembersContainer (copy)
	local v32 = ArgCheck.isNotNil(p10.props.navigation, "navigation in EditChatMembersScreen")
	local v33 = v32.getParam("conversation", nil)

	if not v33 then
		Logger:warning("Conversation info required to open {screen}")

		return nil
	end

	return Roact.createElement(EditChatMembersContainer, {
		topBarHeight = v32.getScreenProps("topBarHeight", 0),
		conversation = v33,
		navigateToConversation = p10.navigateToConversation,
		navigateToToast = p10.navigateToToast,
		setSystemButtonActivated = p10.setSystemButtonActivated,
		setSystemButtonEnabled = p10.setSystemButtonEnabled
	})
end
function v23.didMount(p11) -- line: 158
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
function v23.willUnmount(p12) -- line: 179
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy), FFlagAppChatUseNewSelectChatMembersIxpEnabled (copy)
	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).clearScreenTopBar(EnumScreens.EditChatMembers)
	end

	if FFlagAppChatUseNewSelectChatMembersIxpEnabled then
		p12.ixpSubscription.remove()
	end
end

return v23
