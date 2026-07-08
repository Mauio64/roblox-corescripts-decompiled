local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(AppChatParent.ArgCheck)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local Cryo = require(AppChatParent.Cryo)
local readingMessagesIsEnabled = require(script.Parent.Utils.readingMessagesIsEnabled)
local ChatConversationContainer = require(script.Parent.ChatConversationContainer)
local Logger = require(script.Parent.Logger)
local withChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).withChatPlacementContext
local SquadJoinButton = require(AppChatParent.Squads.SquadJoinButton)
local SquadButtonSourceEnum = require(AppChatParent.Squads.Enums).SquadButtonSourceEnum
local SquadComponentAccessWrapper = require(AppChatParent.Squads.SquadComponentAccessWrapper)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagAppChatFixBackButtonOnRotation = require(AppChat.Flags.FFlagAppChatFixBackButtonOnRotation)
local canPopParentStack = require(AppChat.Utils.canPopParentStack)

local function getBackButtonConfig(p1) -- line: 37
	-- upvalues: FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy)
	local v26 = p1.getScreenProps("wideMode", false)

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(p1) then
		return true, false
	end

	return not v26, v26
end

local v24 = Roact.PureComponent:extend("ChatConversationScreen")

v24.defaultProps = {
	navigation = nil
}

function v24.navigationOptions(p2) -- line: 49
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), GetFFlagIsSquadEnabled (copy), EnumScreens (copy), Roact (copy), withChatPlacementContext (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	local navigation = p2.navigation

	if FFlagAppChatTopBarConfigDriven() then
		local v29 = navigation.getScreenProps("wideMode", false)
		local v30

		if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
			v30 = true
			v29 = false
		else
			v30 = not v29
		end

		return {
			tabBarVisible = false,
			lockIconEnabled = true,
			absorbInput = false,
			backButtonEnabled = v30,
			isRoot = v29
		}
	end

	local v31 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)
	local u32 = nil

	if GetFFlagIsSquadEnabled() then
		local v33 = navigation.getParam("conversationId", nil)
		local u34 = if not v33 then nil else tostring(v33)

		local function v35() -- line: 71
			-- upvalues: navigation (copy), EnumScreens (copy), u34 (ref)
			navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = u34
			})
		end

		if u34 then
			u32 = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				}),
				GroupUpButton = withChatPlacementContext(function(p3) -- line: 85
					-- upvalues: Roact (copy), SquadComponentAccessWrapper (copy), u34 (ref), SquadJoinButton (copy), v35 (copy), SquadButtonSourceEnum (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
					return Roact.createElement(SquadComponentAccessWrapper, {
						parentChannelId = u34
					}, Roact.createElement(SquadJoinButton, {
						isFullWidth = false,
						isInCard = false,
						layoutOrder = 0,
						shouldAnimate = true,
						shouldShowSignifier = true,
						conversationId = u34,
						onActivated = v35,
						squadButtonSource = SquadButtonSourceEnum.ChatConversationScreen,
						squadLocation = p3.chatPlacement,
						testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatConversationTopBarButton("squadJoin")
					}))
				end)
			})
		end
	end

	local v36 = navigation.getScreenProps("wideMode", false)
	local v37

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
		v37 = true
		v36 = false
	else
		v37 = not v36
	end

	return {
		tabBarVisible = false,
		lockIconEnabled = true,
		absorbInput = false,
		backButtonEnabled = v37,
		isRoot = v36,
		renderRight = function() -- line: 118
			-- upvalues: Roact (copy), u32 (ref)
			return Roact.createFragment({
				groupUp = u32
			})
		end,
		leftPaddingOverride = v31,
		rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	}
