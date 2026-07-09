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
local sendModalImpressionEvent = require(ServerTriggeredModals.sendModalImpressionEvent)
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
local FFlagSduiSystemBannerComponent = SharedFlags.FFlagSduiSystemBannerComponent
local FFlagSduiSurfaceBannerScrollAwaySticky = SharedFlags.FFlagSduiSurfaceBannerScrollAwaySticky
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagSduiDismissPromptAction = SharedFlags.FFlagSduiDismissPromptAction
local FFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix

local function PromptsHandler(t1: {[any]: any}) -- line: 82
	-- upvalues: useDispatch (copy), FFlagSduiDismissPromptAction (copy), useStore (copy), useModalSignalStore (copy), React (copy), getEntryPointSurfaceConfig (copy), SignalsReact (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy), fetchPrompts (copy), usePromptEntries (copy), PromptStyle (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagPromptsImpressionUsesTitle (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy), FFlagPromptsHandlerCoachmarkEnabled (copy), FFlagSduiSurfaceBannerScrollAwaySticky (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagSduiSystemBannerComponent (copy), SurfaceBanner (copy), SduiFeatureEntryPoint (copy), FFlagHomepagePromptsPaddingFix (copy), View (copy), CoachmarkRenderer (copy)
	local entryPoint = t1.entryPoint
	local promptStyle = t1.promptStyle
	local v40 = useDispatch()
	local v41 = if not FFlagSduiDismissPromptAction then nil else useStore()
	local v42 = useModalSignalStore()
	local v43 = React.useMemo(function() -- line: 89
		-- upvalues: getEntryPointSurfaceConfig (copy), entryPoint (copy)
		return getEntryPointSurfaceConfig(entryPoint)
	end, { entryPoint })
	local v44 = SignalsReact.useSignalState(v42.getHasShownGetter(entryPoint))
	local v45 = SignalsReact.useSignalState(v42.getMetadataGetter(entryPoint))
	local v46 = React.useMemo(function() -- line: 101
		-- upvalues: entryPoint (copy), v43 (copy), FFlagSduiAllowNoConfigsBuilt (copy), SduiLoadTimer (copy)
		return {
			clearOnEmptyResponse = true,
			entryPoint = entryPoint,
			surfaceKey = v43.surfaceKey,
			configKey = v43.configKey,
			allowNoConfigsBuilt = not not FFlagSduiAllowNoConfigsBuilt or nil,
			loadTimer = SduiLoadTimer.createLoadTimer(v43.configKey)
		}
	end, {
		entryPoint,
		v43
	})

	React.useEffect(function() -- line: 112
		-- upvalues: fetchPrompts (copy), v46 (copy)
		fetchPrompts(v46)
	end, { v46 })

	local v47 = usePromptEntries(v43.configKey, PromptStyle.Modal)
	local v48 = v47[1]
	local v49 = if not FFlagSduiDismissPromptAction then nil else React.useRef(nil)
	local v50 = if not FFlagSduiDismissPromptAction then nil else React.useRef(nil)

	React.useEffect(function() -- line: 135
		-- upvalues: v44 (copy), v45 (copy), v48 (copy), v42 (copy), entryPoint (copy), v40 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v43 (copy), FFlagPromptsImpressionUsesTitle (copy), FFlagSduiDismissPromptAction (copy), v49 (copy), v50 (copy)
		if v44 then
			return
		end

		if v45 then
			return
		end

		if v48 == nil or v48.config == nil or v48.identifier == nil or v48.robloxComponentType == nil or v48.title == nil then
			return
		end

		v42.setHasShown(entryPoint, true)
		v40(SetCentralOverlay(CentralOverlayType.SduiPromptModal, {
			configKey = v43.configKey,
			appPage = v43.appPage,
			modalId = v48.identifier,
			modalType = if not FFlagPromptsImpressionUsesTitle then v48.robloxComponentType else v48.title
		}))

		if FFlagSduiDismissPromptAction then
			v49.current = v48.title
			v50.current = v48.identifier
		end
	end, {
		v44,
		v45,
		v40,
		v42,
		v48,
		v43,
		entryPoint
	})

	if FFlagSduiDismissPromptAction then
		React.useEffect(function() -- line: 186
			-- upvalues: v49 (copy), v47 (copy), v50 (copy), v41 (copy), CentralOverlayType (copy), v40 (copy), SetCentralOverlay (copy)
			local current = v49.current

			if current == nil then
				return
			end

			for _, v71 in v47 do
				if current == v71.title then
					return
				end
			end

			local current2 = v50.current

			v49.current = nil
			v50.current = nil

			local CentralOverlay2 = v41:getState().CentralOverlay

			if CentralOverlay2 ~= nil and CentralOverlay2.OverlayType == CentralOverlayType.SduiPromptModal and CentralOverlay2.Arguments ~= nil and current2 == CentralOverlay2.Arguments.modalId then
				v40(SetCentralOverlay())
			end
		end, {
			v47,
			v40,
			v41
		})
	end

	local v51 = promptStyle == PromptStyle.SurfaceBanner
	local v52 = usePromptEntries(v43.configKey, PromptStyle.SurfaceBanner)
	local v53 = if not v51 then nil else v52[1]
	local v54 = v53 and v53.identifier or nil
	local v55 = if not v53 then nil else if not FFlagPromptsImpressionUsesTitle then v53.robloxComponentType else v53.title
	local v56 = promptStyle == PromptStyle.InlineBanner
	local v57 = usePromptEntries(v43.configKey, PromptStyle.InlineBanner)
	local v58 = if not v56 then nil else v57[1]
	local v59 = v58 and v58.identifier or nil
	local v60 = if not v58 then nil else if not FFlagPromptsImpressionUsesTitle then v58.robloxComponentType else v58.title

	React.useEffect(function() -- line: 235
		-- upvalues: v54 (copy), v55 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v54 and v55 then
			reportPromptImpression(v55, v54):catch(function() -- line: 237
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(v54, v55)
		end
	end, {
		v54,
		v55
	})
	React.useEffect(function() -- line: 244
		-- upvalues: v59 (copy), v60 (copy), reportPromptImpression (copy), Logger (copy), sendModalImpressionEvent (copy)
		if v59 and v60 then
			reportPromptImpression(v60, v59):catch(function() -- line: 246
				-- upvalues: Logger (copy)
				Logger:warning("Failed to report prompt impression")
			end)
			sendModalImpressionEvent(v59, v60)
		end
	end, {
		v59,
		v60
	})

	local v61 = false

	if FFlagPromptsHandlerCoachmarkEnabled then
		for _, v63 in (usePromptEntries(v43.configKey, PromptStyle.Coachmark)) do
			if v63.config and v63.identifier and v63.title then
				v61 = true

				break
			end
		end
	end

	local v64 = FFlagSduiSurfaceBannerScrollAwaySticky and (FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled())
	local v65 = nil

	if v51 then
		v65 = if not FFlagSduiSystemBannerComponent or (not v53 or not v64) then if not FFlagSduiSystemBannerComponent or not v53 then t1.surfaceBannerContent else React.createElement("Frame", {
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
				configKey = v43.configKey,
				identifier = v53.identifier,
				appPage = v43.appPage
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
			identifier = v53.identifier,
			configKey = v43.configKey,
			appPage = v43.appPage,
			surfaceBannerContent = t1.surfaceBannerContent
		})
	elseif v56 then
		v65 = if not v58 then t1.inlineBannerFallback else React.createElement(SduiFeatureEntryPoint, {
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			configKey = v43.configKey,
			identifier = v58.identifier,
			appPage = v43.appPage
		})
	end

	if FFlagHomepagePromptsPaddingFix and v56 then
		local v66 = v52[1] ~= nil

		if v65 ~= nil then
			local v67 = v66 and t1.topPadding ~= nil
			local v68 = t1.bottomPadding ~= nil

			v65 = React.createElement(View, {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				padding = {
					top = if not v67 then nil else UDim.new(0, t1.topPadding),
					bottom = if not v68 then nil else UDim.new(0, t1.bottomPadding)
				}
			}, {
				InlineBanner = v65
			})
		elseif v66 and t1.topPadding then
			v65 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, t1.topPadding)
			})
		end
	end

	if not FFlagPromptsHandlerCoachmarkEnabled or not v61 then
		return v65
	end

	return React.createElement(React.Fragment, nil, {
		Slot = v65,
		Coachmarks = React.createElement(CoachmarkRenderer, {
			surfaceConfig = v43,
			hasShownKey = entryPoint
		})
	})
end

return React.memo(PromptsHandler)
