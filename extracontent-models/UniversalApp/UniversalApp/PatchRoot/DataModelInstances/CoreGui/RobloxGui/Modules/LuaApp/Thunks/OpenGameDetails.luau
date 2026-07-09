local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local GameDetail = require(CorePackages.Workspace.Packages.GameDetail)
local SetGameDetailsPeekViewState = GameDetail.PeekView.SetGameDetailsPeekViewState
local UseGameDetailsPeekView = GameDetail.PeekView.UseGameDetailsPeekView
local GameDetailTelemetry = require(CorePackages.Workspace.Packages.GameDetailTelemetry)
local FFlagEDPTTITrackingEnabled = GameDetailTelemetry.FFlagEDPTTITrackingEnabled
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v16 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local startNewPeekViewHistory = require(Modules.LuaApp.Util.startNewPeekViewHistory)
local EDPTTIManager = GameDetailTelemetry.EDPTTIManager

local function openBriefGameDetailsPeekView(p1, p2) -- line: 28
	-- upvalues: startNewPeekViewHistory (copy), SetGameDetailsPeekViewState (copy), PeekViewState (copy), ResetNavigationHistory (copy)
	local v26 = startNewPeekViewHistory(p1, p2)
	local newRoute = v26.newRoute
	local newHistory = v26.newHistory

	p1:dispatch(SetGameDetailsPeekViewState(PeekViewState.Closed))
	p1:dispatch(ResetNavigationHistory(newRoute, newHistory))
end
local function openFullGameDetailsPeekView(p3, p4) -- line: 37
	-- upvalues: Cryo (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), NavigateDown (copy)
	local v31 = Cryo.Dictionary.join(p4, {
		extraProps = Cryo.Dictionary.join(p4.extraProps or {}, {
			mountAsFullView = true
		})
	})

	if FFlagSignalsNavP3Dispatch then
		v16.down(v16.fromLegacyPage(v31))

		return
	end

	p3:dispatch(NavigateDown(v31))
end
local function openExperienceDetailsPage(p5, p6) -- line: 48
	-- upvalues: Cryo (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), NavigateDown (copy)
	local v34 = Cryo.Dictionary.join(p6, {
		name = AppPage.ExperienceDetail
	})

	if FFlagSignalsNavP3Dispatch then
		v16.down(v16.fromLegacyPage(v34))

		return
	end

	p5:dispatch(NavigateDown(v34))
end

return function(p7, p8) -- line: 59
	-- upvalues: FFlagEDPTTITrackingEnabled (copy), EDPTTIManager (copy), EDPTTIConstants (copy), FFlagLuaAppSduiEdpEnabled (copy), CorePackages (copy), Cryo (copy), AppPage (copy), FormFactor (copy), UseGameDetailsPeekView (copy), PeekViewState (copy), openFullGameDetailsPeekView (copy), startNewPeekViewHistory (copy), SetGameDetailsPeekViewState (copy), ResetNavigationHistory (copy), openExperienceDetailsPage (copy)
	return function(p9) -- line: 60
		-- upvalues: FFlagEDPTTITrackingEnabled (copy), EDPTTIManager (copy), EDPTTIConstants (copy), FFlagLuaAppSduiEdpEnabled (copy), CorePackages (copy), p7 (copy), p8 (ref), Cryo (copy), AppPage (copy), FormFactor (copy), UseGameDetailsPeekView (copy), PeekViewState (copy), openFullGameDetailsPeekView (copy), startNewPeekViewHistory (copy), SetGameDetailsPeekViewState (copy), ResetNavigationHistory (copy), openExperienceDetailsPage (copy)
		local v39 = p9:getState()
		local FormFactor2 = v39.FormFactor
		local viewState = v39.GameDetailsPeekView.viewState

		if FFlagEDPTTITrackingEnabled then
			EDPTTIManager.startTracking(EDPTTIConstants.EDP_ENTRY_PATH.GAME_DETAIL_OPEN_GAME_DETAILS)
		end

		if FFlagLuaAppSduiEdpEnabled then
			local DeviceType = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceType
			local v43 = if v39.DeviceType ~= DeviceType.Phone then EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_FULL_PAGE else EDPTTIConstants.EDP_IMPLEMENTATION.SDUI_PEEK_VIEW
			local GameDetail2 = require(CorePackages.Workspace.Packages.GameDetail)
			local SduiSurfaceLoadTimeTracker = require(CorePackages.Workspace.Packages.SduiSharedUtilities).SduiSurfaceLoadTimeTracker
			local fetchExperienceDetailsPage = GameDetail2.fetchExperienceDetailsPage
			local v47 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(GameDetail2.getExperienceDetailsPageKey((tostring(p7))), {
				manualSurfaceReady = true,
				eventName = EDPTTIConstants.EDP_TTI_EVENT_NAME,
				metadata = {
					page = EDPTTIConstants.EDP_ENTRY_PATH.MONOLITH_OPEN_GAME_DETAILS,
					category = v43
				}
			})

			p8 = Cryo.Dictionary.join(p8 or {}, {
				pageTimer = v47
			})
			fetchExperienceDetailsPage(tostring(p7), v47)
		end

		local t1 = {
			name = AppPage.GameDetail,
			detail = tostring(p7),
			extraProps = p8
		}

		if FormFactor2 == FormFactor.COMPACT and UseGameDetailsPeekView() then
			if viewState == PeekViewState.Full or viewState == PeekViewState.Extended or p8 and p8.mountAsFullView then
				openFullGameDetailsPeekView(p9, t1)

				return
			end

			local v49 = startNewPeekViewHistory(p9, t1)
			local newRoute = v49.newRoute
			local newHistory = v49.newHistory

			p9:dispatch(SetGameDetailsPeekViewState(PeekViewState.Closed))
			p9:dispatch(ResetNavigationHistory(newRoute, newHistory))

			return
		end

		openExperienceDetailsPage(p9, t1)
	end
end
