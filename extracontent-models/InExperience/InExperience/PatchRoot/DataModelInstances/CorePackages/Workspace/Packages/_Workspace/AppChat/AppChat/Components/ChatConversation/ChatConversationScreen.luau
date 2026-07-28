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
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)
local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagAppChatFixBackButtonOnRotation = require(AppChat.Flags.FFlagAppChatFixBackButtonOnRotation)
local canPopParentStack = require(AppChat.Utils.canPopParentStack)

local function getBackButtonConfig(p1) -- line: 40
	-- upvalues: FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy)
	local v28 = p1.getScreenProps("wideMode", false)

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(p1) then
		return true, false
	end

	return not v28, v28
end

local v26 = Roact.PureComponent:extend("ChatConversationScreen")

v26.defaultProps = {
	navigation = nil
}

function v26.navigationOptions(p2) -- line: 52
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), GetFFlagIsSquadEnabled (copy), EnumScreens (copy), Roact (copy), withChatPlacementContext (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	local navigation = p2.navigation

	if FFlagAppChatTopBarConfigDriven() then
		local v31 = navigation.getScreenProps("wideMode", false)
		local v32

		if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
			v32 = true
			v31 = false
		else
			v32 = not v31
		end

		return {
			tabBarVisible = false,
			lockIconEnabled = true,
			absorbInput = false,
			backButtonEnabled = v32,
			isRoot = v31
		}
	end

	local v33 = if not navigation.getScreenProps("wideMode", false) then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)
	local u34 = nil

	if GetFFlagIsSquadEnabled() then
		local v35 = navigation.getParam("conversationId", nil)
		local u36 = if not v35 then nil else tostring(v35)

		local function v37() -- line: 74
			-- upvalues: navigation (copy), EnumScreens (copy), u36 (ref)
			navigation.navigate(EnumScreens.SquadLobby, {
				conversationId = u36
			})
		end

		if u36 then
			u34 = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				}),
				GroupUpButton = withChatPlacementContext(function(p3) -- line: 88
					-- upvalues: Roact (copy), SquadComponentAccessWrapper (copy), u36 (ref), SquadJoinButton (copy), v37 (copy), SquadButtonSourceEnum (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
					return Roact.createElement(SquadComponentAccessWrapper, {
						parentChannelId = u36
					}, Roact.createElement(SquadJoinButton, {
						isFullWidth = false,
						isInCard = false,
						layoutOrder = 0,
						shouldAnimate = true,
						shouldShowSignifier = true,
						conversationId = u36,
						onActivated = v37,
						squadButtonSource = SquadButtonSourceEnum.ChatConversationScreen,
						squadLocation = p3.chatPlacement,
						testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatConversationTopBarButton("squadJoin")
					}))
				end)
			})
		end
	end

	local v38 = navigation.getScreenProps("wideMode", false)
	local v39

	if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
		v39 = true
		v38 = false
	else
		v39 = not v38
	end

	return {
		tabBarVisible = false,
		lockIconEnabled = true,
		absorbInput = false,
		backButtonEnabled = v39,
		isRoot = v38,
		renderRight = function() -- line: 121
			-- upvalues: Roact (copy), u34 (ref)
			return Roact.createFragment({
				groupUp = u34
			})
		end,
		leftPaddingOverride = v33,
		rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
	}
