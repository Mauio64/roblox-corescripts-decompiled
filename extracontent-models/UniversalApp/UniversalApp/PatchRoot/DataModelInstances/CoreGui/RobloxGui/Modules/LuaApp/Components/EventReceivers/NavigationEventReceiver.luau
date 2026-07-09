local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService

require(CorePackages.Workspace.Packages.Navigation)

local AndroidTVExitButtonManager = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AndroidTVExitButtonManager
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local selectCurrentRoactNavigationRoute = Selectors.selectCurrentRoactNavigationRoute
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local ExperienceEventReceiver = require(Modules.LuaApp.ExperienceEventReceiver)
local luaPageLoad = require(Modules.LuaApp.Analytics.Events.luaPageLoad)
local luaPageUnload = require(Modules.LuaApp.Analytics.Events.luaPageUnload)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AppPage = require(Modules.LuaApp.AppPage)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local NavigateToRoute = require(Modules.LuaApp.Thunks.NavigateToRoute)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local NavigateIntoChatThunk = require(CorePackages.Workspace.Packages.AppChat.NavigateIntoChatThunk)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetPreloading = require(Modules.LuaApp.Actions.SetPreloading)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).UniversalAppPolicy
local GetFStringLuaAppUnloadEventEnabledPageNames = require(Modules.LuaApp.Flags.GetFStringLuaAppUnloadEventEnabledPageNames)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagAndroidTVExitWithB = SharedFlags.FFlagAndroidTVExitWithB
local FFlagSignalsNavP3cEvents = SharedFlags.FFlagSignalsNavP3cEvents
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v38 = if not FFlagSignalsNavP3cEvents then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v40 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function notifySwitchedToAppShellFeature(p1, p2) -- line: 58
	-- upvalues: AppPageProperties (copy)
	local v54 = AppPageProperties[p2]

	p1:SwitchedToAppShellFeature(v54 and v54.appShellReporterFeature or Enum.AppShellFeature.None)
end
local function getRouteName(p3) -- line: 67
	if p3 ~= nil then
		return p3.routeName
	end

	return nil
end
local function getRouteDetail(p4) -- line: 71
	if p4 ~= nil and p4.params ~= nil then
		return p4.params.detail
	end

	return nil
end
local function shouldEnableLuaAppUnloadEvent() -- line: 75
	-- upvalues: GetFStringLuaAppUnloadEventEnabledPageNames (copy)
	return #GetFStringLuaAppUnloadEventEnabledPageNames() > 0
end
local function usePageLoadEvents() -- line: 80
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), AppNotificationService (copy), useSelector (copy), selectCurrentRoactNavigationRoute (copy), React (copy), GetFStringLuaAppUnloadEventEnabledPageNames (copy), ExperienceEventReceiver (copy), luaPageUnload (copy), luaPageLoad (copy), AppPageProperties (copy)
	local v57 = useRoactService(AppEventIngestService)
	local v58 = useRoactService(AppNotificationService)
	local v59 = useSelector(selectCurrentRoactNavigationRoute)
	local v60 = if v59 == nil then nil else v59.routeName
	local v61 = if v59 == nil or v59.params == nil then nil else v59.params.detail
	local v62, v63 = React.useState(os.clock())
	local v64 = React.useMemo(function() -- line: 90
		-- upvalues: GetFStringLuaAppUnloadEventEnabledPageNames (copy), ExperienceEventReceiver (copy)
		if #GetFStringLuaAppUnloadEventEnabledPageNames() > 0 then
			return ExperienceEventReceiver.new()
		end

		return nil
	end, {})

	React.useEffect(function() -- line: 97
		-- upvalues: v64 (copy), luaPageUnload (copy), v57 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (copy), luaPageLoad (copy)
		if v64 ~= nil then
			local v84 = v64:onLaunched(function(p5) -- line: 99
				-- upvalues: luaPageUnload (copy), v57 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (copy)
				local elapsed = os.clock()

				luaPageUnload(v57, "AppRouter", v60, v61, {
					nextPage = "Experience",
					nextDetail = p5.placeId,
					timeOnPage = elapsed - v62
				})
				v63(elapsed)
			end)
			local v85 = v64:onLeft(function(p6) -- line: 109
				-- upvalues: luaPageLoad (copy), v57 (copy), v60 (copy), v61 (copy), v63 (copy)
				luaPageLoad(v57, "AppRouter", v60, v61, {
					previousPage = "Experience",
					previousDetail = p6.placeId
				})
				v63(os.clock())
			end)

			return function() -- line: 117
				-- upvalues: v84 (copy), v85 (copy)
				v84:disconnect()
				v85:disconnect()
			end
		end
	end, {
		v64,
		v57,
		v60,
		v61
	})

	local v65 = React.useRef(nil)

	React.useEffect(function() -- line: 126
		-- upvalues: v65 (copy), luaPageLoad (copy), v57 (copy), v60 (copy), v61 (copy), luaPageUnload (copy), v62 (copy), v59 (copy), v58 (copy), AppPageProperties (copy), v63 (copy)
		local current = v65.current
		local v87 = if current == nil then nil else current.routeName
		local current2 = v65.current
		local v89 = if current2 == nil or current2.params == nil then nil else current2.params.detail

		luaPageLoad(v57, "AppRouter", v60, v61, {
			previousPage = v87,
			previousDetail = v89
		})

		local elapsed = os.clock()

		if v65.current ~= nil then
			luaPageUnload(v57, "AppRouter", v87, v89, {
				nextPage = v60,
				nextDetail = v61,
				timeOnPage = elapsed - v62
			})
		end

		v65.current = v59

		local v91 = v58
		local v92 = AppPageProperties[v60]

		v91:SwitchedToAppShellFeature(v92 and v92.appShellReporterFeature or Enum.AppShellFeature.None)
		v63(elapsed)
	end, {
		v60,
		v61
	})
