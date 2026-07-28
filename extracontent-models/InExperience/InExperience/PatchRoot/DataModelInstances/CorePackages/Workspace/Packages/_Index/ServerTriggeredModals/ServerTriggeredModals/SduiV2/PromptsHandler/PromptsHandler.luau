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
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local FFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix

local function PromptsHandler(t1: {[any]: any}) -- line: 84
	-- upvalues: useDispatch (copy), FFlagSduiDismissPromptAction (copy), useStore (copy), useModalSignalStore (copy), FFlagEdpGameLeavePromptsHandlerEnabled (copy), React (copy), getEntryPointSurfaceConfig (copy), SignalsReact (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy), fetchPrompts (copy), usePromptEntries (copy), PromptStyle (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagPromptsImpressionUsesTitle (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy), FFlagPromptsHandlerCoachmarkEnabled (copy), FFlagSduiSurfaceBannerScrollAwaySticky (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagSduiSystemBannerComponent (copy), SurfaceBanner (copy), SduiFeatureEntryPoint (copy), FFlagHomepagePromptsPaddingFix (copy), View (copy), CoachmarkRenderer (copy)
	local entryPoint = t1.entryPoint
	local promptStyle = t1.promptStyle
	local v41 = useDispatch()
	local v42 = if not FFlagSduiDismissPromptAction then nil else useStore()
	local v43 = useModalSignalStore()
	local v44 = if not FFlagEdpGameLeavePromptsHandlerEnabled or t1.clientAttributes == nil then nil else t1.clientAttributes.universeId
	local v45 = React.useMemo(function() -- line: 94
		-- upvalues: FFlagEdpGameLeavePromptsHandlerEnabled (copy), getEntryPointSurfaceConfig (copy), entryPoint (copy), v44 (copy)
		if FFlagEdpGameLeavePromptsHandlerEnabled then
			return getEntryPointSurfaceConfig(entryPoint, v44)
		end

		return getEntryPointSurfaceConfig(entryPoint)
	end, if not FFlagEdpGameLeavePromptsHandlerEnabled then { entryPoint } else {
		entryPoint,
		v44
	})
	local v46 = SignalsReact.useSignalState(v43.getHasShownGetter(entryPoint))
	local v47 = SignalsReact.useSignalState(v43.getMetadataGetter(entryPoint))
	local v48 = React.useMemo(function() -- line: 111
		-- upvalues: entryPoint (copy), v45 (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy), FFlagEdpGameLeavePromptsHandlerEnabled (copy), t1 (copy)
		return {
			clearOnEmptyResponse = true,
			entryPoint = entryPoint,
			surfaceKey = v45.surfaceKey,
			configKey = v45.configKey,
			allowNoConfigsBuilt = not not FFlagSduiAllowNoConfigsBuilt or nil,
			loadTimer = SduiLoadTimer.createLoadTimer(v45.configKey),
			clientAttributes = if not FFlagEdpGameLeavePromptsHandlerEnabled then nil else t1.clientAttributes
		}
	end, if not FFlagEdpGameLeavePromptsHandlerEnabled then {
		entryPoint,
		v45
	} else {
		entryPoint,
		v45,
		t1.clientAttributes
	})

	React.useEffect(function() -- line: 127
		-- upvalues: fetchPrompts (copy), v48 (copy)
		fetchPrompts(v48)
	end, { v48 })

	local v49 = usePromptEntries(v45.configKey, PromptStyle.Modal)
	local v50 = v49[1]
	local v51 = if not FFlagSduiDismissPromptAction then nil else React.useRef(nil)
	local v52 = if not FFlagSduiDismissPromptAction then nil else React.useRef(nil)

	React.useEffect(function() -- line: 150
		-- upvalues: v46 (copy), v47 (copy), v50 (copy), v43 (copy), entryPoint (copy), v41 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v45 (copy), FFlagPromptsImpressionUsesTitle (copy), FFlagSduiDismissPromptAction (copy), v51 (copy), v52 (copy)
		if v46 then
			return
		end

		if v47 then
			return
		end

		if v50 == nil or v50.config == nil or v50.identifier == nil or v50.robloxComponentType == nil or v50.title == nil then
			return
		end

		v43.setHasShown(entryPoint, true)
		v41(SetCentralOverlay(CentralOverlayType.SduiPromptModal, {
			configKey = v45.configKey,
			appPage = v45.appPage,
			modalId = v50.identifier,
			modalType = if not FFlagPromptsImpressionUsesTitle then v50.robloxComponentType else v50.title
		}))

		if FFlagSduiDismissPromptAction then
			v51.current = v50.title
			v52.current = v50.identifier
		end
	end, {
		v46,
		v47,
		v41,
		v43,
		v50,
		v45,
		entryPoint
	})

	if FFlagSduiDismissPromptAction then
		React.useEffect(function() -- line: 201
			-- upvalues: v51 (copy), v49 (copy), v52 (copy), v42 (copy), CentralOverlayType (copy), v41 (copy), SetCentralOverlay (copy)
			local current = v51.current

			if current == nil then
				return
			end

			for _, v73 in v49 do
				if current == v73.title then
					return
				end
			end

			local current2 = v52.current

			v51.current = nil
			v52.current = nil

			local CentralOverlay2 = v42:getState().CentralOverlay

			if CentralOverlay2 ~= nil and CentralOverlay2.OverlayType == CentralOverlayType.SduiPromptModal and CentralOverlay2.Arguments ~= nil and current2 == CentralOverlay2.Arguments.modalId then
				v41(SetCentralOverlay())
			end
		end, {
			v49,
			v41,
			v42
		})
	end

	local v53 = promptStyle == PromptStyle.SurfaceBanner
	local v54 = usePromptEntries(v45.configKey, PromptStyle.SurfaceBanner)
	local v55 = if not v53 then nil else v54[1]
	local v56 = v55 and v55.identifier or nil
	local v57 = if not v55 then nil else if not FFlagPromptsImpressionUsesTitle then v55.robloxComponentType else v55.title
	local v58 = promptStyle == PromptStyle.InlineBanner
	local v59 = usePromptEntries(v45.configKey, PromptStyle.InlineBanner)
	local v60 = if not v58 then nil else v59[1]
	local v61 = v60 and v60.identifier or nil
	local v62 = if not v60 then nil else if not FFlagPromptsImpressionUsesTitle then v60.robloxComponentType else v60.title

	React.useEffect(function() -- line: 250
		-- upvalues: v56 (copy), v57 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v56 and v57 then
			reportPromptImpression(v57, v56):catch(function() -- line: 252
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(v56, v57)
		end
	end, {
		v56,
		v57
	})
	React.useEffect(function() -- line: 259
		-- upvalues: v61 (copy), v62 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v61 and v62 then
			reportPromptImpression(v62, v61):catch(function() -- line: 261
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(v61, v62)
		end
	end, {
		v61,
		v62
	})

	local v63 = false

	if FFlagPromptsHandlerCoachmarkEnabled then
		for _, v65 in (usePromptEntries(v45.configKey, PromptStyle.Coachmark)) do
			if v65.config and v65.identifier and v65.title then
				v63 = true

				break
			end
		end
	end

	local v66 = FFlagSduiSurfaceBannerScrollAwaySticky and (FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled())
	local v67 = nil

	if v53 then
		v67 = if not FFlagSduiSystemBannerComponent or (not v55 or not v66) then if not FFlagSduiSystemBannerComponent or not v55 then t1.surfaceBannerContent else React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SurfaceBanner = React.createElement(SduiFeatureEntryPoint, {
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				LayoutOrder = 1,
				configKey = v45.configKey,
				identifier = v55.identifier,
				appPage = v45.appPage
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
			identifier = v55.identifier,
			configKey = v45.configKey,
			appPage = v45.appPage,
			surfaceBannerContent = t1.surfaceBannerContent
		})
	elseif v58 then
		v67 = if not v60 then t1.inlineBannerFallback else React.createElement(SduiFeatureEntryPoint, {
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			configKey = v45.configKey,
			identifier = v60.identifier,
			appPage = v45.appPage
		})
	end

	if FFlagHomepagePromptsPaddingFix and v58 then
		local v68 = v54[1] ~= nil

		if v67 ~= nil then
			local v69 = v68 and t1.topPadding ~= nil
			local v70 = t1.bottomPadding ~= nil

			v67 = React.createElement(View, {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				padding = {
					top = if not v69 then nil else UDim.new(0, t1.topPadding),
					bottom = if not v70 then nil else UDim.new(0, t1.bottomPadding)
				}
			}, {
				InlineBanner = v67
			})
		elseif v68 and t1.topPadding then
			v67 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, t1.topPadding)
			})
		end
	end

	if not FFlagPromptsHandlerCoachmarkEnabled or not v63 then
		return v67
	end

	return React.createElement(React.Fragment, nil, {
		Slot = v67,
		Coachmarks = React.createElement(CoachmarkRenderer, {
			surfaceConfig = v45,
			hasShownKey = entryPoint
		})
	})
end

return React.memo(PromptsHandler)