end
function v24.init(p4) -- line: 128
	-- upvalues: Roact (copy), FFlagAppChatTopBarConfigDriven (copy), Logger (copy), EnumScreens (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), GetTopBarStore (copy), ArgCheck (copy), Cryo (copy), readingMessagesIsEnabled (copy)
	p4.toastProps = nil
	p4.inputBoxRef = Roact.createRef()

	if FFlagAppChatTopBarConfigDriven() then
		p4.lastHeaderText = nil
		p4.lastIsPrivateConversation = nil
	end

	local navigation = p4.props.navigation
	local v40 = navigation.getParam and navigation.getParam("conversationId", nil)

	function p4.navigateToConversationOverlay() -- line: 142
		-- upvalues: Logger (copy), v40 (copy), p4 (copy), navigation (copy), EnumScreens (copy)
		Logger:info("Navigate To ConversationOverlay: {} from {screen}", v40)

		local v61 = p4.props.navigation.getParam and p4.props.navigation.getParam("conversationId", nil)

		navigation.navigate(EnumScreens.ConversationOverlay, {
			isOverlay = true,
			conversationId = v61
		})
	end
	function p4.navigateToChatDetails() -- line: 152
		-- upvalues: p4 (copy), Logger (copy), navigation (copy), EnumScreens (copy)
		local v62 = p4.props.navigation.getParam and p4.props.navigation.getParam("conversationId", nil)

		Logger:info("Navigate To ChatDetails: {} from {screen}", v62)
		navigation.navigate(EnumScreens.ChatDetails, {
			conversationId = v62
		})
	end

	if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
		local v41 = navigation.getScreenProps("wideMode", false)
		local t1 = {
			navigateToChatDetails = p4.navigateToChatDetails,
			conversationId = v40
		}

		if FFlagAppChatTopBarConfigDriven() then
			local v43 = navigation.getScreenProps("wideMode", false)
			local v44

			if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
				v44 = true
				v43 = false
			else
				v44 = not v43
			end

			t1.backButtonEnabled = v44
			t1.isRoot = v43
			t1.leftPaddingOverride = if not v41 then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)
			t1.rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, t1)
	else
		local v45 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v45, "setScreenTopBar in screenProps")
		v45(EnumScreens.ChatConversation, {
			navigateToChatDetails = p4.navigateToChatDetails,
			conversationId = v40
		})
	end

	function p4.writeScreenTopBar() -- line: 184
		-- upvalues: p4 (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), GetTopBarStore (copy), EnumScreens (copy)
		local v63 = if not p4.props.navigation.getParam then nil else p4.props.navigation.getParam("conversationId", nil)
		local v64 = p4.props.navigation.getScreenProps("wideMode", false)
		local navigation2 = p4.props.navigation
		local v66 = navigation2.getScreenProps("wideMode", false)
		local v67

		if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation2) then
			v67 = true
			v66 = false
		else
			v67 = not v66
		end

		local t2 = {
			navigateToChatDetails = p4.navigateToChatDetails,
			conversationId = v63,
			backButtonEnabled = v67,
			isRoot = v66,
			leftPaddingOverride = if not v64 then p4.props.navigation.getScreenProps("appChatOuterPadding", 12) else p4.props.navigation.getScreenProps("appChatInnerPadding", 12),
			rightPaddingOverride = p4.props.navigation.getScreenProps("appChatOuterPadding", 12)
		}

		if p4.lastHeaderText ~= nil then
			t2.headerText = p4.lastHeaderText
		end

		if p4.lastIsPrivateConversation ~= nil then
			t2.isPrivateConversation = p4.lastIsPrivateConversation
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, t2)
	end
	function p4.queueNavigationToToast(p5) -- line: 212
		-- upvalues: p4 (copy)
		if p4.props.navigation.isFocused() then
			p4.navigateToToast(p5)
			p4.toastProps = nil

			return
		end

		p4.toastProps = p5
	end
	function p4.onDidFocus() -- line: 222
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p4 (copy)
		if FFlagAppChatTopBarConfigDriven() then
			p4.writeScreenTopBar()
		end

		p4.setInputBarCloseCallback(p4.releaseFocus)

		if p4.toastProps then
			p4.navigateToToast(p4.toastProps)
			p4.toastProps = nil
		end
	end
	function p4.releaseFocus() -- line: 238
		-- upvalues: p4 (copy)
		if p4.inputBoxRef and p4.inputBoxRef:getValue() then
			p4.inputBoxRef:getValue():ReleaseFocus()
		end
	end
	function p4.onWillBlur() -- line: 244
		-- upvalues: p4 (copy)
		p4.releaseFocus()
		p4.setInputBarCloseCallback()
	end
	function p4.navigateToToast(p6) -- line: 250
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy), Cryo (copy)
		Logger:info("Navigate To Toast from {screen}")
		p4.props.navigation.navigate(EnumScreens.RoactChatToast, Cryo.Dictionary.union(p6, {
			isOverlay = true
		}))
	end
	function p4.openViewProfile(p7) -- line: 259
		-- upvalues: p4 (copy), EnumScreens (copy), Logger (copy)
		local v72 = p4.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v72 then
			Logger:info("Navigate To UserProfile from {screen}")
			v72(p7, {})

			return
		end

		Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")
	end
	function p4.openGameDetailsPage(p8, p9) -- line: 271
		-- upvalues: p4 (copy), EnumScreens (copy), Logger (copy)
		local v75 = p4.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.GameDetail]

		if v75 then
			Logger:info("Navigate To GameDetail from " .. tostring(p9))
			v75(p8, p9)

			return
		end

		Logger:warning("GameDetail page was not set in navigateToLuaAppPages screenProps")
	end
	function p4.navigateToChatConversation(p10) -- line: 284
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p10)
		p4.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p10
		})
	end
	function p4.navigateToScreen(p11, p12, p13) -- line: 289
		-- upvalues: Logger (copy), p4 (copy), Cryo (copy)
		Logger:info("Navigate To Screen: {} from {screen}", p11)

		local navigation3 = p4.props.navigation
		local v81 = navigation3 and (navigation3.getParam and navigation3.getParam("conversationId", nil))

		if p12 then
			p4.props.navigation.navigate(p11, Cryo.Dictionary.union({
				conversationId = v81,
				isOverlay = p13
			}, p12))

			return
		end

		p4.props.navigation.navigate(p11, {
			conversationId = v81
		})
	end
	function p4.navigateBack() -- line: 309
		-- upvalues: p4 (copy)
		if p4.props.navigation.isFocused() then
			p4.props.navigation.goBack()
		end
	end
	function p4.navigateToChatLanding() -- line: 315
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy)
		Logger:info("Navigate To ChatLanding from {screen}")

		if p4.props.navigation.getScreenProps("wideMode", false) then
			p4.props.navigation.navigate(EnumScreens.EmptyConversation)

			return
		end

		p4.props.navigation.navigate(EnumScreens.ChatLanding)
	end
	function p4.navigateToSquadLobby(p14) -- line: 325
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy)
		Logger:info("Navigate To SquadLobby from {screen}")
		p4.props.navigation.navigate(EnumScreens.SquadLobby, {
			conversationId = p14
		})
	end
	function p4.updateConversationTitle(p15) -- line: 330
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p4 (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy)
		local v84 = if not p15 then {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} else {
			shouldLocalize = false,
			raw = p15
		}

		if FFlagAppChatTopBarConfigDriven() then
			p4.lastHeaderText = v84
		end

		local t3 = {
			headerText = v84
		}

		if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, t3)

			return
		end

		local v86 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v86, "setScreenTopBar in screenProps")
		v86(EnumScreens.ChatConversation, t3)
	end
	function p4.setInputBarCloseCallback(p16) -- line: 355
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p4 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
				closeInputBar = p16
			})

			return
		end

		local v88 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v88, "setScreenTopBar in screenProps")
		v88(EnumScreens.ChatLanding, {
			closeInputBar = p16
		})
	end
	function p4.getReadingMessagesIsEnabled() -- line: 365
		-- upvalues: readingMessagesIsEnabled (copy), p4 (copy)
		return readingMessagesIsEnabled(p4.props.navigation)
	end
	function p4.updatePrivateConversationTopBar(p17) -- line: 369
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p4 (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy)
		if FFlagAppChatTopBarConfigDriven() then
			p4.lastIsPrivateConversation = p17
		end

		if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
				isPrivateConversation = p17
			})

			return
		end

		local v90 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v90, "setScreenTopBar in screenProps")
		v90(EnumScreens.ChatConversation, {
			isPrivateConversation = p17
		})
	end
