local GameDetail = script:FindFirstAncestor("GameDetail")
local SetGameDetailsPeekViewState = require(GameDetail.PeekView.SetGameDetailsPeekViewState)
local UseGameDetailsPeekView = require(GameDetail.PeekView.UseGameDetailsPeekView)
local GameDetailParent = GameDetail.Parent
local Cryo = require(GameDetailParent.Cryo)
local AppPage = require(GameDetailParent.RobloxAppEnums).AppPage
local FormFactor = require(GameDetailParent.FormFactor).Enums.FormFactor
local PeekViewState = require(GameDetailParent.PeekView).PeekViewState
local NavigationRodux = require(GameDetailParent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local Selectors = NavigationRodux.Selectors
local SharedFlags = require(GameDetailParent.SharedFlags)
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v15 = if not FFlagSignalsNavP3Dispatch then nil else require(GameDetailParent.RobloxAppNavigation).NavigationCommands
local FFlagUseNavigationSelectors = require(GameDetailParent.SharedFlags).FFlagUseNavigationSelectors
local FFlagLuaAppSduiEdpEnabled = require(GameDetailParent.SharedFlags).FFlagLuaAppSduiEdpEnabled
local FFlagSduiEdpPrefetchPlayability = require(GameDetailParent.SharedFlags).FFlagSduiEdpPrefetchPlayability
local SduiSurfaceLoadTimeTracker = require(GameDetailParent.SduiSharedUtilities).SduiSurfaceLoadTimeTracker
local DeviceType = require(GameDetailParent.RobloxAppEnums).DeviceType
local FetchGamePlayButtonData = require(GameDetailParent.GamePlayButton).FetchGamePlayButtonData
local fetchExperienceDetailsPage = require(script.Parent.ExperienceDetailsPage.fetchExperienceDetailsPage)
local getExperienceDetailsPageKey = require(script.Parent.ExperienceDetailsPage.getExperienceDetailsPageKey)
local GameDetailTelemetry = require(GameDetailParent.GameDetailTelemetry)
local EDPTTIManager = GameDetailTelemetry.EDPTTIManager
local FFlagEDPTTITrackingEnabled = GameDetailTelemetry.FFlagEDPTTITrackingEnabled
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants

return function(p1, p2, t1: {[any]: any}?, p3) -- line: 41
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), FFlagEDPTTITrackingEnabled (copy), EDPTTIManager (copy), EDPTTIConstants (copy), FFlagLuaAppSduiEdpEnabled (copy), DeviceType (copy), SduiSurfaceLoadTimeTracker (copy), getExperienceDetailsPageKey (copy), Cryo (copy), FFlagSduiEdpPrefetchPlayability (copy), FetchGamePlayButtonData (copy), fetchExperienceDetailsPage (copy), FormFactor (copy), UseGameDetailsPeekView (copy), AppPage (copy), PeekViewState (copy), SetGameDetailsPeekViewState (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), FFlagSignalsNavP2NavigationPrimitives (copy), NavigateDown (copy)
	return function(p4) -- line: 42
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), FFlagEDPTTITrackingEnabled (copy), EDPTTIManager (copy), EDPTTIConstants (copy), FFlagLuaAppSduiEdpEnabled (copy), DeviceType (copy), SduiSurfaceLoadTimeTracker (copy), getExperienceDetailsPageKey (copy), p1 (copy), t1 (ref), Cryo (copy), FFlagSduiEdpPrefetchPlayability (copy), p3 (copy), FetchGamePlayButtonData (copy), fetchExperienceDetailsPage (copy), FormFactor (copy), UseGameDetailsPeekView (copy), AppPage (copy), PeekViewState (copy), SetGameDetailsPeekViewState (copy), p2 (copy), FFlagSignalsNavP3Dispatch (copy), v15 (copy), FFlagSignalsNavP2NavigationPrimitives (copy), NavigateDown (copy)
		local v34 = p4:getState()
		local FormFactor2 = v34.FormFactor
		local viewState = v34.GameDetailsPeekView.viewState

		if FFlagUseNavigationSelectors then
			if Selectors.selectNavigationLocked(v34) then
				return
			end
		elseif v34.Navigation.lockNavigationActions then
			return
		end

		if FFlagEDPTTITrackingEnabled then
			EDPTTIManager.startTracking(EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS)
		end

		if FFlagLuaAppSduiEdpEnabled then
			local v37 = if v34.DeviceType ~= DeviceType.Phone then EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE else EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			local v38 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(getExperienceDetailsPageKey((tostring(p1))), {
				manualSurfaceReady = true,
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS,
					category = v37
				}
			})

			t1 = Cryo.Dictionary.join(t1 or {}, {
				pageTimer = v38
			})

			if FFlagSduiEdpPrefetchPlayability and p3 ~= nil then
				p4:dispatch(FetchGamePlayButtonData.Fetch(p3, (tostring(p1))))
			end

			fetchExperienceDetailsPage(tostring(p1), v38)
		end

		local t2

		if FormFactor2 == FormFactor.COMPACT and UseGameDetailsPeekView() then
			t2 = {
				name = AppPage.GameDetail,
				detail = tostring(p1),
				extraProps = t1
			}

			if viewState == PeekViewState.Full or viewState == PeekViewState.Extended or t1 and t1.mountAsFullView then
				t2 = Cryo.Dictionary.join(t2, {
					extraProps = Cryo.Dictionary.join(t2.extraProps or {}, {
						mountAsFullView = true
					})
				})
			else
				p4:dispatch(SetGameDetailsPeekViewState(PeekViewState.Closed))
				p2.clearAppScreens({ AppPage.GameDetail })
			end
		else
			t2 = {
				name = AppPage.ExperienceDetail,
				detail = tostring(p1),
				extraProps = t1
			}
		end

		if FFlagSignalsNavP3Dispatch then
			v15.down(v15.fromLegacyPage(t2), FFlagSignalsNavP2NavigationPrimitives or nil)

			return
		end

		p4:dispatch(NavigateDown(t2, FFlagSignalsNavP2NavigationPrimitives or nil))
	end
end
