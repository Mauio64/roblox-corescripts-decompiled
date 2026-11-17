local GameDetail = script:FindFirstAncestor("GameDetail")
local SetGameDetailsPeekViewState = require(GameDetail.PeekView.SetGameDetailsPeekViewState)
local UseGameDetailsPeekView = require(GameDetail.PeekView.UseGameDetailsPeekView)

local parent = GameDetail.Parent
local Cryo = require(parent.Cryo)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local PeekView = require(parent.PeekView)
local PeekViewState = PeekView.PeekViewState
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local Selectors = NavigationRodux.Selectors

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagSignalsNavPendingLock = SharedFlags.FFlagSignalsNavPendingLock
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local FFlagFixSduiEdpTtiPeekCategory = SharedFlags.FFlagFixSduiEdpTtiPeekCategory
local FFlagFixSduiEdpTtiColdStart = SharedFlags.FFlagFixSduiEdpTtiColdStart
local FFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local appNavigationRegistry

if FFlagSignalsNavP3fGameDetails then
	appNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry
else
	appNavigationRegistry = nil
end

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local RobloxAppEnums2 = require(parent.RobloxAppEnums)
local DeviceType = RobloxAppEnums2.DeviceType
local GamePlayButton = require(parent.GamePlayButton)
local FetchGamePlayButtonData = GamePlayButton.FetchGamePlayButtonData
local Display = require(parent.Display)
local Responsive = require(parent.Responsive)

local fetchExperienceDetailsPage = require(script.Parent.ExperienceDetailsPage.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.ExperienceDetailsPage.getExperienceDetailsPageKey)
local createExperienceDetailsPageTimer = require(script.Parent.ExperienceDetailsPage.createExperienceDetailsPageTimer)

local GameDetailTelemetry = require(parent.GameDetailTelemetry)
local EDPTTIManager = GameDetailTelemetry.EDPTTIManager
local FFlagEDPTTITrackingEnabled = GameDetailTelemetry.FFlagEDPTTITrackingEnabled
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants

return function(p, p2, extraProps, p3)
	return function(object)
		local state = object:getState()
		local formFactor2 = state.FormFactor
		local viewState = state.GameDetailsPeekView.viewState

		if FFlagSignalsNavP3fGameDetails then
			if FFlagSignalsNavPendingLock then
				if appNavigationRegistry.isNavigationLocked(false) then
					return
				end
			elseif appNavigationRegistry.get().getIsNavigating() then
				return
			end
		elseif FFlagUseNavigationSelectors then
			if Selectors.selectNavigationLocked(state) then
				return
			end
		elseif state.Navigation.lockNavigationActions then
			return
		end

		if FFlagEDPTTITrackingEnabled and not (FFlagFixSduiEdpTtiColdStart and FFlagLuaAppSduiEdpEnabled) then
			if FFlagEDPTTIParityDefinitions then
				EDPTTIManager.restartTracking(EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS)
			else
				EDPTTIManager.startTracking(EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS)
			end
		end

		if FFlagLuaAppSduiEdpEnabled then
			local category

			if FFlagFixSduiEdpTtiPeekCategory then
				local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
				local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)

				if Responsive.getIsCompactTouch(viewportSize, preferredInputType) then
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				else
					category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
				end
			elseif state.DeviceType == DeviceType.Phone then
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			else
				category = EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
			end

			local pageTimer

			if FFlagEDPTTIParityDefinitions then
				pageTimer = createExperienceDetailsPageTimer(getExperienceDetailsPageKey((tostring(p))), {
					page = EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS,
					category = category
				})
			else
				pageTimer = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
					getExperienceDetailsPageKey((tostring(p))),
					{
						eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
						metadata = {
							page = EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS,
							category = category
						},
						manualSurfaceReady = true
					}
				)
			end

			extraProps = Cryo.Dictionary.join(extraProps or {}, { pageTimer = pageTimer })

			if p3 ~= nil then
				object:dispatch(FetchGamePlayButtonData.Fetch(p3, (tostring(p))))
			end

			fetchExperienceDetailsPage(tostring(p), pageTimer)
		end

		local v

		if formFactor2 == formFactor.COMPACT and UseGameDetailsPeekView() then
			v = { name = AppPage.GameDetail, detail = tostring(p), extraProps = extraProps }

			if
				viewState == PeekViewState.Full
				or viewState == PeekViewState.Extended
				or extraProps and extraProps.mountAsFullView
			then
				v = Cryo.Dictionary.join(v, {
					extraProps = Cryo.Dictionary.join(v.extraProps or {}, { mountAsFullView = true })
				})
			else
				object:dispatch(SetGameDetailsPeekViewState(PeekViewState.Closed))
				p2.clearAppScreens({ AppPage.GameDetail })
			end
		else
			v = { name = AppPage.ExperienceDetail, detail = tostring(p), extraProps = extraProps }
		end

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v), FFlagSignalsNavP2NavigationPrimitives or nil)
		else
			object:dispatch(NavigateDown(v, FFlagSignalsNavP2NavigationPrimitives or nil))
		end
	end
end