end
function v26.init(p4) -- line: 131
	-- upvalues: FFlagAppChatIxpScreenExposure (copy), IXPNavigationUtils (copy), Roact (copy), FFlagAppChatTopBarConfigDriven (copy), Logger (copy), EnumScreens (copy), FFlagAppChatTopBarSignalsStore (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), GetTopBarStore (copy), ArgCheck (copy), Cryo (copy), readingMessagesIsEnabled (copy)
	p4.ixpSubscription = if not FFlagAppChatIxpScreenExposure then nil else IXPNavigationUtils.registerExposureOnFocus(p4.props.navigation, "Party.ConversationPage")
	p4.toastProps = nil
	p4.inputBoxRef = Roact.createRef()

	if FFlagAppChatTopBarConfigDriven() then
		p4.lastHeaderText = nil
		p4.lastIsPrivateConversation = nil
	end

	local navigation = p4.props.navigation
	local v42 = navigation.getParam and navigation.getParam("conversationId", nil)

	function p4.navigateToConversationOverlay() -- line: 148
		-- upvalues: Logger (copy), v42 (copy), p4 (copy), navigation (copy), EnumScreens (copy)
		Logger:info("Navigate To ConversationOverlay: {} from {screen}", v42)

		local v63 = p4.props.navigation.getParam and p4.props.navigation.getParam("conversationId", nil)

		navigation.navigate(EnumScreens.ConversationOverlay, {
			isOverlay = true,
			conversationId = v63
		})
	end
	function p4.navigateToChatDetails() -- line: 158
		-- upvalues: p4 (copy), Logger (copy), navigation (copy), EnumScreens (copy)
		local v64 = p4.props.navigation.getParam and p4.props.navigation.getParam("conversationId", nil)

		Logger:info("Navigate To ChatDetails: {} from {screen}", v64)
		navigation.navigate(EnumScreens.ChatDetails, {
			conversationId = v64
		})
	end

	if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
		local v43 = navigation.getScreenProps("wideMode", false)
		local t1 = {
			navigateToChatDetails = p4.navigateToChatDetails,
			conversationId = v42
		}

		if FFlagAppChatTopBarConfigDriven() then
			local v45 = navigation.getScreenProps("wideMode", false)
			local v46

			if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation) then
				v46 = true
				v45 = false
			else
				v46 = not v45
			end

			t1.backButtonEnabled = v46
			t1.isRoot = v45
			t1.leftPaddingOverride = if not v43 then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12)
			t1.rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
		end

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, t1)
	else
		local v47 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v47, "setScreenTopBar in screenProps")
		v47(EnumScreens.ChatConversation, {
			navigateToChatDetails = p4.navigateToChatDetails,
			conversationId = v42
		})
	end

	function p4.writeScreenTopBar() -- line: 190
		-- upvalues: p4 (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), GetTopBarStore (copy), EnumScreens (copy)
		local v65 = if not p4.props.navigation.getParam then nil else p4.props.navigation.getParam("conversationId", nil)
		local v66 = p4.props.navigation.getScreenProps("wideMode", false)
		local navigation2 = p4.props.navigation
		local v68 = navigation2.getScreenProps("wideMode", false)
		local v69

		if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(navigation2) then
			v69 = true
			v68 = false
		else
			v69 = not v68
		end

		local t2 = {
			navigateToChatDetails = p4.navigateToChatDetails,
			conversationId = v65,
			backButtonEnabled = v69,
			isRoot = v68,
			leftPaddingOverride = if not v66 then p4.props.navigation.getScreenProps("appChatOuterPadding", 12) else p4.props.navigation.getScreenProps("appChatInnerPadding", 12),
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
	function p4.queueNavigationToToast(p5) -- line: 218
		-- upvalues: p4 (copy)
		if p4.props.navigation.isFocused() then
			p4.navigateToToast(p5)
			p4.toastProps = nil

			return
		end

		p4.toastProps = p5
	end
	function p4.onDidFocus() -- line: 228
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
	function p4.releaseFocus() -- line: 244
		-- upvalues: p4 (copy)
		if p4.inputBoxRef and p4.inputBoxRef:getValue() then
			p4.inputBoxRef:getValue():ReleaseFocus()
		end
	end
	function p4.onWillBlur() -- line: 250
		-- upvalues: p4 (copy)
		p4.releaseFocus()
		p4.setInputBarCloseCallback()
	end
	function p4.navigateToToast(p6) -- line: 256
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy), Cryo (copy)
		Logger:info("Navigate To Toast from {screen}")
		p4.props.navigation.navigate(EnumScreens.RoactChatToast, Cryo.Dictionary.union(p6, {
			isOverlay = true
		}))
	end
	function p4.openViewProfile(p7) -- line: 265
		-- upvalues: p4 (copy), EnumScreens (copy), Logger (copy)
		local v74 = p4.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v74 then
			Logger:info("Navigate To UserProfile from {screen}")
			v74(p7, {})

			return
		end

		Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")
	end
	function p4.openGameDetailsPage(p8, p9) -- line: 277
		-- upvalues: p4 (copy), EnumScreens (copy), Logger (copy)
		local v77 = p4.props.navigation.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.GameDetail]

		if v77 then
			Logger:info("Navigate To GameDetail from " .. tostring(p9))
			v77(p8, p9)

			return
		end

		Logger:warning("GameDetail page was not set in navigateToLuaAppPages screenProps")
	end
	function p4.navigateToChatConversation(p10) -- line: 290
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy)
		Logger:info("Navigate To Conversation: {} from {screen}", p10)
		p4.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p10
		})
	end
	function p4.navigateToScreen(p11, p12, p13) -- line: 295
		-- upvalues: Logger (copy), p4 (copy), Cryo (copy)
		Logger:info("Navigate To Screen: {} from {screen}", p11)

		local navigation3 = p4.props.navigation
		local v83 = navigation3 and (navigation3.getParam and navigation3.getParam("conversationId", nil))

		if p12 then
			p4.props.navigation.navigate(p11, Cryo.Dictionary.union({
				conversationId = v83,
				isOverlay = p13
			}, p12))

			return
		end

		p4.props.navigation.navigate(p11, {
			conversationId = v83
		})
	end
	function p4.navigateBack() -- line: 315
		-- upvalues: p4 (copy)
		if p4.props.navigation.isFocused() then
			p4.props.navigation.goBack()
		end
	end
	function p4.navigateToChatLanding() -- line: 321
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy)
		Logger:info("Navigate To ChatLanding from {screen}")

		if p4.props.navigation.getScreenProps("wideMode", false) then
			p4.props.navigation.navigate(EnumScreens.EmptyConversation)

			return
		end

		p4.props.navigation.navigate(EnumScreens.ChatLanding)
	end
	function p4.navigateToSquadLobby(p14) -- line: 331
		-- upvalues: Logger (copy), p4 (copy), EnumScreens (copy)
		Logger:info("Navigate To SquadLobby from {screen}")
		p4.props.navigation.navigate(EnumScreens.SquadLobby, {
			conversationId = p14
		})
	end
	function p4.updateConversationTitle(p15) -- line: 336
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p4 (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy)
		local v86 = if not p15 then {
			raw = "CommonUI.Features.Label.Chat",
			shouldLocalize = true
		} else {
			shouldLocalize = false,
			raw = p15
		}

		if FFlagAppChatTopBarConfigDriven() then
			p4.lastHeaderText = v86
		end

		local t3 = {
			headerText = v86
		}

		if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, t3)

			return
		end

		local v88 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v88, "setScreenTopBar in screenProps")
		v88(EnumScreens.ChatConversation, t3)
	end
	function p4.setInputBarCloseCallback(p16) -- line: 361
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), p4 (copy), ArgCheck (copy)
		if FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
				closeInputBar = p16
			})

			return
		end

		local v90 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v90, "setScreenTopBar in screenProps")
		v90(EnumScreens.ChatLanding, {
			closeInputBar = p16
		})
	end
	function p4.getReadingMessagesIsEnabled() -- line: 371
		-- upvalues: readingMessagesIsEnabled (copy), p4 (copy)
		return readingMessagesIsEnabled(p4.props.navigation)
	end
	function p4.updatePrivateConversationTopBar(p17) -- line: 375
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

		local v92 = p4.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v92, "setScreenTopBar in screenProps")
		v92(EnumScreens.ChatConversation, {
			isPrivateConversation = p17
		})
	end
