local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib")
local FormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FormFactor")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local iconSize = Foundation.Enums.IconSize
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local loading = Foundation.Loading
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local setFormFactor = FormFactor.Actions.SetFormFactor

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatEntryPoint")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/ChatEventReceiver")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Components/ChatExternalEventReceiver")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChatModal")
local useParentContainerExtents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/useParentContainerExtents")
local Container = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/Container")
local useExternalNavigationByScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useExternalNavigationByScreen")
local useAppChatIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppChatIsWideMode")

local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")

local localPlayer = Players.LocalPlayer
local robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver
local signal = AppCommonLib.Signal
local squadAppChatEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Components").SquadAppChatEventReceiver
local useMemo = React.useMemo
local useState = React.useState
local useEffect = React.useEffect
local useCallback = React.useCallback
local useContext = React.useContext
local useRef = React.useRef

local defineFastInt = game:DefineFastInt("AppChatInExperienceMountMinLoadingTimeMs", 0)

local FFlagAppChatInExpSelectChatMembersMobileHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatInExpSelectChatMembersMobileHeight")
local fFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FIntAppChatWideBreakpointMinHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatWideBreakpointMinHeight")
local FIntAppChatWideBreakpointMinWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatWideBreakpointMinWidth")
local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation
local getFFlagAppChatEnableRootedNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatEnableRootedNavigation")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local GetRootedNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetRootedNavigationStore")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local function getEnumScreens()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
end

return function(props)
	local v5 = useDispatch()
	local hideParentContainer = useContext(ParentContainerContext).hideParentContainer
	local state, setState = useState(0)
	local v6, v7 = useExternalNavigationByScreen()
	local v8 = useMemo(function()
		return signal.new()
	end, {})

	local v9 = useMemo(function()
		return robloxEventReceiver.new(NotificationService)
	end, {})

	local ref = React.useRef(nil)

	local v10 = Responsive.useOrientation()
	local v11 = Responsive.useResponsive({
		{ Key = "wide", minWidth = FIntAppChatWideBreakpointMinWidth, minHeight = FIntAppChatWideBreakpointMinHeight }
	}) == "wide"

	local v12 = not FFlagAppChatInExpSelectChatMembersMobileHeight or useAppChatIsWideMode(true)

	if not FFlagAppChatInExpSelectChatMembersMobileHeight and (v10 == Responsive.Keys.Portrait or not v11) then
		v12 = false
	end

	local v13 = getFFlagAppChatEnableRootedNavigation()
	local v14

	if v13 then
		if
			props.requestedRoute == nil
			or props.requestedRoute.screen ~= require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens").ChatDetails
			or props.requestedRoute.params == nil
		then
			v14 = false
		else
			v14 = props.requestedRoute.params.rooted == true
		end
	else
		v14 = v13
	end

	local v15 = useRef(false)

	if v14 then
		v15.current = true
	end

	if v15.current then
		v12 = false
	end

	local v16 = if v13 then useSignalState(GetRootedNavigationStore(false).getIsNavigationPending) else false

	useEffect(function()
		if partyPageCarouselExperimentation.getAppChatFormFactorEnabled() then
			if v12 then
				v5(setFormFactor(FormFactor.Enums.FormFactor.WIDE))
			else
				v5(setFormFactor(FormFactor.Enums.FormFactor.COMPACT))
			end
		end
	end, { v12, v5 })

	local v17, v18 = useParentContainerExtents()

	local v19 = v10 == Responsive.DefaultKey
	local state2, setState2 = useState(v19)
	local v20 = useRef(os.clock())

	local v21 = useCallback(function()
		props.hideAppChat()
		hideParentContainer()
	end, { hideParentContainer, props.hideAppChat })

	useEffect(function()
		if not v19 then
			local v22 = os.clock() - v20.current
			local v23 = defineFastInt / 1000

			if v22 < v23 then
				delay(v23 - v22, function()
					setState2(false)
				end)
			else
				setState2(false)
			end
		end
	end, { v19, setState2 })

	local createElement = React.createElement

	local v24 = if localPlayer then localPlayer.UserId else nil
	local v25 = createElement(module9, {
		setActiveConversationId = setState,
		localUserId = v24,
		chatPlacement = ChatPlacementContext.Enum.InExperienceDefault,
		isVisible = true,
		initialConversationId = props.initialConversationId,
		setInitialConversationId = props.setInitialConversationId,
		requestedRoute = props.requestedRoute,
		clearRequestedRoute = props.clearRequestedRoute,
		wideMode = v12,
		navigateToRootStack = v21,
		updateExternalNavigationForScreen = v7
	})

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local createElement3 = React.createElement
	local v28 = {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Size = v17:map(function(p2)
			return UDim2.fromOffset(p2.X, p2.Y)
		end),
		Position = v18:map(function(p2)
			return UDim2.fromOffset(p2.X, p2.Y)
		end),
		ref = ref
	}

	local v29 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		containerRef = 0
	}

	local createElement4 = React.createElement
	local provider = Responsive.ContainerRef.Provider

	if state2 then
		if v16 then
			v25 = nil
		else
			v25 = React.createElement(loading, {
				size = iconSize.Large,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		end
	elseif v13 then
		v25 = React.createElement("Frame", {
			Name = "AppChatContent",
			[React.Tag] = "data-testid=app-chat-content",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = not v16
		}, { AppChatEntryPoint = v25 })
	end

	local v32

	if v16 then
		local createElement5 = React.createElement
		local v34 = {
			Name = "AppChatLoadingOverlay",
			[React.Tag] = "data-testid=app-chat-loading-overlay",
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2
		}

		local v35 = {
			Spinner = React.createElement(loading, {
				size = iconSize.Large,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}),
			BackButton = 0
		}

		local createElement6 = React.createElement
		local v37 = {
			icon = iconName.ChevronLargeLeft,
			size = buttonSize.XSmall,
			variant = buttonVariant.Utility,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromOffset(12, 12),
			ZIndex = 3,
			onActivated = v21,
			testId = 0
		}

		local v38 = if FFlagDebugAppChatEnableDomLocators then DomLocators.appChatLoadingOverlayBackButton() else nil
		v37.testId = v38
		v35.BackButton = createElement6(iconButton, v37)
		v32 = createElement5("Frame", v34, v35)
	end

	v29.containerRef = createElement4(provider, { value = ref }, {
		AppChatContent = v25,
		LoadingOverlay = v32
	})
	local children = {
		AppChatWindow = createElement3("Frame", v28, v29),
		ChatEventReceiver = React.createElement(module10, {
			robloxEventReceiver = v9,
			rnBypassActionSignal = v8,
			activeConversationId = tostring(state)
		}),
		ChatExternalEventReceiver = 0,
		ExternalNavigationHandler = 0,
		SquadAppChatEventReceiver = 0
	}

	local createElement5 = React.createElement

	local v35 = if localPlayer then localPlayer.UserId else nil
	children.ChatExternalEventReceiver = createElement5(module11, {
		robloxEventReceiver = v9,
		localUserId = v35
	})

	children.ExternalNavigationHandler = React.createElement(Container, {
		navigationByScreen = v6
	})

	local v36 = if fFlagSquadAppChatRTNFix then React.createElement(squadAppChatEventReceiver) else nil
	children.SquadAppChatEventReceiver = v36
	return createElement2(fragment, {}, children)
end
