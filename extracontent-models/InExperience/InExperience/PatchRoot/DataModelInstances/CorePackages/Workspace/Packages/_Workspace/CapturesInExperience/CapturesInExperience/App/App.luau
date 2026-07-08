local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local AppStorageService = game:GetService("AppStorageService")
local CaptureService = game:GetService("CaptureService")
local LocalizationService = game:GetService("LocalizationService")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local AppCommonLib = require(ParentParentParent.AppCommonLib)
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local Dash = require(ParentParentParent.Dash)
local MomentsCreationFlow = require(ParentParentParent.MomentsCreationFlow)
local React = require(ParentParentParent.React)
local Rodux = require(ParentParentParent.Rodux)
local Signal = AppCommonLib.Signal
local AnalyticsService = require(ParentParent.Analytics.AnalyticsService)
local CaptureManagerScreen = require(ParentParent.Components.CaptureManager.CaptureManagerScreen)
local CaptureOverlay = require(ParentParent.Components.CoreUI.CaptureOverlay)
local MomentsCreationFlowScreen = require(ParentParent.Components.MomentsCreationFlow.MomentsCreationFlowScreen)
local CapturesActivated = require(ParentParent.Actions.CapturesActivated)
local CapturesCoreGuiDisabled = require(ParentParent.Actions.CapturesCoreGuiDisabled)
local CapturesCoreGuiEnabled = require(ParentParent.Actions.CapturesCoreGuiEnabled)
local CapturesCoreUI = require(ParentParent.Components.CoreUI.CapturesCoreUI)
local CapturesDeactivated = require(ParentParent.Actions.CapturesDeactivated)
local CaptureServicePrompts = require(ParentParent.Components.CaptureService.CaptureServicePrompts)
local CapturesPage = require(ParentParent.Components.CoreUI.CapturesPage)
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local CarouselScreen = require(ParentParent.Components.CapturesCarousel.CarouselScreen)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local getLocalUserId = require(ParentParent.Utils.getLocalUserId)
local getUserIdsFromString = require(ParentParent.Utils.getUserIdsFromString)
local installReducer = require(ParentParent.installReducer)
local makeCaptureSavedHandler = require(ParentParent.Utils.makeCaptureSavedHandler)
local makeVideoCaptureInProgressHandler = require(ParentParent.Utils.makeVideoCaptureInProgressHandler)
local makeWrapWithProviders = require(ParentParent.Utils.makeWrapWithProviders)
local MenuClosed = require(ParentParent.Actions.MenuClosed)
local MenuOpened = require(ParentParent.Actions.MenuOpened)
local Networking = require(ParentParent.App.Networking)
local onToggleActivation = require(ParentParent.Utils.onToggleActivation)
local onViewportSizeChanged = CapturesCommon.Utils.onViewportSizeChanged
local CheckMomentsEligibility = require(ParentParent.Thunks.CheckMomentsEligibility)
local RetrieveCaptures = require(ParentParent.Thunks.RetrieveCaptures)
local ScreenSize = require(ParentParent.installReducer.ScreenSize)
local ScreenSizeChanged = require(ParentParent.Actions.ScreenSizeChanged)
local ServerType = require(ParentParent.installReducer.ServerType)
local ServerTypeDetected = require(ParentParent.Actions.ServerTypeDetected)
local setupFireEvent = require(ParentParent.Analytics.setupFireEvent)
local TakeCapture = require(ParentParent.Thunks.TakeCapture)

require(ParentParent.Types)

local FFlagCapturesVideoCaptureTriggerHandlerEnabled = require(ParentParent.Flags.FFlagCapturesVideoCaptureTriggerHandlerEnabled)
local FFlagCreateMomentsToast = require(ParentParent.Flags.FFlagCreateMomentsToast)
local FIntCapturesCoreGuiEventsPerMyriad = require(ParentParent.Flags.FIntCapturesCoreGuiEventsPerMyriad)
local EngineFeature = game:GetEngineFeature("SSUIMetaLua")

