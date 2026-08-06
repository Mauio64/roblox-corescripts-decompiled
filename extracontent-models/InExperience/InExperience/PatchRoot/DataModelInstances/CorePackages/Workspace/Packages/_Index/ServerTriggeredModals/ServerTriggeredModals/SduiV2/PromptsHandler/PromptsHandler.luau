local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local React = require(ServerTriggeredModalsParent.React)
local AppNavBar = require(ServerTriggeredModalsParent.AppNavBar)
local Foundation = require(ServerTriggeredModalsParent.Foundation)
local CentralOverlay = require(ServerTriggeredModalsParent.CentralOverlay)
local RobloxAppEnums = require(ServerTriggeredModalsParent.RobloxAppEnums)
local SignalsReact = require(ServerTriggeredModalsParent.SignalsReact)
local SduiSharedUtilities = require(ServerTriggeredModalsParent.SduiSharedUtilities)
local SharedFlags = require(ServerTriggeredModalsParent.SharedFlags)
local useDispatch = require(ServerTriggeredModalsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useStore = require(ServerTriggeredModalsParent.RoactUtils).Hooks.RoactRodux.useStore
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local View = Foundation.View
local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local sendModalImpressionEvent = require(ServerTriggeredModalsParent.ServerTriggeredModalImpressions).sendModalImpressionEvent
local fetchPrompts = require(ServerTriggeredModals.SduiV2.fetchPrompts)

require(ServerTriggeredModals.SduiV2.PromptsEntryPoint)

local PromptStyle = require(ServerTriggeredModals.SduiV2.PromptStyle)
local usePromptEntries = require(ServerTriggeredModals.SduiV2.usePromptEntries)
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local getEntryPointSurfaceConfig = require(script.Parent.getEntryPointSurfaceConfig)
local CoachmarkRenderer = require(script.Parent.CoachmarkRenderer)
local SurfaceBanner = require(script.Parent.SurfaceBanner)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local FFlagPromptsImpressionUsesTitle = SharedFlags.FFlagPromptsImpressionUsesTitle
local FFlagPromptsHandlerCoachmarkEnabled = SharedFlags.FFlagPromptsHandlerCoachmarkEnabled
local FFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local FFlagSduiSystemBannerComponent = SharedFlags.FFlagSduiSystemBannerComponent
local FFlagSduiSurfaceBannerScrollAwaySticky = SharedFlags.FFlagSduiSurfaceBannerScrollAwaySticky
local FFlagSduiSurfaceBannerAlwaysMounted = SharedFlags.FFlagSduiSurfaceBannerAlwaysMounted
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local FFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix

local function PromptsHandler(t1: {[any]: any}) -- line: 85
	-- upvalues: useDispatch (copy), FFlagSduiDismissPromptAction (copy), useStore (copy), useModalSignalStore (copy), FFlagEdpGameLeavePromptsHandlerEnabled (copy), React (copy), getEntryPointSurfaceConfig (copy), SignalsReact (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy), fetchPrompts (copy), usePromptEntries (copy), PromptStyle (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagPromptsImpressionUsesTitle (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy), FFlagPromptsHandlerCoachmarkEnabled (copy), FFlagSduiSurfaceBannerScrollAwaySticky (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagSduiSurfaceBannerAlwaysMounted (copy), FFlagSduiSystemBannerComponent (copy), SurfaceBanner (copy), SduiFeatureEntryPoint (copy), FFlagHomepagePromptsPaddingFix (copy), View (copy), CoachmarkRenderer (copy)
	local entryPoint = t1.entryPoint
	local promptStyle = t1.promptStyle
	local v42 = useDispatch()
	local v43 = if not FFlagSduiDismissPromptAction then nil else useStore()
	local v44 = useModalSignalStore()
	local v45 = if not FFlagEdpGameLeavePromptsHandlerEnabled or t1.clientAttributes == nil then nil else t1.clientAttributes.universeId
	local v46 = React.useMemo(function() -- line: 95
		-- upvalues: FFlagEdpGameLeavePromptsHandlerEnabled (copy), getEntryPointSurfaceConfig (copy), entryPoint (copy), v45 (copy)
		if FFlagEdpGameLeavePromptsHandlerEnabled then
			return getEntryPointSurfaceConfig(entryPoint, v45)
		end

		return getEntryPointSurfaceConfig(entryPoint)
	end, if not FFlagEdpGameLeavePromptsHandlerEnabled then { entryPoint } else {
		entryPoint,
		v45
	})
	local v47 = SignalsReact.useSignalState(v44.getHasShownGetter(entryPoint))
	local v48 = SignalsReact.useSignalState(v44.getMetadataGetter(entryPoint))
	local v49 = React.useMemo(function() -- line: 112
		-- upvalues: entryPoint (copy), v46 (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy), FFlagEdpGameLeavePromptsHandlerEnabled (copy), t1 (copy)
		return {
			clearOnEmptyResponse = true,
			entryPoint = entryPoint,
			surfaceKey = v46.surfaceKey,
			configKey = v46.configKey,
			allowNoConfigsBuilt = not not FFlagSduiAllowNoConfigsBuilt or nil,
			loadTimer = SduiLoadTimer.createLoadTimer(v46.configKey),
			clientAttributes = if not FFlagEdpGameLeavePromptsHandlerEnabled then nil else t1.clientAttributes
		}
	end, if not FFlagEdpGameLeavePromptsHandlerEnabled then {
		entryPoint,
		v46
	} else {
		entryPoint,
		v46,
		t1.clientAttributes
	})

	React.useEffect(function() -- line: 128
		-- upvalues: fetchPrompts (copy), v49 (copy)
		fetchPrompts(v49)
	end, { v49 })

	local v50 = usePromptEntries(v46.configKey, PromptStyle.Modal)
	local v51 = v50[1]
	local v52 = if not FFlagSduiDismissPromptAction then nil else React.useRef(nil)
	local v53 = if not FFlagSduiDismissPromptAction then nil else React.useRef(nil)

	React.useEffect(function() -- line: 151
		-- upvalues: v47 (copy), v48 (copy), v51 (copy), v44 (copy), entryPoint (copy), v42 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v46 (copy), FFlagPromptsImpressionUsesTitle (copy), FFlagSduiDismissPromptAction (copy), v52 (copy), v53 (copy)
		if v47 then
			return
		end

		if v48 then
			return
		end

		if v51 == nil or v51.config == nil or v51.identifier == nil or v51.robloxComponentType == nil or v51.title == nil then
			return
		end

		v44.setHasShown(entryPoint, true)
		v42(SetCentralOverlay(CentralOverlayType.SduiPromptModal, {
			configKey = v46.configKey,
			appPage = v46.appPage,
			modalId = v51.identifier,
			modalType = if not FFlagPromptsImpressionUsesTitle then v51.robloxComponentType else v51.title
		}))

		if FFlagSduiDismissPromptAction then
			v52.current = v51.title
			v53.current = v51.identifier
		end
	end, {
		v47,
		v48,
		v42,
		v44,
		v51,
		v46,
		entryPoint
	})

	if FFlagSduiDismissPromptAction then
		React.useEffect(function() -- line: 202
			-- upvalues: v52 (copy), v50 (copy), v53 (copy), v43 (copy), CentralOverlayType (copy), v42 (copy), SetCentralOverlay (copy)
			local current = v52.current

			if current == nil then
				return
			end

			for _, v75 in v50 do
				if current == v75.title then
					return
				end
			end

			local current2 = v53.current

			v52.current = nil
			v53.current = nil

			local CentralOverlay2 = v43:getState().CentralOverlay

			if CentralOverlay2 ~= nil and CentralOverlay2.OverlayType == CentralOverlayType.SduiPromptModal and CentralOverlay2.Arguments ~= nil and current2 == CentralOverlay2.Arguments.modalId then
				v42(SetCentralOverlay())
			end
		end, {
			v50,
			v42,
			v43
		})
	end

	local v54 = promptStyle == PromptStyle.SurfaceBanner
	local v55 = usePromptEntries(v46.configKey, PromptStyle.SurfaceBanner)
	local v56 = if not v54 then nil else v55[1]
	local v57 = v56 and v56.identifier or nil
	local v58 = if not v56 then nil else if not FFlagPromptsImpressionUsesTitle then v56.robloxComponentType else v56.title
	local v59 = promptStyle == PromptStyle.InlineBanner
	local v60 = usePromptEntries(v46.configKey, PromptStyle.InlineBanner)
	local v61 = if not v59 then nil else v60[1]
	local v62 = v61 and v61.identifier or nil
	local v63 = if not v61 then nil else if not FFlagPromptsImpressionUsesTitle then v61.robloxComponentType else v61.title

	React.useEffect(function() -- line: 251
		-- upvalues: v57 (copy), v58 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v57 and v58 then
			reportPromptImpression(v58, v57):catch(function() -- line: 253
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(v57, v58)
		end
	end, {
		v57,
		v58
	})
	React.useEffect(function() -- line: 260
		-- upvalues: v62 (copy), v63 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v62 and v63 then
			reportPromptImpression(v63, v62):catch(function() -- line: 262
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(v62, v63)
		end
	end, {
		v62,
		v63
	})

	local v64 = false

	if FFlagPromptsHandlerCoachmarkEnabled then
		for _, v66 in (usePromptEntries(v46.configKey, PromptStyle.Coachmark)) do
			if v66.config and v66.identifier and v66.title then
				v64 = true

				break
			end
		end
	end

	local v67 = FFlagSduiSurfaceBannerScrollAwaySticky and (FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled())
	local v68 = v56 ~= nil or FFlagSduiSurfaceBannerAlwaysMounted
	local v69 = nil

	if v54 then
		v69 = if not FFlagSduiSystemBannerComponent or (not v68 or not v67) then if not FFlagSduiSystemBannerComponent or not v68 then t1.surfaceBannerContent else React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SurfaceBanner = if not v56 then nil else React.createElement(SduiFeatureEntryPoint, {
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				LayoutOrder = 1,
				configKey = v46.configKey,
				identifier = v56.identifier,
				appPage = v46.appPage
			}),
			ContentContainer = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIFlexItem = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				Content = t1.surfaceBannerContent
			})
		}) else React.createElement(SurfaceBanner, {
			identifier = if not v56 then nil else v56.identifier,
			configKey = v46.configKey,
			appPage = v46.appPage,
			surfaceBannerContent = t1.surfaceBannerContent
		})
	elseif v59 then
		v69 = if not v61 then t1.inlineBannerFallback else React.createElement(SduiFeatureEntryPoint, {
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			configKey = v46.configKey,
			identifier = v61.identifier,
			appPage = v46.appPage
		})
	end

	if FFlagHomepagePromptsPaddingFix and v59 then
		local v70 = v55[1] ~= nil

		if v69 ~= nil then
			local v71 = v70 and t1.topPadding ~= nil
			local v72 = t1.bottomPadding ~= nil

			v69 = React.createElement(View, {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				padding = {
					top = if not v71 then nil else UDim.new(0, t1.topPadding),
					bottom = if not v72 then nil else UDim.new(0, t1.bottomPadding)
				}
			}, {
				InlineBanner = v69
			})
		elseif v70 and t1.topPadding then
			v69 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, t1.topPadding)
			})
		end
	end

	if not FFlagPromptsHandlerCoachmarkEnabled or not v64 then
		return v69
	end

	return React.createElement(React.Fragment, nil, {
		Slot = v69,
		Coachmarks = React.createElement(CoachmarkRenderer, {
			surfaceConfig = v46,
			hasShownKey = entryPoint
		})
	})
end

return React.memo(PromptsHandler)
