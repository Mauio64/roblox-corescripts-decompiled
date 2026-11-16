local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Navigation")
local Drawer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Drawer")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RoactUtils")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SignalsReact")
local StreamNotifications = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/StreamNotifications")
local sendCoachmarkImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Analytics/sendCoachmarkImpression")
local fFlagPromptsCoachmarkImpressionOnShow = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagPromptsCoachmarkImpressionOnShow
local defineFastFlag = game:DefineFastFlag("LuaAppUseNavFocusInSduiCoachmark", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppCoachmarkImpression", false)
local defineFastFlag3 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenFlyoutOpen", false)

local defineFastFlag4 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenCentralOverlayOpen", false)

local defineFastFlag5 = game:DefineFastFlag("LuaAppHideSduiCoachmarkWhenNotificationStreamOpen", false)
local fFlagEnableOnScreenAPIIntegration = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagEnableOnScreenAPIIntegration

local useIsRouteOnScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/RobloxAppNavigation").useIsRouteOnScreen

local coachmark = Foundation.Coachmark
local useNavigationFocus = Navigation.useNavigationFocus
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useSignalState = SignalsReact.useSignalState
local streamNotificationStore = StreamNotifications.StreamNotificationStore

local CollectionService = game:GetService("CollectionService")

local function SduiCoachmark(props)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v5

	if defineFastFlag and fFlagEnableOnScreenAPIIntegration then
		v5 = useIsRouteOnScreen()
	elseif defineFastFlag then
		v5 = useNavigationFocus()
	end

	local v6 = if defineFastFlag3 then useDrawerVisible() else false
	local v7

	if defineFastFlag4 then
		v7 = useSelector(function(p2): boolean
			return p2.CentralOverlay.OverlayType ~= nil
		end)
	end

	local v8

	if defineFastFlag5 then
		v8 = useSignalState(streamNotificationStore.getStreamPresented)
	end

	React.useEffect(function()
		local function onTagAdded(guiObject)
			if not guiObject:IsA("GuiObject") then
				return
			end

			ref.current = guiObject
			setState2(true)
		end

		local function onTagRemoved(p2)
			ref.current = nil
			setState2(false)
		end

		local tagged = CollectionService:GetTagged(props.collectionServiceAnchorTag)

		for k, guiObject in tagged do
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

	local v9 = React.useCallback(function()
		setState(true)

		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })

	if defineFastFlag2 or fFlagPromptsCoachmarkImpressionOnShow then
		local ref2 = React.useRef(false)
		local v10 = state2
			and not state
			and ((not defineFastFlag or v5) and true or false)
			and not (defineFastFlag3 and v6)
			and not (defineFastFlag4 and v7 or defineFastFlag5 and v8)
		local useEffect = React.useEffect
		local function fn()
			if not v10 or ref2.current then
				return
			end

			if fFlagPromptsCoachmarkImpressionOnShow and props.onShown then
				props.onShown()
			end

			if defineFastFlag2 then
				local media = props.media
				local v11 = media ~= nil

				if typeof(media) == "table" and next(media) == nil then
					v11 = false
				end

				sendCoachmarkImpression(props.collectionServiceAnchorTag, v11)
			end

			ref2.current = true
		end

		local collectionServiceAnchorTag = props.collectionServiceAnchorTag
		local media = props.media
		local v12 = if fFlagPromptsCoachmarkImpressionOnShow then props.onShown else nil
		useEffect(fn, { v10, collectionServiceAnchorTag, media, v12 })

		if not v10 then
			return nil
		end
	elseif
		not state2
		or state
		or defineFastFlag and not v5
		or defineFastFlag3 and v6
		or defineFastFlag4 and v7
		or defineFastFlag5 and v8
	then
		return nil
	end

	return React.createElement(coachmark, {
		title = props.title,
		text = props.body,
		isOpen = defineFastFlag and true or state2 and not state,
		side = props.side,
		align = props.align,
		anchorRef = ref,
		onClose = v9,
		actions = props.actions,
		media = props.media,
		testId = props.testId
	})
end

return React.memo(SduiCoachmark)
