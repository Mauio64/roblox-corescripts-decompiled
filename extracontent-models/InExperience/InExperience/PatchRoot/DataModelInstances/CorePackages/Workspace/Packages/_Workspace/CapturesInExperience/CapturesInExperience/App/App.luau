local parent = script.Parent.Parent
local parent2 = parent.Parent

local FFlagCapturesInExpUseMomentsCreation = require(parent.Flags.FFlagCapturesInExpUseMomentsCreation)

local AppStorageService = game:GetService("AppStorageService")
local CaptureService = game:GetService("CaptureService")
local LocalizationService = game:GetService("LocalizationService")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local AppCommonLib = require(parent2.AppCommonLib)
local CapturesCommon = require(parent2.CapturesCommon)
local Dash = require(parent2.Dash)
local MomentsCreationFlow

if FFlagCapturesInExpUseMomentsCreation then
	MomentsCreationFlow = nil
else
	MomentsCreationFlow = require(parent2.MomentsCreationFlow)
end

local React = require(parent2.React)
local Roact = require(parent2.Roact)
local Rodux = require(parent2.Rodux)

local Signal = AppCommonLib.Signal

local AnalyticsService = require(parent.Analytics.AnalyticsService)
local CaptureManagerScreen = require(parent.Components.CaptureManager.CaptureManagerScreen)
local CaptureOverlay = require(parent.Components.CoreUI.CaptureOverlay)
local MomentsCreationFlowScreen = require(parent.Components.MomentsCreationFlow.MomentsCreationFlowScreen)
local CapturesActivated = require(parent.Actions.CapturesActivated)
local CapturesCoreGuiDisabled = require(parent.Actions.CapturesCoreGuiDisabled)
local CapturesCoreGuiEnabled = require(parent.Actions.CapturesCoreGuiEnabled)
local CapturesCoreUI = require(parent.Components.CoreUI.CapturesCoreUI)
local CapturesDeactivated = require(parent.Actions.CapturesDeactivated)
local CaptureServicePrompts = require(parent.Components.CaptureService.CaptureServicePrompts)
local CapturesPage = require(parent.Components.CoreUI.CapturesPage)
local CapturesPolicy = require(parent.App.CapturesPolicy)
local CarouselScreen = require(parent.Components.CapturesCarousel.CarouselScreen)
local Constants = require(parent.Constants)
local EventNames = require(parent.Analytics.EventNames)
local getLocalUserId = require(parent.Utils.getLocalUserId)
local getUserIdsFromString = require(parent.Utils.getUserIdsFromString)
local installReducer = require(parent.installReducer)
local makeCaptureSavedHandler = require(parent.Utils.makeCaptureSavedHandler)
local makeVideoCaptureInProgressHandler = require(parent.Utils.makeVideoCaptureInProgressHandler)
local makeWrapWithProviders = require(parent.Utils.makeWrapWithProviders)
local MenuClosed = require(parent.Actions.MenuClosed)
local MenuOpened = require(parent.Actions.MenuOpened)
local MomentsCreationFlowClosed = require(parent.Actions.MomentsCreationFlowClosed)
local Networking = require(parent.App.Networking)
local onToggleActivation = require(parent.Utils.onToggleActivation)
local onViewportSizeChanged = CapturesCommon.Utils.onViewportSizeChanged
local CheckMomentsEligibility = require(parent.Thunks.CheckMomentsEligibility)
local RetrieveCaptures = require(parent.Thunks.RetrieveCaptures)
local ScreenSize = require(parent.installReducer.ScreenSize)
local ScreenSizeChanged = require(parent.Actions.ScreenSizeChanged)
local ServerType = require(parent.installReducer.ServerType)
local ServerTypeDetected = require(parent.Actions.ServerTypeDetected)
local setupFireEvent = require(parent.Analytics.setupFireEvent)
local TakeCapture = require(parent.Thunks.TakeCapture)
require(parent.Types)

