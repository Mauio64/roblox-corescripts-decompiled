local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")
local ChatTopBarBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatTopBarBase")
local createBackFunc = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/createBackFunc")
local useCallButtonEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useCallButtonEligibility")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local HeaderBarTitleLeftAligned = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/HeaderBarTitleLeftAligned")
local useChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext").useChatPlacementContext
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppHeaderBar")

local SquadJoinButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadJoinButton")
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadButtonSourceEnum
local SquadComponentAccessWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadComponentAccessWrapper")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local fFlagFriendsCallingServiceLuaMigration = SharedFlags.FFlagFriendsCallingServiceLuaMigration
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ChatConversationTopBar")

local useSignalState = SignalsReact.useSignalState

local function noOp(): nil
	return nil
end

local function ChatConversationTopBar(p2)
	local screenName = p2.screenName
	local navigation = p2.navigation

	local v6 = useSignalState((GetTopBarStore(false).getScreenTopBar(screenName)))

	local headerText = v6.headerText or {}
	local backButtonEnabled = v6.backButtonEnabled
	local isRoot = v6.isRoot
	local conversationId = v6.conversationId

	local v7 = if fFlagFriendsCallingClientGate_DEV then useCallButtonEligibility(conversationId) else nil

	local navigateToChatDetails = v6.navigateToChatDetails
	local rightPaddingOverride = v6.rightPaddingOverride
	local v8 = useChatPlacementContext()

	local v11 = if headerText.shouldLocalize then headerText.raw or nil else nil
	local v12 = useLocalization({ headerText = v11 })

	local screenProps = navigation.getScreenProps("navigateToRootStack", nil)
	local makeBackButton = AppHeaderBar.makeBackButton

	local v13 = createBackFunc({
		navigation = navigation,
		navigateToRootStack = screenProps,
		isRoot = isRoot
	})

	local v14 = if backButtonEnabled then makeBackButton(v13) else nil

	local v15 = React.useCallback(function()
		if not fFlagFriendsCallingClientGate_DEV or v7 ~= ConversationChannels.CallButtonEligibility.Eligible then
			return
		end

		if conversationId then
			if fFlagFriendsCallingServiceLuaMigration then
				local FriendsCallingService = game:GetService("FriendsCallingService")
				local success, result = pcall(function()
					FriendsCallingService:StartCall({ conversationId = conversationId })
				end)

				if not success then
					v5:debug("FriendsCallingService:StartCall failed: {}", result)
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
	end, { conversationId or false, v7 or false })

	local v16 = fFlagFriendsCallingClientGate_DEV

	if v16 then
		v16 = not (conversationId == nil) and v7 == ConversationChannels.CallButtonEligibility.Eligible
	end

	local v17 = not fFlagFriendsCallingClientGate_DEV and getFFlagIsSquadEnabled() and conversationId ~= nil
	local fn

	if v16 then
		fn = function()
			local createElement = React.createElement
			local view = Foundation.View

			local createElement2 = React.createElement
			local iconButton = Foundation.IconButton
			local v20 = {
				icon = Foundation.Enums.IconName.Phone,
				isCircular = true,
				size = Foundation.Enums.InputSize.Medium,
				onActivated = v15,
				testId = 0
			}

			local v21 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatConversationTopBarButton("call") else nil
			v20.testId = v21
			return createElement(view, {
				tag = "row align-x-right align-y-center auto-xy"
			}, {
				CallButton = createElement2(iconButton, v20)
			})
		end
	else
		fn = v17 and function()
			return React.createElement(Foundation.View, {
				tag = "row align-x-right auto-xy"
			}, {
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
						squadButtonSource = squadButtonSourceEnum.ChatConversationScreen,
						squadLocation = v8.chatPlacement
					})
				)
			})
		end or nil
	end

	local function fn2()
		local headerText2 = headerText.shouldLocalize and v12.headerText or headerText.raw or ""
		return React.createElement(HeaderBarTitleLeftAligned, {
			renderLeft = v14,
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