end
function v26.didUpdate(p18, p19) -- line: 390
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), EnumScreens (copy), ArgCheck (copy)
	local v50 = p19.navigation and (p19.navigation.getParam and p19.navigation.getParam("conversationId", nil))
	local v51 = p18.props.navigation and (p18.props.navigation.getParam and p18.props.navigation.getParam("conversationId", nil))

	if v50 ~= v51 then
		if FFlagAppChatTopBarConfigDriven() then
			p18.lastHeaderText = nil
			p18.lastIsPrivateConversation = nil
		end

		if FFlagAppChatTopBarConfigDriven() or FFlagAppChatTopBarSignalsStore then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
				conversationId = v51
			})

			return
		end

		local v52 = p18.props.navigation.getScreenProps("setScreenTopBar", nil)

		ArgCheck.isNotNil(v52, "setScreenTopBar in screenProps")
		v52(EnumScreens.ChatConversation, {
			conversationId = v51
		})
	end
end
function v26.render(p20) -- line: 418
	-- upvalues: ArgCheck (copy), Roact (copy), RoactNavigation (copy), ChatConversationContainer (copy)
	local v54 = ArgCheck.isNotNil(p20.props.navigation, "navigation in ChatConversationScreen")
	local v55 = Roact.createElement(RoactNavigation.NavigationEvents, {
		onDidFocus = p20.onDidFocus,
		onWillBlur = p20.onWillBlur
	})
	local v56 = v54.getParam("conversationId", nil)
	local v57 = v56 and tostring(v56) or nil

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		container = Roact.createElement(ChatConversationContainer, {
			topBarHeight = v54.getScreenProps("topBarHeight", 0),
			wideMode = v54.getScreenProps("wideMode", false),
			openGameDetailsPage = p20.openGameDetailsPage,
			getReadingMessagesIsEnabled = p20.getReadingMessagesIsEnabled,
			conversationId = v57,
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
		eventsAdapter = v55
	})
end
function v26.didMount(p21) -- line: 458
	-- upvalues: Logger (copy), FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy)
	Logger:info("{screen} mounted")

	if FFlagAppChatTopBarConfigDriven() then
		local navigation = p21.props.navigation
		local v60 = navigation.getScreenProps("wideMode", false)

		GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatConversation, {
			leftPaddingOverride = if not v60 then navigation.getScreenProps("appChatOuterPadding", 12) else navigation.getScreenProps("appChatInnerPadding", 12),
			rightPaddingOverride = navigation.getScreenProps("appChatOuterPadding", 12)
		})
	end
end
function v26.willUnmount(p22) -- line: 472
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), GetTopBarStore (copy), EnumScreens (copy)
	if FFlagAppChatTopBarConfigDriven() then
		GetTopBarStore(false).clearScreenTopBar(EnumScreens.ChatConversation)
	end

	if p22.ixpSubscription then
		p22.ixpSubscription.remove()
	end
end

return v26