end

local v46 = React.Component:extend("NavigationEventReceiver")

function v46.handleBackButtonPressed(p7) -- line: 149
	-- upvalues: AppPage (copy), FFlagShareTargetGameCleanup (copy), AppPageProperties (copy), GuiService (copy), NotificationType (copy)
	local v67 = #p7.props.currentRoute
	local name = p7.props.currentRoute[1].name
	local name2 = p7.props.currentRoute[v67].name

	if name == AppPage.Chat and (name2 ~= AppPage.GameDetail and (not not FFlagShareTargetGameCleanup or name2 ~= AppPage.ShareGameToChat)) then
		return
	end

	if AppPageProperties[name2] and AppPageProperties[name2].disableBackButton then
		return
	end

	if p7.props.centralOverlayType then
		if not p7.props.centralOverlayDisableBackButtonClose then
			p7.props.closeCentralOverlay()
		end

		return
	end

	if v67 > 1 then
		p7.props.navigateBack()

		return
	end

	GuiService:BroadcastNotification("", NotificationType.BACK_BUTTON_NOT_CONSUMED)
end
function v46.init(p8) -- line: 194
	-- upvalues: FFlagAndroidTVExitWithB (copy), AndroidTVExitButtonManager (copy), AppPage (copy), AvatarScreen (copy), GuiService (copy), ToastType (copy)
	local RobloxEventReceiver = p8.props.RobloxEventReceiver

	function p8.getShouldBlockDeeplink() -- line: 197
		-- upvalues: p8 (copy)
		return not (p8.props.getCanSeeChatTab and p8.props.getCanSeeChatTab())
	end

	if FFlagAndroidTVExitWithB then
		p8.tvExitDisconnect = AndroidTVExitButtonManager.register(function() -- line: 202
			-- upvalues: p8 (copy)
			p8:handleBackButtonPressed()
		end)
	end

	p8.tokens = {
		RobloxEventReceiver:observeEvent("Navigations", function(p9, p10) -- line: 208
			-- upvalues: AppPage (copy), p8 (copy), AvatarScreen (copy)
			if p10 == "Destination" or p10 == "Reload" then
				if p9.appName == AppPage.ShareGameToChat then
					p8.props.navigateDown({
						name = AppPage.ShareGameToChat,
						detail = p9.parameters.placeId
					})

					return
				end

				if p9.appName == AppPage.Chat then
					if p8.getShouldBlockDeeplink() then
						return
					end

					p8.props.setPage({
						name = AppPage.Chat,
						detail = p9.parameters and p9.parameters.conversationId
					})

					return
				end

				if p9.appName == AvatarScreen.AvatarEditor then
					p8.props.resetNavigationHistory({
						{{
							name = AvatarScreen.AvatarExperienceLandingPage
						}},
						{
							{
								name = AvatarScreen.AvatarExperienceLandingPage
							},
							{
								name = AvatarScreen.AvatarEditor
							}
						}
					})

					return
				end

				p8.props.setPage({
					name = AppPage[p9.appName] or AppPage.None
				})
			end
		end),
		GuiService.ShowLeaveConfirmation:Connect(function() -- line: 240
			-- upvalues: p8 (copy)
			p8:handleBackButtonPressed()
		end),
		RobloxEventReceiver:observeEvent("AppShellNotifications", function(p11, p12) -- line: 244
			-- upvalues: p8 (copy)
			if p12 == "StartConversationWithUserId" then
				if p8.getShouldBlockDeeplink() then
					return
				end

				p8.props.navigateIntoChat({
					userId = p11
				})

				return
			end

			if p12 == "StartConversationWithId" then
				if p8.getShouldBlockDeeplink() then
					return
				end

				p8.props.navigateIntoChat({
					conversationId = p11
				})

				return
			end

			if p12 == "Preloading" then
				local v97 = p11 == "true"

				p8.props.setPreloading(v97)
			end
		end),
		RobloxEventReceiver:observeEvent("QrCodeScanResult", function(_, p14) -- line: 266
			-- upvalues: p8 (copy), ToastType (copy)
			if p14 == "Cancelled" then
				p8.props.navigateBack()

				return
			end

			p8.props.navigateBack()
			p8.props.setCurrentToast({
				toastMessage = "Feature.Toast.ScanQrCodeError.UnrecognizableQrCode",
				toastType = ToastType.NetworkingError
			})
		end)
	}
