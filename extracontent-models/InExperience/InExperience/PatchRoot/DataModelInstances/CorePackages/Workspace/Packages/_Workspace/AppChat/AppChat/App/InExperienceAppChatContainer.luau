local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppCommonLib = require(AppChatParent.AppCommonLib)
local FormFactor = require(AppChatParent.FormFactor)
local React = require(AppChatParent.React)
local RealtimeDelivery = require(AppChatParent.RealtimeDelivery)
local Responsive = require(AppChatParent.Responsive)
local RoactUtils = require(AppChatParent.RoactUtils)
local SharedFlags = require(AppChatParent.SharedFlags)
local Foundation = require(AppChatParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Loading = Foundation.Loading
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local SetFormFactor = FormFactor.Actions.SetFormFactor
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppChatEntryPoint = require(AppChat.AppChatEntryPoint)
local ChatEventReceiver = require(AppChat.Components.EventReceivers.ChatEventReceiver)
local ChatExternalEventReceiver = require(AppChat.App.Components.ChatExternalEventReceiver)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)

require(AppChat.App.InExperienceAppChatModal)

local useParentContainerExtents = require(AppChat.Contexts.ParentContainer.useParentContainerExtents)
local Container = require(AppChat.Components.ExternalNavigationHandler.Container)
local useExternalNavigationByScreen = require(AppChat.Hooks.useExternalNavigationByScreen)
local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local LocalPlayer = Players.LocalPlayer
local RobloxEventReceiver = RealtimeDelivery.RobloxEventReceiver
local Signal = AppCommonLib.Signal
local SquadAppChatEventReceiver = require(AppChatParent.SquadsCore.Components).SquadAppChatEventReceiver
local useMemo = React.useMemo
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback
local useContext = React.useContext
local useRef = React.useRef
local v41 = game:DefineFastInt("AppChatInExperienceMountMinLoadingTimeMs", 0)
local FFlagAppChatInExpSelectChatMembersMobileHeight = require(AppChat.Flags.FFlagAppChatInExpSelectChatMembersMobileHeight)
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FIntAppChatWideBreakpointMinHeight = require(AppChat.Flags.FIntAppChatWideBreakpointMinHeight)
local FIntAppChatWideBreakpointMinWidth = require(AppChat.Flags.FIntAppChatWideBreakpointMinWidth)
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local getFFlagAppChatRequestedRoute = require(AppChat.Flags.getFFlagAppChatRequestedRoute)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local GetRootedNavigationStore = require(AppChat.Stores.GetRootedNavigationStore)
local DomLocators = require(AppChat.Utils.DomLocators)

local function getEnumScreens() -- line: 63
	-- upvalues: AppChat (copy)
	return require(AppChat.EnumScreens)
end

