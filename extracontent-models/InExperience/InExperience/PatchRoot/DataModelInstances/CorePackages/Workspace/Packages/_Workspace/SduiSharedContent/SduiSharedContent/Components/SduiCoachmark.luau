local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local Drawer = require(parent.Drawer)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact = require(parent.SignalsReact)
local StreamNotifications = require(parent.StreamNotifications)
local sendCoachmarkImpression = require(SduiSharedContent.Analytics.sendCoachmarkImpression)
local SharedFlags = require(parent.SharedFlags)
local FFlagPromptsCoachmarkImpressionOnShow = SharedFlags.FFlagPromptsCoachmarkImpressionOnShow
local defineFastFlag = game:DefineFastFlag("LuaAppUseNavFocusInSduiCoachmark", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppCoachmarkImpression", false)
local defineFastFlag3 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenFlyoutOpen", false)

local defineFastFlag4 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenCentralOverlayOpen", false)

local defineFastFlag5 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenNotificationStreamOpen", false)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableOnScreenAPIIntegration = SharedFlags2.FFlagEnableOnScreenAPIIntegration

local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useIsRouteOnScreen = RobloxAppNavigation.useIsRouteOnScreen

local Coachmark = Foundation.Coachmark
local useNavigationFocus = Navigation.useNavigationFocus
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = SignalsReact.useSignalState
local StreamNotificationStore = StreamNotifications.StreamNotificationStore

local CollectionService = game:GetService("CollectionService")

local function SduiCoachmark(props)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v

	if defineFastFlag and FFlagEnableOnScreenAPIIntegration then
		v = useIsRouteOnScreen()
	elseif defineFastFlag then
		v = useNavigationFocus()
	end

	local v2

	if defineFastFlag3 then
		v2 = useDrawerVisible()
	else
		v2 = false
	end

	local v3

	if defineFastFlag4 then
		v3 = useSelector(function(p): boolean
			return p.CentralOverlay.OverlayType ~= nil
		end)
	end

	local v4

	if defineFastFlag5 then
		v4 = useSignalState(StreamNotificationStore.getStreamPresented)
	end

	React.useEffect(function()
		local function onTagAdded(guiObject)
			if not guiObject:IsA("GuiObject") then
				return
			end

			ref.current = guiObject
			setState2(true)
		end

		local function onTagRemoved(_)
			ref.current = nil
			setState2(false)
		end

		local tagged = CollectionService:GetTagged(props.collectionServiceAnchorTag)

		for _, guiObject in tagged do
			if guiObject:IsA("GuiObject") then
				if not guiObject:IsA("GuiObject") then
					break
				end

				ref.current = guiObject
				setState2(true)
				break
			end
		end

		local connection = CollectionService:GetInstanceAddedSignal(props.collectionServiceAnchorTag):Connect(onTagAdded)
		local connection2 = CollectionService:GetInstanceRemovedSignal(props.collectionServiceAnchorTag):Connect(onTagRemoved)

		return function()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { props.collectionServiceAnchorTag })

	local onClose = React.useCallback(function()
		setState(true)

		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })

	if defineFastFlag2 or FFlagPromptsCoachmarkImpressionOnShow then
		local ref2 = React.useRef(false)
		local v5 = state2
			and not state
			and ((not defineFastFlag or v) and true or false)
			and not (defineFastFlag3 and v2)
			and not (defineFastFlag4 and v3 or defineFastFlag5 and v4)
		local useEffect = React.useEffect
		local function fn()
			if not v5 or ref2.current then
				return
			end

			if FFlagPromptsCoachmarkImpressionOnShow and props.onShown then
				props.onShown()
			end

			if defineFastFlag2 then
				local media = props.media
				local v6 = media ~= nil

				if typeof(media) == "table" and next(media) == nil then
					v6 = false
				end

				sendCoachmarkImpression(props.collectionServiceAnchorTag, v6)
			end

			ref2.current = true
		end

		local collectionServiceAnchorTag = props.collectionServiceAnchorTag
		local media = props.media
		local v6

		if FFlagPromptsCoachmarkImpressionOnShow then
			v6 = props.onShown
		end

		useEffect(fn, { v5, collectionServiceAnchorTag, media, v6 })

		if not v5 then
			return nil
		end
	elseif
		not state2
		or state
		or defineFastFlag and not v
		or defineFastFlag3 and v2
		or defineFastFlag4 and v3
		or defineFastFlag5 and v4
	then
		return nil
	end

	return React.createElement(Coachmark, {
		title = props.title,
		text = props.body,
		isOpen = defineFastFlag and true or state2 and not state,
		side = props.side,
		align = props.align,
		anchorRef = ref,
		onClose = onClose,
		actions = props.actions,
		media = props.media,
		testId = props.testId
	})
end

return React.memo(SduiCoachmark)