end
function v46.render(_) -- line: 281
end
function v46.willUnmount(p16) -- line: 283
	-- upvalues: FFlagAndroidTVExitWithB (copy)
	for _, v in pairs(p16.tokens) do
		v:disconnect()
	end

	if FFlagAndroidTVExitWithB and p16.tvExitDisconnect then
		p16.tvExitDisconnect()
		p16.tvExitDisconnect = nil
	end
end

local v47 = RoactRodux.connect(function(p17, _) -- line: 293
	-- upvalues: FFlagSignalsNavP3cEvents (copy), FFlagUseNavigationSelectors (copy), Selectors (copy)
	return {
		currentRoute = if not FFlagSignalsNavP3cEvents then if not FFlagUseNavigationSelectors then p17.Navigation.history[#p17.Navigation.history] else Selectors.selectCurrentLegacyRoute(p17) else nil,
		centralOverlayType = p17.CentralOverlay.OverlayType,
		centralOverlayDisableBackButtonClose = p17.CentralOverlay.Configs.DisableBackButtonClose
	}
end, function(p19) -- line: 302
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v40 (copy), NavigateToRoute (copy), NavigateDown (copy), NavigateBack (copy), CloseCentralOverlay (copy), ResetNavigationHistory (copy), SetCurrentToastMessage (copy), NavigateIntoChatThunk (copy), SetPreloading (copy)
	return {
		setPage = function(p20) -- line: 304
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v40 (copy), p19 (copy), NavigateToRoute (copy)
			if FFlagSignalsNavP3Dispatch then
				return v40.to(v40.fromLegacyPage(p20), true)
			end

			return p19(NavigateToRoute({ p20 }, true))
		end,
		navigateDown = function(p21) -- line: 312
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v40 (copy), p19 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v40.down(v40.fromLegacyPage(p21), true)
			end

			return p19(NavigateDown(p21, true))
		end,
		navigateBack = function() -- line: 319
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v40 (copy), p19 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v40.back(true)
			end

			return p19(NavigateBack(true))
		end,
		closeCentralOverlay = function() -- line: 326
			-- upvalues: p19 (copy), CloseCentralOverlay (copy)
			p19(CloseCentralOverlay())
		end,
		resetNavigationHistory = function(p22) -- line: 329
			-- upvalues: p19 (copy), ResetNavigationHistory (copy)
			return p19(ResetNavigationHistory(nil, p22))
		end,
		setCurrentToast = function(p23) -- line: 332
			-- upvalues: p19 (copy), SetCurrentToastMessage (copy)
			p19(SetCurrentToastMessage(p23))
		end,
		navigateIntoChat = function(p24) -- line: 335
			-- upvalues: p19 (copy), NavigateIntoChatThunk (copy)
			return p19(NavigateIntoChatThunk(p24, false))
		end,
		setPreloading = function(p25) -- line: 338
			-- upvalues: p19 (copy), SetPreloading (copy)
			p19(SetPreloading(p25))
		end
	}
end)(v46)

if FFlagSignalsNavP3cEvents then
	local Cryo = require(CorePackages.Packages.Cryo)
	local v49 = v47

	function v47(p26) -- line: 347
		-- upvalues: v38 (copy), useSignalState (copy), React (copy), v49 (copy), Cryo (copy)
		local v80 = v38(false)
		local v81 = useSignalState(v80.getCurrentLegacyRoute)

		return React.createElement(v49, Cryo.Dictionary.union(p26, {
			currentRoute = v81
		}))
	end
end

local u50 = UniversalAppPolicy.connect(function(p27) -- line: 359
	return {
		getCanSeeChatTab = p27.getCanSeeChatTab
	}
end)(v47)

local function NavigationEventReceiverWrapper(p28) -- line: 365
	-- upvalues: usePageLoadEvents (copy), React (copy), u50 (ref)
	usePageLoadEvents()

	return React.createElement(u50, p28)
end

return NavigationEventReceiverWrapper