return {
	createApp = function(p1) -- line: 82
		-- upvalues: Dash (copy), AnalyticsService (copy), AppStorageService (copy), CaptureService (copy), LocalizationService (copy), NotificationService (copy), Players (copy), RbxAnalyticsService (copy), RobloxReplicatedStorage (copy), StarterGui (copy), setupFireEvent (copy), Constants (copy), getLocalUserId (copy), Rodux (copy), installReducer (copy), MomentsCreationFlow (copy), Networking (copy), ScreenSize (copy), ServerType (copy), RetrieveCaptures (copy), FFlagCreateMomentsToast (copy), CheckMomentsEligibility (copy), makeCaptureSavedHandler (copy), FFlagCapturesVideoCaptureTriggerHandlerEnabled (copy), makeVideoCaptureInProgressHandler (copy), getUserIdsFromString (copy), CapturesActivated (copy), CapturesDeactivated (copy), ServerTypeDetected (copy), MenuClosed (copy), MenuOpened (copy), TakeCapture (copy), FIntCapturesCoreGuiEventsPerMyriad (copy), EventNames (copy), CapturesCoreGuiEnabled (copy), CapturesCoreGuiDisabled (copy), Signal (copy), EngineFeature (copy), onViewportSizeChanged (copy), ScreenSizeChanged (copy), onToggleActivation (copy), makeWrapWithProviders (copy), CapturesPolicy (copy), React (copy), CaptureManagerScreen (copy), CaptureOverlay (copy), CarouselScreen (copy), CaptureServicePrompts (copy), CapturesCoreUI (copy), CapturesPage (copy), MomentsCreationFlowScreen (copy)
		local t1 = {}
		local v58 = Dash.join({
			AnalyticsService = AnalyticsService,
			AppStorageService = AppStorageService,
			CaptureService = CaptureService,
			LocalizationService = LocalizationService,
			NotificationService = NotificationService,
			Players = Players,
			RbxAnalyticsService = RbxAnalyticsService,
			RobloxReplicatedStorage = RobloxReplicatedStorage,
			StarterGui = StarterGui
		}, p1)
		local v59 = setupFireEvent({
			analytics = v58.AnalyticsService,
			infoForAllEvents = {
				isUnder13 = if not v58.Players.LocalPlayer then nil else v58.Players.LocalPlayer:GetUnder13(),
				pid = tostring(game.PlaceId),
				source = Constants.AnalyticsSource,
				uid = getLocalUserId(v58.Players),
				universeId = tostring(game.GameId)
			}
		})
		local v60 = Rodux.combineReducers({
			[Constants.RoduxKey] = installReducer(),
			[MomentsCreationFlow.Constants.RoduxKey] = MomentsCreationFlow.installReducer(),
			NetworkStatus = Networking.RoduxNetworking.installReducer(),
			ScreenSize = ScreenSize,
			ServerType = ServerType,
			ShareLinks = Networking.ShareLinksRodux.installReducer()
		})

		t1._store = Rodux.Store.new(v60, {}, { Rodux.thunkMiddleware })
		t1._store:dispatch(RetrieveCaptures())

		if FFlagCreateMomentsToast then
			t1._store:dispatch(CheckMomentsEligibility(game.GameId))
		end

		local v61 = makeCaptureSavedHandler(t1._store, v58, v59)

		v58.CaptureService.CaptureSavedInternal:Connect(v61)

		if FFlagCapturesVideoCaptureTriggerHandlerEnabled then
			local v62 = makeVideoCaptureInProgressHandler(t1._store, v58, v59)

			v58.CaptureService.VideoCaptureInProgress:Connect(v62)
		end

		v58.AppStorageService:WhenLoaded(function() -- line: 134
			-- upvalues: v58 (copy), Constants (copy), getUserIdsFromString (copy), getLocalUserId (copy), t1 (copy), CapturesActivated (copy), CapturesDeactivated (copy)
			local ok, result = pcall(function() -- line: 135
				-- upvalues: v58 (copy), Constants (copy)
				return v58.AppStorageService:GetItem(Constants.CapturesActiveLocalStorageKey)
			end)

			if ok and result ~= "" then
				if getUserIdsFromString(result)[getLocalUserId(v58.Players) or ""] then
					t1._store:dispatch(CapturesActivated())

					return
				end

				t1._store:dispatch(CapturesDeactivated())
			end
		end)
		task.spawn(function() -- line: 150
			-- upvalues: v58 (copy), t1 (copy), ServerTypeDetected (copy)
			local ok, result = pcall(function() -- line: 151
				-- upvalues: v58 (copy)
				return v58.RobloxReplicatedStorage:WaitForChild("GetServerType", 1e999):InvokeServer()
			end)

			if ok then
				t1._store:dispatch(ServerTypeDetected(result))
			end
		end)

		function t1.closeMenu() -- line: 160
			-- upvalues: t1 (copy), MenuClosed (copy)
			t1._store:dispatch(MenuClosed())
		end
		function t1.openMenu() -- line: 164
			-- upvalues: t1 (copy), MenuOpened (copy)
			t1._store:dispatch(MenuOpened())
		end
		function t1.takeCapture() -- line: 168
			-- upvalues: t1 (copy), TakeCapture (copy)
			t1._store:dispatch(TakeCapture())
		end

		local function maybeSendCoreGuiEvent(b1: boolean, b2: boolean) -- line: 172
			-- upvalues: FIntCapturesCoreGuiEventsPerMyriad (copy), v59 (copy), EventNames (copy)
			if FIntCapturesCoreGuiEventsPerMyriad == 0 then
				return
			end

			if Random.new():NextInteger(1, 10000) >= FIntCapturesCoreGuiEventsPerMyriad then
				return
			end

			if b2 then
				v59(EventNames.CapturesCoreGuiEnabled, {
					allTypeChanged = b1
				})

				return
			end

			v59(EventNames.CapturesCoreGuiDisabled, {
				allTypeChanged = b1
			})
		end

		v58.StarterGui.CoreGuiChangedSignal:Connect(function(p2, p3) -- line: 189
			-- upvalues: maybeSendCoreGuiEvent (copy), t1 (copy), CapturesCoreGuiEnabled (copy), CapturesCoreGuiDisabled (copy)
			if p2 ~= Enum.CoreGuiType.All and p2 ~= Enum.CoreGuiType.Captures then
				return
			end

			local v77 = p2 == Enum.CoreGuiType.All

			maybeSendCoreGuiEvent(v77, p3)

			if p3 then
				t1._store:dispatch(CapturesCoreGuiEnabled())

				return
			end

			t1._store:dispatch(CapturesCoreGuiDisabled())
		end)

		if v58.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures) then
			t1._store:dispatch(CapturesCoreGuiEnabled())
		else
			t1._store:dispatch(CapturesCoreGuiDisabled())
		end

		t1.onIsActiveChanged = Signal.new()

		function t1.getIsActive() -- line: 213
			-- upvalues: t1 (copy), Constants (copy)
			return t1._store:getState()[Constants.RoduxKey].IsActive or false
		end

		t1._store.changed:connect(function(p4, p5) -- line: 217
			-- upvalues: Constants (copy), v58 (copy), getUserIdsFromString (copy), getLocalUserId (copy), Dash (copy), t1 (copy)
			local IsActive = p5[Constants.RoduxKey].IsActive
			local IsActive2 = p4[Constants.RoduxKey].IsActive

			if IsActive2 ~= IsActive then
				pcall(function() -- line: 222
					-- upvalues: v58 (copy), Constants (copy), getUserIdsFromString (copy), getLocalUserId (copy), IsActive2 (copy), Dash (copy)
					local Item = v58.AppStorageService:GetItem(Constants.CapturesActiveLocalStorageKey)
					local v98 = getUserIdsFromString(Item)
					local v99 = getLocalUserId(v58.Players) or ""

					if IsActive2 then
						v98[v99] = true
					else
						v98[v99] = nil
					end

					local v100 = table.concat(Dash.keys(v98), ",")

					v58.AppStorageService:SetItem(Constants.CapturesActiveLocalStorageKey, v100)
					v58.AppStorageService:Flush()
				end)
				t1.onIsActiveChanged:fire(IsActive2)
			end
		end)

		if EngineFeature then
			pcall(function() -- line: 243
				-- upvalues: t1 (copy), Constants (copy)
				local SafetyService = game:GetService("SafetyService")

				t1._store.changed:connect(function(p6, p7) -- line: 245
					-- upvalues: Constants (copy), SafetyService (copy)
					local v103 = p6[Constants.RoduxKey]
					local v104 = p7[Constants.RoduxKey]
					local v105 = v104.IsMenuOpen or v104.Carousel and v104.Carousel.IsOpen
					local v106 = v103.IsMenuOpen or v103.Carousel and v103.Carousel.IsOpen

					if v106 and not v105 then
						pcall(function() -- line: 255
							-- upvalues: SafetyService (copy)
							SafetyService:ReportCapturesUIOpen()
						end)

						return
					end

					if not v106 and v105 then
						pcall(function() -- line: 259
							-- upvalues: SafetyService (copy)
							SafetyService:ReportCapturesUIClose()
						end)
					end
				end)
			end)
		end

		onViewportSizeChanged(function(vector2: Vector2) -- line: 267
			-- upvalues: t1 (copy), ScreenSizeChanged (copy)
			t1._store:dispatch(ScreenSizeChanged(vector2))
		end)

		function t1.onToggleActivationFromChrome(...) -- line: 271
			-- upvalues: t1 (copy), onToggleActivation (copy), v59 (copy), EventNames (copy)
			onToggleActivation(t1.getIsActive(), nil, v59, function(...) -- line: 272
				-- upvalues: t1 (copy)
				t1._store:dispatch(...)
			end, EventNames.CapturesActivatedChrome, EventNames.CapturesDeactivatedChrome)
		end

		local v64 = makeWrapWithProviders(t1._store, v58)
		local v65 = CapturesPolicy.PolicyImplementation.read()
		local v66 = not not v65 and CapturesPolicy.Mapper(v65).eligibleForCapturesFeature()
		local v67 = not not v65 and CapturesPolicy.Mapper(v65).enableCapturesBulkManagement()
		local t2 = {
			fireAnalyticsEvent = v59
		}

		function t1.mountCaptureManager(p8) -- line: 300
			-- upvalues: v67 (copy), v66 (copy), t1 (copy), v64 (copy), t2 (copy), React (copy), CaptureManagerScreen (copy)
			if not v67 then
				return
			end

			if not v66 then
				return
			end

			t1._captureManagerHandle = v64(p8, t2, {
				CaptureManager = React.createElement(CaptureManagerScreen)
			})
		end
		function t1.mountCaptureOverlay(p9) -- line: 312
			-- upvalues: v66 (copy), React (copy), CaptureOverlay (copy), t1 (copy), v64 (copy), t2 (copy)
			if not v66 then
				return
			end

			local t3 = {
				CaptureOverlay = React.createElement(CaptureOverlay)
			}

			t1._captureOverlayHandle = v64(p9, t2, t3)
		end
		function t1.mountCarousel(p10) -- line: 324
			-- upvalues: v66 (copy), React (copy), CarouselScreen (copy), t1 (copy), v64 (copy), t2 (copy)
			if not v66 then
				return
			end

			local t4 = {
				CarouselScreen = React.createElement(CarouselScreen)
			}

			t1._carouselHandle = v64(p10, t2, t4)
		end
		function t1.mountCoreUI(p11, b3: boolean?) -- line: 336
			-- upvalues: v66 (copy), v59 (copy), t1 (copy), v64 (copy), React (copy), CaptureServicePrompts (copy), CapturesCoreUI (copy)
			if not v66 then
				return
			end

			local t5 = {
				chromeEnabled = b3,
				fireAnalyticsEvent = v59
			}

			t1._coreUiHandle = v64(p11, t5, {
				CaptureServicePrompts = React.createElement(CaptureServicePrompts),
				CapturesCoreUI = React.createElement(CapturesCoreUI)
			}, "CapturesCoreUI")
		end
		function t1.mountMenuPage(p12, p13: ((...any) -> ...any), b4: boolean?) -- line: 352
			-- upvalues: v66 (copy), v59 (copy), t1 (copy), v64 (copy), React (copy), CapturesPage (copy)
			if not v66 then
				return
			end

			local t6 = {
				chromeEnabled = b4,
				fireAnalyticsEvent = v59
			}

			t1._menuPageHandle = v64(p12, t6, {
				CapturesPage = React.createElement(CapturesPage, {
					closeSettingsMenu = p13
				})
			})
		end
		function t1.mountMomentsCreationFlow(p14) -- line: 367
			-- upvalues: FFlagCreateMomentsToast (copy), v66 (copy), t1 (copy), v64 (copy), t2 (copy), React (copy), MomentsCreationFlowScreen (copy)
			if not FFlagCreateMomentsToast then
				return
			end

			if not v66 then
				return
			end

			t1._momentsCreationFlowHandle = v64(p14, t2, {
				MomentsCreationFlowScreen = React.createElement(MomentsCreationFlowScreen)
			})
		end

		return t1
	end
}