local FFlagCapturesVideoCaptureTriggerHandlerEnabled = require(parent.Flags.FFlagCapturesVideoCaptureTriggerHandlerEnabled)
local FFlagCreateMomentsToast = require(parent.Flags.FFlagCreateMomentsToast)
local FFlagMomentsCaptureEndIxpEnabled = require(parent.Flags.FFlagMomentsCaptureEndIxpEnabled)

local FFlagCapturesInExpReportMomentsCreationUI = require(parent.Flags.FFlagCapturesInExpReportMomentsCreationUI)
local FIntCapturesCoreGuiEventsPerMyriad = require(parent.Flags.FIntCapturesCoreGuiEventsPerMyriad)
local engineFeature = game:GetEngineFeature("SSUIMetaLua")

return {
	createApp = function(p)
		local app = {
			_momentsCreationFlowDestroyingConnection = nil,
			_momentsCreationFlowHandle = nil
		}

		local joined = Dash.join({
			AnalyticsService = AnalyticsService,
			AppStorageService = AppStorageService,
			CaptureService = CaptureService,
			LocalizationService = LocalizationService,
			NotificationService = NotificationService,
			Players = Players,
			RbxAnalyticsService = RbxAnalyticsService,
			RobloxReplicatedStorage = RobloxReplicatedStorage,
			StarterGui = StarterGui
		}, p)

		local v = { analytics = joined.AnalyticsService, infoForAllEvents = 0 }
		local isUnder

		if joined.Players.LocalPlayer then
			isUnder = joined.Players.LocalPlayer:GetUnder13()
		end

		v.infoForAllEvents = {
			isUnder13 = isUnder,
			pid = tostring(game.PlaceId),
			source = Constants.AnalyticsSource,
			uid = getLocalUserId(joined.Players),
			universeId = tostring(game.GameId)
		}
		local fireAnalyticsEvent = setupFireEvent(v)

		local v2 = {
			[Constants.RoduxKey] = installReducer(),
			NetworkStatus = Networking.RoduxNetworking.installReducer(),
			ScreenSize = ScreenSize,
			ServerType = ServerType,
			ShareLinks = Networking.ShareLinksRodux.installReducer()
		}

		if MomentsCreationFlow then
			v2[MomentsCreationFlow.Constants.RoduxKey] = MomentsCreationFlow.installReducer()
		end

		local combineReducers = Rodux.combineReducers(v2)

		app._store = Rodux.Store.new(combineReducers, {}, { Rodux.thunkMiddleware })

		app._store:dispatch(RetrieveCaptures())

		if FFlagCreateMomentsToast or FFlagMomentsCaptureEndIxpEnabled then
			app._store:dispatch(CheckMomentsEligibility(game.GameId))
		end

		local captureSavedHandler = makeCaptureSavedHandler(app._store, joined, fireAnalyticsEvent)
		joined.CaptureService.CaptureSavedInternal:Connect(captureSavedHandler)

		if FFlagCapturesVideoCaptureTriggerHandlerEnabled then
			local videoCaptureInProgressHandler = makeVideoCaptureInProgressHandler(
				app._store,
				joined,
				fireAnalyticsEvent
			)

			joined.CaptureService.VideoCaptureInProgress:Connect(videoCaptureInProgressHandler)
		end

		joined.AppStorageService:WhenLoaded(function()
			local success, result = pcall(function()
				return joined.AppStorageService:GetItem(Constants.CapturesActiveLocalStorageKey)
			end)

			if success and result ~= "" then
				if getUserIdsFromString(result)[getLocalUserId(joined.Players) or ""] then
					app._store:dispatch(CapturesActivated())
				else
					app._store:dispatch(CapturesDeactivated())
				end
			end
		end)

		task.spawn(function()
			local success, result = pcall(function()
				return joined.RobloxReplicatedStorage:WaitForChild("GetServerType", 1e999):InvokeServer()
			end)

			if success then
				app._store:dispatch(ServerTypeDetected(result))
			end
		end)

		function app.closeMenu()
			app._store:dispatch(MenuClosed())
		end

		function app.openMenu()
			app._store:dispatch(MenuOpened())
		end

		function app.takeCapture(p2)
			app._store:dispatch(TakeCapture(p2))
		end

		local function maybeSendCoreGuiEvent(allTypeChanged: boolean, flag: boolean)
			if
				FIntCapturesCoreGuiEventsPerMyriad == 0
				or FIntCapturesCoreGuiEventsPerMyriad <= Random.new():NextInteger(1, 10000)
			then
				return
			end

			if flag then
				fireAnalyticsEvent(EventNames.CapturesCoreGuiEnabled, {
					allTypeChanged = allTypeChanged
				})
			else
				fireAnalyticsEvent(EventNames.CapturesCoreGuiDisabled, {
					allTypeChanged = allTypeChanged
				})
			end
		end

		joined.StarterGui.CoreGuiChangedSignal:Connect(function(p2, p3)
			if p2 ~= Enum.CoreGuiType.All and p2 ~= Enum.CoreGuiType.Captures then
				return
			end

			maybeSendCoreGuiEvent(p2 == Enum.CoreGuiType.All, p3)

			if p3 then
				app._store:dispatch(CapturesCoreGuiEnabled())
			else
				app._store:dispatch(CapturesCoreGuiDisabled())
			end
		end)

		if joined.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures) then
			app._store:dispatch(CapturesCoreGuiEnabled())
		else
			app._store:dispatch(CapturesCoreGuiDisabled())
		end

		app.onIsActiveChanged = Signal.new()
		function app.getIsActive()
			return app._store:getState()[Constants.RoduxKey].IsActive or false
		end

		app._store.changed:connect(function(p2, p3)
			local isActive = p3[Constants.RoduxKey].IsActive
			local isActive2 = p2[Constants.RoduxKey].IsActive

			if isActive2 ~= isActive then
				pcall(function()
					local userIdsFromString = getUserIdsFromString((joined.AppStorageService:GetItem(Constants.CapturesActiveLocalStorageKey)))
					local v3 = getLocalUserId(joined.Players) or ""

					if isActive2 then
						userIdsFromString[v3] = true
					else
						userIdsFromString[v3] = nil
					end

					local joined2 = table.concat(Dash.keys(userIdsFromString), ",")
					joined.AppStorageService:SetItem(Constants.CapturesActiveLocalStorageKey, joined2)
					joined.AppStorageService:Flush()
				end)

				app.onIsActiveChanged:fire(isActive2)
			end
		end)

		if engineFeature then
			pcall(function()
				local safetyService = joined.SafetyService or game:GetService("SafetyService")
				app._store.changed:connect(function(p2, p3)
					local v3 = p2[Constants.RoduxKey]
					local v4 = p3[Constants.RoduxKey]

					local v5 = v4.IsMenuOpen or v4.Carousel and v4.Carousel.IsOpen
					local v6 = v3.IsMenuOpen or v3.Carousel and v3.Carousel.IsOpen

					if FFlagCapturesInExpReportMomentsCreationUI then
						v5 = v5 or v4.MomentsCreationFlow.IsOpen
						v6 = v6 or v3.MomentsCreationFlow.IsOpen
					end

					if v6 and not v5 then
						pcall(function()
							safetyService:ReportCapturesUIOpen()
						end)
					elseif not v6 and v5 then
						pcall(function()
							safetyService:ReportCapturesUIClose()
						end)
					end
				end)
			end)
		end

		onViewportSizeChanged(function(vector2: Vector2)
			app._store:dispatch(ScreenSizeChanged(vector2))
		end)

		function app.onToggleActivationFromChrome(...)
			onToggleActivation(app.getIsActive(), nil, fireAnalyticsEvent, function(...)
				app._store:dispatch(...)
			end, EventNames.CapturesActivatedChrome, EventNames.CapturesDeactivatedChrome)
		end

		local wrapWithProviders = makeWrapWithProviders(app._store, joined)

		local v3 = CapturesPolicy.PolicyImplementation.read()
		local v4

		if v3 then
			v4 = CapturesPolicy.Mapper(v3).eligibleForCapturesFeature()
		else
			v4 = false
		end

		local v5

		if v3 then
			v5 = CapturesPolicy.Mapper(v3).enableCapturesBulkManagement()
		else
			v5 = false
		end

		local v6 = { fireAnalyticsEvent = fireAnalyticsEvent }

		local function unmountMomentsCreationFlow()
			local momentsCreationFlowDestroyingConnection = app._momentsCreationFlowDestroyingConnection
			app._momentsCreationFlowDestroyingConnection = nil

			if momentsCreationFlowDestroyingConnection then
				momentsCreationFlowDestroyingConnection:Disconnect()
			end

			local momentsCreationFlowHandle = app._momentsCreationFlowHandle
			app._momentsCreationFlowHandle = nil

			if momentsCreationFlowHandle then
				Roact.unmount(momentsCreationFlowHandle)
			end

			if
				FFlagCapturesInExpUseMomentsCreation
				and app._store:getState()[Constants.RoduxKey].MomentsCreationFlow.IsOpen
			then
				local MomentsCreation = require(parent2.MomentsCreation)
				MomentsCreation.resetCreationFlow(MomentsCreation.Enums.CreationFlowState.Preview)
				app._store:dispatch(MomentsCreationFlowClosed())
			end
		end

		function app.mountCaptureManager(p2)
			if not (v5 and v4) then
				return
			end

			app._captureManagerHandle = wrapWithProviders(p2, v6, {
				CaptureManager = React.createElement(CaptureManagerScreen)
			})
		end

		function app.mountCaptureOverlay(p2)
			if not v4 then
				return
			end

			app._captureOverlayHandle = wrapWithProviders(p2, v6, {
				CaptureOverlay = React.createElement(CaptureOverlay)
			})
		end

		function app.mountCarousel(p2)
			if not v4 then
				return
			end

			app._carouselHandle = wrapWithProviders(p2, v6, {
				CarouselScreen = React.createElement(CarouselScreen)
			})
		end

		function app.mountCoreUI(p2, chromeEnabled: boolean?)
			if not v4 then
				return
			end

			app._coreUiHandle = wrapWithProviders(
				p2,
				{ chromeEnabled = chromeEnabled, fireAnalyticsEvent = fireAnalyticsEvent },
				{
					CaptureServicePrompts = React.createElement(CaptureServicePrompts),
					CapturesCoreUI = React.createElement(CapturesCoreUI)
				},
				"CapturesCoreUI"
			)
		end

		function app.mountMenuPage(p2, closeSettingsMenu, chromeEnabled: boolean?)
			if not v4 then
				return
			end

			app._menuPageHandle = wrapWithProviders(
				p2,
				{ chromeEnabled = chromeEnabled, fireAnalyticsEvent = fireAnalyticsEvent },
				{
					CapturesPage = React.createElement(CapturesPage, {
						closeSettingsMenu = closeSettingsMenu
					})
				}
			)
		end

		function app.mountMomentsCreationFlow(instance)
			if not (FFlagCreateMomentsToast and v4) then
				return
			end

			if FFlagCapturesInExpUseMomentsCreation and app._momentsCreationFlowHandle then
				unmountMomentsCreationFlow()
			end

			app._momentsCreationFlowHandle = wrapWithProviders(
				instance,
				v6,
				{
					MomentsCreationFlowScreen = React.createElement(MomentsCreationFlowScreen)
				},
				nil,
				{
					withFoundationProvider = not FFlagCapturesInExpUseMomentsCreation
				}
			)

			if FFlagCapturesInExpUseMomentsCreation then
				app._momentsCreationFlowDestroyingConnection = instance.Destroying:Connect(unmountMomentsCreationFlow)
			end
		end

		return app
	end
}
