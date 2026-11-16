local SetGameDetailsPeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/PeekView/SetGameDetailsPeekViewState")
local UseGameDetailsPeekView = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/PeekView/UseGameDetailsPeekView")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Cryo")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/FormFactor").Enums.FormFactor
local peekViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/PeekView").PeekViewState
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/NavigationRodux")
local navigateDown = NavigationRodux.Thunks.NavigateDown
local selectors = NavigationRodux.Selectors

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local fFlagFixSduiEdpTtiPeekCategory = SharedFlags.FFlagFixSduiEdpTtiPeekCategory
local fFlagFixSduiEdpTtiColdStart = SharedFlags.FFlagFixSduiEdpTtiColdStart
local fFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppNavigation")
local navigationCommands = if fFlagSignalsNavP3Dispatch then RobloxAppNavigation.NavigationCommands else nil

local appNavigationRegistry = if fFlagSignalsNavP3fGameDetails then RobloxAppNavigation.AppNavigationRegistry else nil

local sduiSurfaceLoadTimeTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities").SduiSurfaceLoadTimeTracker
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").DeviceType
local fetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GamePlayButton").FetchGamePlayButtonData
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Display")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Responsive")

local fetchExperienceDetailsPage = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/fetchExperienceDetailsPage")
local getExperienceDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/getExperienceDetailsPageKey")
local createExperienceDetailsPageTimer = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/createExperienceDetailsPageTimer")

local GameDetailTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GameDetailTelemetry")
local edpttiManager = GameDetailTelemetry.EDPTTIManager
local fFlagEDPTTITrackingEnabled = GameDetailTelemetry.FFlagEDPTTITrackingEnabled
local edpttiConstants = GameDetailTelemetry.EDPTTIConstants

return function(p2, p3, options, p4)
	return function(object)
		local state = object:getState()
		local formFactor2 = state.FormFactor
		local viewState = state.GameDetailsPeekView.viewState

		if fFlagSignalsNavP3fGameDetails then
			if appNavigationRegistry.get().getIsNavigating() then
				return
			end
		elseif fFlagUseNavigationSelectors then
			if selectors.selectNavigationLocked(state) then
				return
			end
		elseif state.Navigation.lockNavigationActions then
			return
		end

		if
			fFlagEDPTTITrackingEnabled
			and not (fFlagFixSduiEdpTtiColdStart and fFlagLuaAppSduiEdpEnabled)
		then
			if fFlagEDPTTIParityDefinitions then
				edpttiManager.restartTracking(edpttiConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS)
			else
				edpttiManager.startTracking(edpttiConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS)
			end
		end

		if fFlagLuaAppSduiEdpEnabled then
			local v5

			if fFlagFixSduiEdpTtiPeekCategory then
				local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
				local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)

				if Responsive.getIsCompactTouch(viewportSize, preferredInputType) then
					v5 = edpttiConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
				else
					v5 = edpttiConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
				end
			elseif state.DeviceType == deviceType.Phone then
				v5 = edpttiConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			else
				v5 = edpttiConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE
			end

			local v6

			if fFlagEDPTTIParityDefinitions then
				v6 = createExperienceDetailsPageTimer(getExperienceDetailsPageKey((tostring(p2))), {
					page = edpttiConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS,
					category = v5
				})
			else
				v6 = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
					getExperienceDetailsPageKey((tostring(p2))),
					{
						eventName = edpttiConstants.EDP_TTI_EVENT_NAME,
						metadata = {
							page = edpttiConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS,
							category = v5
						},
						manualSurfaceReady = true
					}
				)
			end

			options = Cryo.Dictionary.join(options or {}, { pageTimer = v6 })

			if p4 ~= nil then
				object:dispatch(fetchGamePlayButtonData.Fetch(p4, (tostring(p2))))
			end

			fetchExperienceDetailsPage(tostring(p2), v6)
		end

		local v5

		if formFactor2 == formFactor.COMPACT and UseGameDetailsPeekView() then
			v5 = {
				name = appPage.GameDetail,
				detail = tostring(p2),
				extraProps = options
			}

			if
				viewState == peekViewState.Full
				or viewState == peekViewState.Extended
				or options and options.mountAsFullView
			then
				v5 = Cryo.Dictionary.join(v5, {
					extraProps = Cryo.Dictionary.join(v5.extraProps or {}, {
						mountAsFullView = true
					})
				})
			else
				object:dispatch(SetGameDetailsPeekViewState(peekViewState.Closed))
				p3.clearAppScreens({ appPage.GameDetail })
			end
		else
			v5 = {
				name = appPage.ExperienceDetail,
				detail = tostring(p2),
				extraProps = options
			}
		end

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(
				navigationCommands.fromLegacyPage(v5),
				fFlagSignalsNavP2NavigationPrimitives or nil
			)
		else
			object:dispatch(navigateDown(v5, fFlagSignalsNavP2NavigationPrimitives or nil))
		end
	end
end
