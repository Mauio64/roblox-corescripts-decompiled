local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local module = require("@luauforge/bundled/dzF")
local setGameDetailsPeekViewState = module.PeekView.SetGameDetailsPeekViewState
local useGameDetailsPeekView = module.PeekView.UseGameDetailsPeekView
local module2 = require("@luauforge/bundled/dHp")
local fFlagEDPTTITrackingEnabled = module2.FFlagEDPTTITrackingEnabled
local edpttiConstants = module2.EDPTTIConstants

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local fFlagFixSduiEdpTtiPeekCategory = SharedFlags.FFlagFixSduiEdpTtiPeekCategory
local fFlagFixSduiEdpTtiColdStart = SharedFlags.FFlagFixSduiEdpTtiColdStart
local fFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module4 = require("@luauforge/bundled/dHq")
local module5 = require("@luauforge/bundled/dUc")

local edpttiManager = module2.EDPTTIManager

local function openBriefGameDetailsPeekView(object, p2)
	local v5 = module5(object, p2)
	local newRoute = v5.newRoute
	local newHistory = v5.newHistory

	object:dispatch(setGameDetailsPeekViewState(peekViewState.Closed))
	object:dispatch(module4(newRoute, newHistory))
end

local function openFullGameDetailsPeekView(object, p2)
	local joined = Cryo.Dictionary.join(p2, {
		extraProps = Cryo.Dictionary.join(p2.extraProps or {}, {
			mountAsFullView = true
		})
	})

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(joined))
	else
		object:dispatch(navigateDown(joined))
	end
end

local function openExperienceDetailsPage(object, p2)
	local joined = Cryo.Dictionary.join(p2, { name = appPage.ExperienceDetail })

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(joined))
	else
		object:dispatch(navigateDown(joined))
	end
end

return function(p2, options)
	return function(object)
		local state = object:getState()
		local formFactor2 = state.FormFactor
		local viewState = state.GameDetailsPeekView.viewState

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
			local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceType
			local module6 = require("@luauforge/bundled/dzF")
			local module7 = require("@luauforge/bundled/dUd")
			local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
			local v5

			if fFlagFixSduiEdpTtiPeekCategory then
				local viewportSize = module7.GetDisplayStore(false).getViewportSize(false)
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

			local sduiSurfaceLoadTimeTracker = require("@luauforge/bundled/dUe").SduiSurfaceLoadTimeTracker
			local fetchExperienceDetailsPage = module6.fetchExperienceDetailsPage
			local v6

			if fFlagEDPTTIParityDefinitions then
				v6 = module6.createExperienceDetailsPageTimer(
					module6.getExperienceDetailsPageKey((tostring(p2))),
					{
						page = edpttiConstants.EDP_ENTRY_PATH.MONOLITH_OPEN_GAME_DETAILS,
						category = v5
					}
				)
			else
				v6 = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
					module6.getExperienceDetailsPageKey((tostring(p2))),
					{
						eventName = edpttiConstants.EDP_TTI_EVENT_NAME,
						metadata = {
							page = edpttiConstants.EDP_ENTRY_PATH.MONOLITH_OPEN_GAME_DETAILS,
							category = v5
						},
						manualSurfaceReady = true
					}
				)
			end

			options = Cryo.Dictionary.join(options or {}, { pageTimer = v6 })

			fetchExperienceDetailsPage(tostring(p2), v6)
		end

		local v5 = {
			name = appPage.GameDetail,
			detail = tostring(p2),
			extraProps = options
		}

		if formFactor2 ~= formFactor.COMPACT or not useGameDetailsPeekView() then
			openExperienceDetailsPage(object, v5)

			return
		end

		if
			viewState == peekViewState.Full
			or viewState == peekViewState.Extended
			or options and options.mountAsFullView
		then
			openFullGameDetailsPeekView(object, v5)
			return
		end

		local v6 = module5(object, v5)
		local newRoute = v6.newRoute
		local newHistory = v6.newHistory

		object:dispatch(setGameDetailsPeekViewState(peekViewState.Closed))
		object:dispatch(module4(newRoute, newHistory))
	end
end
