local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppCommonLib = require(parent.AppCommonLib)
local FormFactor = require(parent.FormFactor)
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local Responsive = require(parent.Responsive)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Loading = Foundation.Loading
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

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
local Components = require(parent.SquadsCore.Components)
local SquadAppChatEventReceiver = Components.SquadAppChatEventReceiver
local useMemo = React.useMemo
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback
local useContext = React.useContext
local useRef = React.useRef

local defineFastInt = game:DefineFastInt("AppChatInExperienceMountMinLoadingTimeMs", 0)

local FFlagAppChatInExpSelectChatMembersMobileHeight = require(AppChat.Flags.FFlagAppChatInExpSelectChatMembersMobileHeight)
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FIntAppChatWideBreakpointMinHeight = require(AppChat.Flags.FIntAppChatWideBreakpointMinHeight)
local FIntAppChatWideBreakpointMinWidth = require(AppChat.Flags.FIntAppChatWideBreakpointMinWidth)
local SocialExperiments = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments.PartyPageCarouselExperimentation
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local GetRootedNavigationStore = require(AppChat.Stores.GetRootedNavigationStore)
local DomLocators = require(AppChat.Utils.DomLocators)

local function getEnumScreens() -- 1 equivalent call inferred from this helper
	return require(AppChat.EnumScreens)
end

return function(props)
	local v = useDispatch()
	local hideParentContainer = useContext(ParentContainerContext).hideParentContainer
	local state, setState = useState(0)
	local navigationByScreen, updateExternalNavigationForScreen = useExternalNavigationByScreen()
	local rnBypassActionSignal = useMemo(function()
		return Signal.new()
	end, {})

	local robloxEventReceiver = useMemo(function()
		return RobloxEventReceiver.new(NotificationService)
	end, {})

	local ref = React.useRef(nil)

	local v2 = Responsive.useOrientation()
	local v3 = Responsive.useResponsive({
		{
			Key = "wide",
			minWidth = FIntAppChatWideBreakpointMinWidth,
			minHeight = FIntAppChatWideBreakpointMinHeight
		}
	}) == "wide"

	local wideMode = not FFlagAppChatInExpSelectChatMembersMobileHeight or useAppChatIsWideMode(true)

	if not FFlagAppChatInExpSelectChatMembersMobileHeight and (v2 == Responsive.Keys.Portrait or not v3) then
		wideMode = false
	end

	local v4

	if props.requestedRoute == nil then
		v4 = false
	elseif props.requestedRoute.screen == getEnumScreens().ChatDetails and props.requestedRoute.params ~= nil then -- inferred equivalent call
		v4 = props.requestedRoute.params.rooted == true
	else
		v4 = false
	end

	local v5 = useRef(false)

	if v4 then
		v5.current = true
	end

	if v5.current then
		wideMode = false
	end

	local v6 = useSignalState(GetRootedNavigationStore(false).getIsNavigationPending)

	useEffect(function()
		if PartyPageCarouselExperimentation.getAppChatFormFactorEnabled() then
			if wideMode then
				v(SetFormFactor(FormFactor.Enums.FormFactor.WIDE))
			else
				v(SetFormFactor(FormFactor.Enums.FormFactor.COMPACT))
			end
		end
	end, { wideMode, v })

	local v7, v8 = useParentContainerExtents()

	local v9 = v2 == Responsive.DefaultKey
	local state2, setState2 = useState(v9)
	local v10 = useRef(os.clock())

	local v11 = useCallback(function()
		props.hideAppChat()
		hideParentContainer()
	end, { hideParentContainer, props.hideAppChat })

	useEffect(function()
		if not v9 then
			local v12 = os.clock() - v10.current
			local v13 = defineFastInt / 1000

			if v12 < v13 then
				delay(v13 - v12, function()
					setState2(false)
				end)
			else
				setState2(false)
			end
		end
	end, { v9, setState2 })

	local createElement = React.createElement
	local localUserId

	if LocalPlayer then
		localUserId = LocalPlayer.UserId
	end

	local element = createElement(AppChatEntryPoint, {
		setActiveConversationId = setState,
		localUserId = localUserId,
		chatPlacement = ChatPlacementContext.Enum.InExperienceDefault,
		isVisible = true,
		initialConversationId = props.initialConversationId,
		setInitialConversationId = props.setInitialConversationId,
		requestedRoute = props.requestedRoute,
		clearRequestedRoute = props.clearRequestedRoute,
		wideMode = wideMode,
		navigateToRootStack = v11,
		updateExternalNavigationForScreen = updateExternalNavigationForScreen
	})

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local createElement3 = React.createElement
	local v12 = {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Size = v7:map(function(vector2: Vector2)
			return UDim2.fromOffset(vector2.X, vector2.Y)
		end),
		Position = v8:map(function(vector2: Vector2)
			return UDim2.fromOffset(vector2.X, vector2.Y)
		end),
		ref = ref
	}

	local v13 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		containerRef = 0
	}

	local createElement4 = React.createElement
	local provider = Responsive.ContainerRef.Provider
	local appChatContent

	if state2 then
		if not v6 then
			appChatContent = React.createElement(Loading, {
				size = IconSize.Large,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		end
	else
		appChatContent = React.createElement("Frame", {
			Name = "AppChatContent",
			[React.Tag] = "data-testid=app-chat-content",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = not v6
		}, { AppChatEntryPoint = element })
	end

	local loadingOverlay

	if v6 then
		local createElement5 = React.createElement
		local v14 = {
			Name = "AppChatLoadingOverlay",
			[React.Tag] = "data-testid=app-chat-loading-overlay",
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2
		}

		local v15 = {
			Spinner = React.createElement(Loading, {
				size = IconSize.Large,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}),
			BackButton = 0
		}

		local createElement6 = React.createElement
		local v16 = {
			icon = IconName.ChevronLargeLeft,
			size = ButtonSize.XSmall,
			variant = ButtonVariant.Utility,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromOffset(12, 12),
			ZIndex = 3,
			onActivated = v11,
			testId = 0
		}
		local testId

		if FFlagDebugAppChatEnableDomLocators then
			testId = DomLocators.appChatLoadingOverlayBackButton()
		end

		v16.testId = testId
		v15.BackButton = createElement6(IconButton, v16)
		loadingOverlay = createElement5("Frame", v14, v15)
	end

	v13.containerRef = createElement4(provider, { value = ref }, {
		AppChatContent = appChatContent,
		LoadingOverlay = loadingOverlay
	})
	local children = {
		AppChatWindow = createElement3("Frame", v12, v13),
		ChatEventReceiver = React.createElement(ChatEventReceiver, {
			robloxEventReceiver = robloxEventReceiver,
			rnBypassActionSignal = rnBypassActionSignal,
			activeConversationId = tostring(state)
		}),
		ChatExternalEventReceiver = 0,
		ExternalNavigationHandler = 0,
		SquadAppChatEventReceiver = 0
	}

	local createElement5 = React.createElement
	local localUserId2

	if LocalPlayer then
		localUserId2 = LocalPlayer.UserId
	end

	children.ChatExternalEventReceiver = createElement5(ChatExternalEventReceiver, {
		robloxEventReceiver = robloxEventReceiver,
		localUserId = localUserId2
	})

	children.ExternalNavigationHandler = React.createElement(Container, {
		navigationByScreen = navigationByScreen
	})
	local squadAppChatEventReceiver

	if FFlagSquadAppChatRTNFix then
		squadAppChatEventReceiver = React.createElement(SquadAppChatEventReceiver)
	end

	children.SquadAppChatEventReceiver = squadAppChatEventReceiver
	return createElement2(fragment, {}, children)
end
