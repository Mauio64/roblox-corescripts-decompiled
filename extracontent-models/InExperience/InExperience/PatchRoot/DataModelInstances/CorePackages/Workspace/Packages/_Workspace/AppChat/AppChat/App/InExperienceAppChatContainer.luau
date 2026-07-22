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
local Loading = Foundation.Loading
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
local v36 = game:DefineFastInt("AppChatInExperienceMountMinLoadingTimeMs", 0)
local FFlagAppChatInExpSelectChatMembersMobileHeight = require(AppChat.Flags.FFlagAppChatInExpSelectChatMembersMobileHeight)
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FIntAppChatWideBreakpointMinHeight = require(AppChat.Flags.FIntAppChatWideBreakpointMinHeight)
local FIntAppChatWideBreakpointMinWidth = require(AppChat.Flags.FIntAppChatWideBreakpointMinWidth)
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local getFFlagAppChatRequestedRoute = require(AppChat.Flags.getFFlagAppChatRequestedRoute)

return function(t1: {[any]: any}) -- line: 63
	-- upvalues: useDispatch (copy), useContext (copy), ParentContainerContext (copy), useState (copy), useExternalNavigationByScreen (copy), useMemo (copy), Signal (copy), RobloxEventReceiver (copy), NotificationService (copy), React (copy), Responsive (copy), FIntAppChatWideBreakpointMinWidth (copy), FIntAppChatWideBreakpointMinHeight (copy), FFlagAppChatInExpSelectChatMembersMobileHeight (copy), useAppChatIsWideMode (copy), getFFlagAppChatRequestedRoute (copy), getFFlagAppChatEnableRootedNavigation (copy), useRef (copy), useEffect (copy), PartyPageCarouselExperimentation (copy), SetFormFactor (copy), FormFactor (copy), useParentContainerExtents (copy), useCallback (copy), v36 (copy), Loading (copy), IconSize (copy), AppChatEntryPoint (copy), LocalPlayer (copy), ChatPlacementContext (copy), ChatEventReceiver (copy), ChatExternalEventReceiver (copy), Container (copy), FFlagSquadAppChatRTNFix (copy), SquadAppChatEventReceiver (copy)
	local v45 = useDispatch()
	local hideParentContainer = useContext(ParentContainerContext).hideParentContainer
	local v47, v48 = useState(0)
	local v49, v50 = useExternalNavigationByScreen()
	local v51 = useMemo(function() -- line: 68
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v52 = useMemo(function() -- line: 72
		-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
		return RobloxEventReceiver.new(NotificationService)
	end, {})
	local v53 = React.useRef(nil)
	local v54 = Responsive.useOrientation()
	local v55 = Responsive.useResponsive({{
		Key = "wide",
		minWidth = FIntAppChatWideBreakpointMinWidth,
		minHeight = FIntAppChatWideBreakpointMinHeight
	}}) == "wide"
	local v56 = not FFlagAppChatInExpSelectChatMembersMobileHeight or useAppChatIsWideMode(true)

	if not FFlagAppChatInExpSelectChatMembersMobileHeight and (v54 == Responsive.Keys.Portrait or not v55) then
		v56 = false
	end

	local v57 = getFFlagAppChatRequestedRoute()
	local v58 = getFFlagAppChatEnableRootedNavigation() and (t1.requestedRoute ~= nil and (t1.requestedRoute.params ~= nil and t1.requestedRoute.params.rooted == true))
	local v59 = useRef(false)

	if v58 then
		v59.current = true
	end

	local v60 = not v59.current and v56

	useEffect(function() -- line: 106
		-- upvalues: PartyPageCarouselExperimentation (copy), v60 (copy), v45 (copy), SetFormFactor (copy), FormFactor (copy)
		if PartyPageCarouselExperimentation.getAppChatFormFactorEnabled() then
			if v60 then
				v45(SetFormFactor(FormFactor.Enums.FormFactor.WIDE))

				return
			end

			v45(SetFormFactor(FormFactor.Enums.FormFactor.COMPACT))
		end
	end, {
		v60,
		v45
	})

	local v61, v62 = useParentContainerExtents()
	local v63 = v54 == Responsive.DefaultKey
	local v64, v65 = useState(v63)
	local v66 = useRef(os.clock())
	local v67 = useCallback(function() -- line: 122
		-- upvalues: t1 (copy), hideParentContainer (copy)
		t1.hideAppChat()
		hideParentContainer()
	end, {
		hideParentContainer,
		t1.hideAppChat
	})

	useEffect(function() -- line: 127
		-- upvalues: v63 (copy), v66 (copy), v36 (copy), v65 (copy)
		if not v63 then
			local v68 = os.clock() - v66.current
			local v69 = v36 / 1000

			if v68 < v69 then
				delay(v69 - v68, function() -- line: 133
					-- upvalues: v65 (copy)
					v65(false)
				end)

				return
			end

			v65(false)
		end
	end, {
		v63,
		v65
	})

	return React.createElement(React.Fragment, {}, {
		AppChatWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = v61:map(function(vector2: Vector2) -- line: 146
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			Position = v62:map(function(vector2: Vector2) -- line: 149
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			ref = v53
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			containerRef = React.createElement(Responsive.ContainerRef.Provider, {
				value = v53
			}, {
				AppChatEntryPoint = if not v64 then React.createElement(AppChatEntryPoint, {
					isVisible = true,
					setActiveConversationId = v48,
					localUserId = if not LocalPlayer then nil else LocalPlayer.UserId,
					chatPlacement = ChatPlacementContext.Enum.InExperienceDefault,
					initialConversationId = t1.initialConversationId,
					setInitialConversationId = t1.setInitialConversationId,
					requestedRoute = if not v57 then nil else t1.requestedRoute,
					clearRequestedRoute = if not v57 then nil else t1.clearRequestedRoute,
					wideMode = v60,
					navigateToRootStack = v67,
					updateExternalNavigationForScreen = v50
				}) else React.createElement(Loading, {
					size = IconSize.Large,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			})
		}),
		ChatEventReceiver = React.createElement(ChatEventReceiver, {
			robloxEventReceiver = v52,
			rnBypassActionSignal = v51,
			activeConversationId = tostring(v47)
		}),
		ChatExternalEventReceiver = React.createElement(ChatExternalEventReceiver, {
			robloxEventReceiver = v52,
			localUserId = if not LocalPlayer then nil else LocalPlayer.UserId
		}),
		ExternalNavigationHandler = React.createElement(Container, {
			navigationByScreen = v49
		}),
		SquadAppChatEventReceiver = if not FFlagSquadAppChatRTNFix then nil else React.createElement(SquadAppChatEventReceiver)
	})
end
