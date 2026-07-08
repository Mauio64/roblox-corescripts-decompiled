local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ChatTopBarBase = require(script.Parent.ChatTopBarBase)
local createBackFunc = require(script.Parent.createBackFunc)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local HeaderBarTitleLeftAligned = require(AppChat.Components.ChatConversation.HeaderBarTitleLeftAligned)
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local SignalsReact = require(AppChatParent.SignalsReact)
local AppHeaderBar = require(AppChatParent.AppHeaderBar)
local SquadJoinButton = require(AppChatParent.Squads.SquadJoinButton)
local SquadButtonSourceEnum = require(AppChatParent.Squads.Enums).SquadButtonSourceEnum
local SquadComponentAccessWrapper = require(AppChatParent.Squads.SquadComponentAccessWrapper)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local useSignalState = SignalsReact.useSignalState

local function noOp() -- line: 36
	return nil
end
local function ChatConversationTopBar(t1: {[any]: any}) -- line: 45
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), useSignalState (copy), useChatPlacementContext (copy), useLocalization (copy), AppHeaderBar (copy), createBackFunc (copy), GetFFlagIsSquadEnabled (copy), EnumScreens (copy), React (copy), Foundation (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy), HeaderBarTitleLeftAligned (copy), ChatTopBarBase (copy), noOp (copy)
	if not FFlagAppChatTopBarConfigDriven() then
		return nil
	end

	local screenName = t1.screenName
	local navigation = t1.navigation
	local v25 = GetTopBarStore(false).getScreenTopBar(screenName)
	local v26 = useSignalState(v25)
	local v27 = v26.headerText or {}
	local backButtonEnabled = v26.backButtonEnabled
	local isRoot = v26.isRoot
	local conversationId = v26.conversationId
	local navigateToChatDetails = v26.navigateToChatDetails
	local rightPaddingOverride = v26.rightPaddingOverride
	local v33 = useChatPlacementContext()
	local v34 = useLocalization({
		headerText = v27.shouldLocalize and v27.raw or nil
	})
	local v35 = navigation.getScreenProps("navigateToRootStack", nil)
	local makeBackButton = AppHeaderBar.makeBackButton
	local v37 = createBackFunc({
		navigation = navigation,
		navigateToRootStack = v35,
		isRoot = isRoot
	})
	local v38 = if not backButtonEnabled then nil else makeBackButton(v37)
	local u39 = nil

	if GetFFlagIsSquadEnabled() and conversationId then
		local function v40() -- line: 81
			-- upvalues: navigation (copy), EnumScreens (copy), conversationId (copy)
			navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = conversationId
			})
		end

		function u39() -- line: 84
			-- upvalues: React (copy), Foundation (copy), SquadComponentAccessWrapper (copy), conversationId (copy), SquadJoinButton (copy), v40 (copy), SquadButtonSourceEnum (copy), v33 (copy)
			return React.createElement(Foundation.View, {
				tag = "row align-x-right auto-xy"
			}, {
				GroupUpButton = React.createElement(SquadComponentAccessWrapper, {
					parentChannelId = conversationId
				}, React.createElement(SquadJoinButton, {
					isFullWidth = false,
					isInCard = false,
					layoutOrder = 0,
					shouldAnimate = true,
					shouldShowSignifier = true,
					conversationId = conversationId,
					onActivated = v40,
					squadButtonSource = SquadButtonSourceEnum.ChatConversationScreen,
					squadLocation = v33.chatPlacement
				}))
			})
		end
	end

	return React.createElement(ChatTopBarBase, {
		screenName = screenName,
		navigation = navigation,
		renderLeft = noOp,
		renderCenter = function() -- line: 109
			-- upvalues: v27 (copy), v34 (copy), React (copy), HeaderBarTitleLeftAligned (copy), v38 (copy), u39 (ref), conversationId (copy), navigateToChatDetails (copy), rightPaddingOverride (copy)
			local v41 = v27.shouldLocalize and v34.headerText or (v27.raw or "")

			return React.createElement(HeaderBarTitleLeftAligned, {
				renderLeft = v38,
				renderRight = u39,
				titleText = v41,
				conversationId = conversationId or "",
				navigateToChatDetails = navigateToChatDetails or function() -- line: 116
				end,
				ignoreRightMargin = rightPaddingOverride ~= nil
			})
		end
	})
end

return ChatConversationTopBar
