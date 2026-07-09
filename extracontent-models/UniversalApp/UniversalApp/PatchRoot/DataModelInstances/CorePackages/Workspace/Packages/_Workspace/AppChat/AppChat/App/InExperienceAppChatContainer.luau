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

return function(t1: {[any]: any}) -- line: 58
	-- upvalues: useDispatch (copy), useContext (copy), ParentContainerContext (copy), useState (copy), useExternalNavigationByScreen (copy), useMemo (copy), Signal (copy), RobloxEventReceiver (copy), NotificationService (copy), React (copy), Responsive (copy), FIntAppChatWideBreakpointMinWidth (copy), FIntAppChatWideBreakpointMinHeight (copy), FFlagAppChatInExpSelectChatMembersMobileHeight (copy), useAppChatIsWideMode (copy), useEffect (copy), PartyPageCarouselExperimentation (copy), SetFormFactor (copy), FormFactor (copy), useParentContainerExtents (copy), useRef (copy), useCallback (copy), v36 (copy), Loading (copy), IconSize (copy), AppChatEntryPoint (copy), LocalPlayer (copy), ChatPlacementContext (copy), ChatEventReceiver (copy), ChatExternalEventReceiver (copy), Container (copy), FFlagSquadAppChatRTNFix (copy), SquadAppChatEventReceiver (copy)
	local v43 = useDispatch()
	local hideParentContainer = useContext(ParentContainerContext).hideParentContainer
	local v45, v46 = useState(0)
	local v47, v48 = useExternalNavigationByScreen()
	local v49 = useMemo(function() -- line: 63
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v50 = useMemo(function() -- line: 67
		-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
		return RobloxEventReceiver.new(NotificationService)
	end, {})
	local v51 = React.useRef(nil)
	local v52 = Responsive.useOrientation()
	local v53 = Responsive.useResponsive({{
		Key = "wide",
		minWidth = FIntAppChatWideBreakpointMinWidth,
		minHeight = FIntAppChatWideBreakpointMinHeight
	}}) == "wide"
	local u54 = not FFlagAppChatInExpSelectChatMembersMobileHeight or useAppChatIsWideMode(true)

	if not FFlagAppChatInExpSelectChatMembersMobileHeight and (v52 == Responsive.Keys.Portrait or not v53) then
		u54 = false
	end

	useEffect(function() -- line: 90
		-- upvalues: PartyPageCarouselExperimentation (copy), u54 (ref), v43 (copy), SetFormFactor (copy), FormFactor (copy)
		if PartyPageCarouselExperimentation.getAppChatFormFactorEnabled() then
			if u54 then
				v43(SetFormFactor(FormFactor.Enums.FormFactor.WIDE))

				return
			end

			v43(SetFormFactor(FormFactor.Enums.FormFactor.COMPACT))
		end
	end, { u54 })

	local v55, v56 = useParentContainerExtents()
	local v57 = v52 == Responsive.DefaultKey
	local v58, v59 = useState(v57)
	local v60 = useRef(os.clock())
	local v61 = useCallback(function() -- line: 106
		-- upvalues: t1 (copy), hideParentContainer (copy)
		t1.hideAppChat()
		hideParentContainer()
	end, {
		hideParentContainer,
		t1.hideAppChat
	})

	useEffect(function() -- line: 111
		-- upvalues: v57 (copy), v60 (copy), v36 (copy), v59 (copy)
		if not v57 then
			local v62 = os.clock() - v60.current
			local v63 = v36 / 1000

			if v62 < v63 then
				delay(v63 - v62, function() -- line: 117
					-- upvalues: v59 (copy)
					v59(false)
				end)

				return
			end

			v59(false)
		end
	end, {
		v57,
		v59
	})

	return React.createElement(React.Fragment, {}, {
		AppChatWindow = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = v55:map(function(vector2: Vector2) -- line: 130
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			Position = v56:map(function(vector2: Vector2) -- line: 133
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			ref = v51
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			containerRef = React.createElement(Responsive.ContainerRef.Provider, {
				value = v51
			}, {
				AppChatEntryPoint = if not v58 then React.createElement(AppChatEntryPoint, {
					isVisible = true,
					setActiveConversationId = v46,
					localUserId = if not LocalPlayer then nil else LocalPlayer.UserId,
					chatPlacement = ChatPlacementContext.Enum.InExperienceDefault,
					initialConversationId = t1.initialConversationId,
					setInitialConversationId = t1.setInitialConversationId,
					wideMode = u54,
					navigateToRootStack = v61,
					updateExternalNavigationForScreen = v48
				}) else React.createElement(Loading, {
					size = IconSize.Large,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			})
		}),
		ChatEventReceiver = React.createElement(ChatEventReceiver, {
			robloxEventReceiver = v50,
			rnBypassActionSignal = v49,
			activeConversationId = tostring(v45)
		}),
		ChatExternalEventReceiver = React.createElement(ChatExternalEventReceiver, {
			robloxEventReceiver = v50,
			localUserId = if not LocalPlayer then nil else LocalPlayer.UserId
		}),
		ExternalNavigationHandler = React.createElement(Container, {
			navigationByScreen = v47
		}),
		SquadAppChatEventReceiver = if not FFlagSquadAppChatRTNFix then nil else React.createElement(SquadAppChatEventReceiver)
	})
end