return function(t1: {[any]: any}) -- line: 75
	-- upvalues: useDispatch (copy), useContext (copy), ParentContainerContext (copy), useState (copy), useExternalNavigationByScreen (copy), useMemo (copy), Signal (copy), RobloxEventReceiver (copy), NotificationService (copy), React (copy), Responsive (copy), FIntAppChatWideBreakpointMinWidth (copy), FIntAppChatWideBreakpointMinHeight (copy), FFlagAppChatInExpSelectChatMembersMobileHeight (copy), useAppChatIsWideMode (copy), getFFlagAppChatRequestedRoute (copy), getFFlagAppChatEnableRootedNavigation (copy), AppChat (copy), useRef (copy), useSignalState (copy), GetRootedNavigationStore (copy), useEffect (copy), PartyPageCarouselExperimentation (copy), SetFormFactor (copy), FormFactor (copy), useParentContainerExtents (copy), useCallback (copy), v41 (copy), AppChatEntryPoint (copy), LocalPlayer (copy), ChatPlacementContext (copy), Loading (copy), IconSize (copy), IconButton (copy), IconName (copy), ButtonSize (copy), ButtonVariant (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatEventReceiver (copy), ChatExternalEventReceiver (copy), Container (copy), FFlagSquadAppChatRTNFix (copy), SquadAppChatEventReceiver (copy)
	local v54 = useDispatch()
	local hideParentContainer = useContext(ParentContainerContext).hideParentContainer
	local v56, v57 = useState(0)
	local v58, v59 = useExternalNavigationByScreen()
	local v60 = useMemo(function() -- line: 80
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v61 = useMemo(function() -- line: 84
		-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
		return RobloxEventReceiver.new(NotificationService)
	end, {})
	local v62 = React.useRef(nil)
	local v63 = Responsive.useOrientation()
	local v64 = Responsive.useResponsive({{
		Key = "wide",
		minWidth = FIntAppChatWideBreakpointMinWidth,
		minHeight = FIntAppChatWideBreakpointMinHeight
	}}) == "wide"
	local v65 = not FFlagAppChatInExpSelectChatMembersMobileHeight or useAppChatIsWideMode(true)

	if not FFlagAppChatInExpSelectChatMembersMobileHeight and (v63 == Responsive.Keys.Portrait or not v64) then
		v65 = false
	end

	local v66 = getFFlagAppChatRequestedRoute()
	local v67 = getFFlagAppChatEnableRootedNavigation()
	local v68 = v67 and (t1.requestedRoute ~= nil and (t1.requestedRoute.screen == require(AppChat.EnumScreens).ChatDetails and (t1.requestedRoute.params ~= nil and t1.requestedRoute.params.rooted == true)))
	local v69 = useRef(false)

	if v68 then
		v69.current = true
	end

	local v70 = not v69.current and v65
	local v71 = false

	if v67 then
		v71 = useSignalState(GetRootedNavigationStore(false).getIsNavigationPending)
	end

	useEffect(function() -- line: 127
		-- upvalues: PartyPageCarouselExperimentation (copy), v70 (copy), v54 (copy), SetFormFactor (copy), FormFactor (copy)
		if PartyPageCarouselExperimentation.getAppChatFormFactorEnabled() then
			if v70 then
				v54(SetFormFactor(FormFactor.Enums.FormFactor.WIDE))

				return
			end

			v54(SetFormFactor(FormFactor.Enums.FormFactor.COMPACT))
		end
	end, {
		v70,
		v54
	})

	local v72, v73 = useParentContainerExtents()
	local v74 = v63 == Responsive.DefaultKey
	local v75, v76 = useState(v74)
	local v77 = useRef(os.clock())
	local v78 = useCallback(function() -- line: 143
		-- upvalues: t1 (copy), hideParentContainer (copy)
		t1.hideAppChat()
		hideParentContainer()
	end, {
		hideParentContainer,
		t1.hideAppChat
	})

	useEffect(function() -- line: 148
		-- upvalues: v74 (copy), v77 (copy), v41 (copy), v76 (copy)
		if not v74 then
			local v80 = os.clock() - v77.current
			local v81 = v41 / 1000

			if v80 < v81 then
				delay(v81 - v80, function() -- line: 154
					-- upvalues: v76 (copy)
					v76(false)
				end)

				return
			end

			v76(false)
		end
	end, {
		v74,
		v76
	})

	local v79 = React.createElement(AppChatEntryPoint, {
		isVisible = true,
		setActiveConversationId = v57,
		localUserId = if not LocalPlayer then nil else LocalPlayer.UserId,
		chatPlacement = ChatPlacementContext.Enum.InExperienceDefault,
		initialConversationId = t1.initialConversationId,
		setInitialConversationId = t1.setInitialConversationId,
		requestedRoute = if not v66 then nil else t1.requestedRoute,
		clearRequestedRoute = if not v66 then nil else t1.clearRequestedRoute,
		wideMode = v70,
		navigateToRootStack = v78,
		updateExternalNavigationForScreen = v59
	})

	return React.createElement(React.Fragment, {}, {
		AppChatWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = v72:map(function(vector2: Vector2) -- line: 181
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			Position = v73:map(function(vector2: Vector2) -- line: 184
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			ref = v62
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			containerRef = React.createElement(Responsive.ContainerRef.Provider, {
				value = v62
			}, {
				AppChatContent = if not v75 then if not v67 then v79 else React.createElement("Frame", {
					Name = "AppChatContent",
					[React.Tag] = "data-testid=app-chat-content",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Visible = not v71
				}, {
					AppChatEntryPoint = v79
				}) else if not v71 then React.createElement(Loading, {
					size = IconSize.Large,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				}) else nil,
				LoadingOverlay = if not v71 then nil else React.createElement("Frame", {
					Name = "AppChatLoadingOverlay",
					[React.Tag] = "data-testid=app-chat-loading-overlay",
					Active = true,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 2
				}, {
					Spinner = React.createElement(Loading, {
						size = IconSize.Large,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					}),
					BackButton = React.createElement(IconButton, {
						ZIndex = 3,
						icon = IconName.ChevronLargeLeft,
						size = ButtonSize.XSmall,
						variant = ButtonVariant.Utility,
						AnchorPoint = Vector2.new(0, 0),
						Position = UDim2.fromOffset(12, 12),
						onActivated = v78,
						testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.appChatLoadingOverlayBackButton()
					})
				})
			})
		}),
		ChatEventReceiver = React.createElement(ChatEventReceiver, {
			robloxEventReceiver = v61,
			rnBypassActionSignal = v60,
			activeConversationId = tostring(v56)
		}),
		ChatExternalEventReceiver = React.createElement(ChatExternalEventReceiver, {
			robloxEventReceiver = v61,
			localUserId = if not LocalPlayer then nil else LocalPlayer.UserId
		}),
		ExternalNavigationHandler = React.createElement(Container, {
			navigationByScreen = v58
		}),
		SquadAppChatEventReceiver = if not FFlagSquadAppChatRTNFix then nil else React.createElement(SquadAppChatEventReceiver)
	})
end