end
function v24.didUpdate(p18, p19) -- line: 384
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy)
	local v48 = p19.navigation and (p19.navigation.getParam and p19.navigation.getParam("conversationId", nil))
	local v49 = p18.props.navigation and (p18.props.navigation.getParam and p18.props.navigation.getParam("conversationId", nil))

	if v48 ~= v49 then
		if FFlagAppChatTopBarConfigDriven() then
			p18.lastHeaderText = nil
			p18.lastIsPrivateConversation = nil
		end

		if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
				conversationId = v49
			})

			return
		end

		local v50 = p18.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v50, "setScreenTopBar in screenProps")
		v50(EnumScreens.ChatConversation, {
			conversationId = v49
		})
	end
end
function v24.render(p20) -- line: 412
	-- upvalues: ArgCheck (copy), Roact (copy), RoactNavigation (copy), ChatConversationContainer (copy)
	local v52 = ArgCheck.isNotNil(p20.props.navigation, "navigation in ChatConversationScreen")
	local v53 = Roact.createElement(RoactNavigation.NavigationEvents, {
		onDidFocus = p20.onDidFocus,
		onWillBlur = p20.onWillBlur
	})
	local v54 = v52.getParam("conversationId", nil)
	local v55 = v54 and tostring(v54) or nil

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		container = Roact.createElement(ChatConversationContainer, {
			topBarHeight = v52.getScreenProps("topBarHeight", 0),
			wideMode = v52.getScreenProps("wideMode", false),
			openGameDetailsPage = p20.openGameDetailsPage,
			getReadingMessagesIsEnabled = p20.getReadingMessagesIsEnabled,
			conversationId = v55,
			inputBoxRef = p20.inputBoxRef,
			updateConversationTitle = p20.updateConversationTitle,
			updatePrivateConversationTopBar = p20.updatePrivateConversationTopBar,
			releaseInputBarFocus = p20.releaseFocus,
			navigateBack = p20.navigateBack,
			navigateToToast = p20.queueNavigationToToast,
			openViewProfile = p20.openViewProfile,
			navigateToChatConversation = p20.navigateToChatConversation,
			navigateToChatLanding = p20.navigateToChatLanding,
			navigateToScreen = p20.navigateToScreen,
			navigateToSquadLobby = p20.navigateToSquadLobby,
			navigateToConversationOverlay = p20.navigateToConversationOverlay,
			navigation = p20.props.navigation
		}),
		eventsAdapter = v53
	})
end
function v24.didMount(p21) -- line: 452
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p21.props.navigation
		local v58 = navigation.getScreenProps("wideMode", false)

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
			leftPaddingOverride = if not v58 then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12),
			rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
		})
	end
end
function v24.willUnmount(_) -- line: 466
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy)
	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).clearScreenTopBar(EnumScreens.ChatConversation)
	end
end

return v24
