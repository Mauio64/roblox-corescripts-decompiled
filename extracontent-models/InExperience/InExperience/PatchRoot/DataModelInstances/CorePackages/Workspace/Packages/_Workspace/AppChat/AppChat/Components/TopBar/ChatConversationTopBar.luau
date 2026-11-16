local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local ChatTopBarBase = require(script.Parent.ChatTopBarBase)
local createBackFunc = require(script.Parent.createBackFunc)
local useCallButtonEligibility = require(AppChat.Hooks.useCallButtonEligibility)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local HeaderBarTitleLeftAligned = require(AppChat.Components.ChatConversation.HeaderBarTitleLeftAligned)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local ConversationChannels = require(AppChat.Models.ConversationChannels)

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local AppHeaderBar = require(parent.AppHeaderBar)

local SquadJoinButton = require(parent.Squads.SquadJoinButton)
local Enums = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums.SquadButtonSourceEnum
local SquadComponentAccessWrapper = require(parent.Squads.SquadComponentAccessWrapper)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local FFlagFriendsCallingServiceLuaMigration = SharedFlags.FFlagFriendsCallingServiceLuaMigration
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local useSignalState = SignalsReact.useSignalState

local function noOp(): nil
	return nil
end

local function ChatConversationTopBar(p)
	local screenName = p.screenName
	local navigation = p.navigation

	local v2 = useSignalState((GetTopBarStore(false).getScreenTopBar(screenName)))

	local headerText = v2.headerText or {}
	local backButtonEnabled = v2.backButtonEnabled
	local isRoot = v2.isRoot
	local conversationId = v2.conversationId
	local v3

	if FFlagFriendsCallingClientGate_DEV then
		v3 = useCallButtonEligibility(conversationId)
	else
		v3 = nil
	end

	local navigateToChatDetails = v2.navigateToChatDetails
	local rightPaddingOverride = v2.rightPaddingOverride
	local v4 = useChatPlacementContext()
	local headerText3

	if headerText.shouldLocalize then
		headerText3 = headerText.raw or nil
	end

	local v5 = useLocalization({ headerText = headerText3 })

	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)
	local makeBackButton = AppHeaderBar.makeBackButton

	local backFunc = createBackFunc({
		navigation = navigation,
		navigateToRootStack = screenProps,
		isRoot = isRoot
	})
	local renderLeft

	if backButtonEnabled then
		renderLeft = makeBackButton(backFunc)
	else
		renderLeft = nil
	end

	local onActivated = React.useCallback(function()
		if not FFlagFriendsCallingClientGate_DEV or v3 ~= ConversationChannels.CallButtonEligibility.Eligible then
			return
		end

		if conversationId then
			if FFlagFriendsCallingServiceLuaMigration then
				local FriendsCallingService = game:GetService("FriendsCallingService")
				local success, result = pcall(function()
					FriendsCallingService:StartCall({ conversationId = conversationId })
				end)

				if not success then
					v:debug("FriendsCallingService:StartCall failed: {}", result)
				end
			else
				local CallingService = game:GetService("CallingService")
				task.spawn(function()
					pcall(function()
						CallingService:CreateCallAsync({}, conversationId)
					end)
				end)
			end
		end
	end, { conversationId or false, v3 or false })

	local v6 = FFlagFriendsCallingClientGate_DEV

	if v6 then
		if conversationId == nil then
			v6 = false
		else
			v6 = v3 == ConversationChannels.CallButtonEligibility.Eligible
		end
	end

	local v7 = not FFlagFriendsCallingClientGate_DEV and GetFFlagIsSquadEnabled() and conversationId ~= nil
	local fn

	if v6 then
		fn = function()
			local createElement = React.createElement
			local view = Foundation.View

			local createElement2 = React.createElement
			local iconButton = Foundation.IconButton
			local v8 = {
				icon = Foundation.Enums.IconName.Phone,
				isCircular = true,
				size = Foundation.Enums.InputSize.Medium,
				onActivated = onActivated,
				testId = 0
			}
			local testId

			if FFlagDebugAppChatEnableDomLocators then
				testId = DomLocators.chatConversationTopBarButton("call")
			end

			v8.testId = testId
			return createElement(view, { tag = "row align-x-right align-y-center auto-xy" }, {
				CallButton = createElement2(iconButton, v8)
			})
		end
	else
		fn = v7 and function()
			return React.createElement(Foundation.View, { tag = "row align-x-right auto-xy" }, {
				GroupUpButton = React.createElement(
					SquadComponentAccessWrapper,
					{ parentChannelId = conversationId },
					React.createElement(SquadJoinButton, {
						conversationId = conversationId,
						isFullWidth = false,
						isInCard = false,
						layoutOrder = 0,
						onActivated = function()
							navigation.navigate(EnumScreens.SquadLobby, {
								conversationId = conversationId
							})
						end,
						shouldAnimate = true,
						shouldShowSignifier = true,
						squadButtonSource = SquadButtonSourceEnum.ChatConversationScreen,
						squadLocation = v4.chatPlacement
					})
				)
			})
		end or nil
	end

	local function fn2()
		local headerText2 = headerText.shouldLocalize and v5.headerText or headerText.raw or ""
		return React.createElement(HeaderBarTitleLeftAligned, {
			renderLeft = renderLeft,
			renderRight = fn,
			titleText = headerText2,
			conversationId = conversationId or "",
			navigateToChatDetails = navigateToChatDetails or function() end,
			ignoreRightMargin = rightPaddingOverride ~= nil
		})
	end

	return React.createElement(ChatTopBarBase, {
		screenName = screenName,
		navigation = navigation,
		renderLeft = noOp,
		renderCenter = fn2
	})
end

return ChatConversationTopBar
