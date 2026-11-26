local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
require("@game/CorePackages/Workspace/Packages/Navigation")

local androidTVExitButtonManager = require("@luauforge/bundled/dFB").AndroidTVExitButtonManager
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local selectCurrentRoactNavigationRoute = selectors.selectCurrentRoactNavigationRoute

local module = require("@luauforge/bundled/ecr")
local module2 = require("@luauforge/bundled/igR")
local module3 = require("@luauforge/bundled/iiK")
local module4 = require("@luauforge/bundled/iiL")
local module5 = require("@luauforge/bundled/fvN")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module6 = require("@luauforge/bundled/dFu")
local module7 = require("@luauforge/bundled/dGJ")
local module8 = require("@luauforge/bundled/ghP")
local module9 = require("@luauforge/bundled/ehB")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module11 = require("@luauforge/bundled/iiN")
local module12 = require("@luauforge/bundled/dKv")
local module13 = require("@luauforge/bundled/fCM")
local module14 = require("@luauforge/bundled/dzE")
local module15 = require("@luauforge/bundled/dFm")
local module16 = require("@luauforge/bundled/hUv")

local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").UniversalAppPolicy

local module17 = require("@luauforge/bundled/iiM")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagAndroidTVExitWithB = SharedFlags.FFlagAndroidTVExitWithB
local fFlagSignalsNavP3cEvents = SharedFlags.FFlagSignalsNavP3cEvents
local fFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup
local fFlagNavigationCallbackParam = SharedFlags.FFlagNavigationCallbackParam

local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/gfE").GetStartupStore else nil

local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local function notifySwitchedToAppShellFeature(object, p2)
	local v5 = module7[p2]
	object:SwitchedToAppShellFeature(v5 and v5.appShellReporterFeature or Enum.AppShellFeature.None)
end

local function getRouteName(p2)
	if p2 == nil then
		return nil
	end

	return p2.routeName
end

local function getRouteDetail(p2)
	if p2 == nil or p2.params == nil then
		return nil
	end

	return p2.params.detail
end

local function shouldEnableLuaAppUnloadEvent(): boolean
	return #module17() > 0
end

local function usePageLoadEvents()
	local v5 = useRoactService(module)
	local v6 = useRoactService(appNotificationService)

	local v7 = useSelector(selectCurrentRoactNavigationRoute)
	local routeName = if v7 ~= nil then v7.routeName else nil

	local detail = if not (v7 == nil or v7.params == nil) then v7.params.detail else nil

	local state, setState = React.useState(os.clock())

	local v8 = React.useMemo(function()
		if #module17() > 0 then
			return module2.new()
		end

		return nil
	end, {})

	React.useEffect(function()
		if v8 == nil then
			return
		end

		local v9 = v8:onLaunched(function(p2)
			local now = os.clock()
			module4(v5, "AppRouter", routeName, detail, {
				nextPage = "Experience",
				nextDetail = p2.placeId,
				timeOnPage = now - state
			})

			setState(now)
		end)

		local v10 = v8:onLeft(function(p2)
			module3(v5, "AppRouter", routeName, detail, {
				previousPage = "Experience",
				previousDetail = p2.placeId
			})

			setState(os.clock())
		end)

		return function()
			v9:disconnect()
			v10:disconnect()
		end
	end, { v8, v5, routeName, detail })

	local ref = React.useRef(nil)

	React.useEffect(function()
		local current = ref.current
		local routeName2 = if current ~= nil then current.routeName else nil

		local current2 = ref.current
		local detail2 = if not (current2 == nil or current2.params == nil) then current2.params.detail else nil

		module3(v5, "AppRouter", routeName, detail, {
			previousPage = routeName2,
			previousDetail = detail2
		})

		local now = os.clock()

		if ref.current ~= nil then
			module4(v5, "AppRouter", routeName2, detail2, {
				nextPage = routeName,
				nextDetail = detail,
				timeOnPage = now - state
			})
		end

		ref.current = v7
		local v10 = module7[routeName]
		v6:SwitchedToAppShellFeature(v10 and v10.appShellReporterFeature or Enum.AppShellFeature.None)

		setState(now)
	end, { routeName, detail })
end

local function usePageLoadEventsWithSignals()
	local v5 = useRoactService(module)
	local v6 = useRoactService(appNotificationService)
	local legacyNavigationStore = getLegacyNavigationStore(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(os.clock())

	local v7 = React.useMemo(function()
		if #module17() > 0 then
			return module2.new()
		end

		return nil
	end, {})

	React.useEffect(function()
		if v7 == nil then
			return nil
		end

		local v8 = v7:onLaunched(function(p2)
			local now = os.clock()
			local current = ref.current
			local routeName = if current ~= nil then current.routeName else nil

			local v12 = if current ~= nil and current.params ~= nil then current.params.detail else nil

			module4(v5, "AppRouter", routeName, v12, {
				nextPage = "Experience",
				nextDetail = p2.placeId,
				timeOnPage = now - ref2.current
			})

			ref2.current = now
		end)

		local v9 = v7:onLeft(function(p2)
			local current = ref.current
			local routeName = if current ~= nil then current.routeName else nil

			local v13 = if current ~= nil and current.params ~= nil then current.params.detail else nil

			module3(v5, "AppRouter", routeName, v13, {
				previousPage = "Experience",
				previousDetail = p2.placeId
			})

			ref2.current = os.clock()
		end)

		return function()
			v8:disconnect()
			v9:disconnect()
		end
	end, { v7, v5 })

	React.useEffect(function()
		local v8 = nil
		local heartbeatConnection = nil

		local function flush()
			heartbeatConnection = nil
			local current = ref.current
			local v9 = v8
			local routeName = if v9 ~= nil then v9.routeName else nil

			local v10 = v8
			local detail = if not (v10 == nil or v10.params == nil) then v10.params.detail else nil
			local routeName2 = if current ~= nil then current.routeName else nil

			local detail2 = if not (current == nil or current.params == nil) then current.params.detail else nil

			ref.current = v8

			if current ~= nil and routeName == routeName2 and detail == detail2 then
				return
			end

			module3(v5, "AppRouter", routeName, detail, {
				previousPage = routeName2,
				previousDetail = detail2
			})

			local now = os.clock()

			if current ~= nil then
				module4(v5, "AppRouter", routeName2, detail2, {
					nextPage = routeName,
					nextDetail = detail,
					timeOnPage = now - ref2.current
				})
			end

			local v12 = module7[routeName]
			v6:SwitchedToAppShellFeature(v12 and v12.appShellReporterFeature or Enum.AppShellFeature.None)

			ref2.current = now
		end

		local effect = Signals.createEffect(function(p2)
			v8 = legacyNavigationStore.getCurrentRoute(p2)

			if heartbeatConnection == nil then
				heartbeatConnection = RunService.Heartbeat:Once(flush)
			end
		end)

		if heartbeatConnection ~= nil then
			heartbeatConnection:Disconnect()
			flush()
		end

		return function()
			effect()

			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end
	end, { v5, v6, legacyNavigationStore })
end

local extended = React.Component:extend("NavigationEventReceiver")

function extended:handleBackButtonPressed()
	local v5

	if fFlagSignalsNavP3cEvents then
		v5 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	else
		v5 = self.props.currentRoute
	end

	local count = #v5
	local name = v5[1].name
	local name2 = v5[count].name

	if
		name == module6.Chat
		and name2 ~= module6.GameDetail
		and (fFlagShareTargetGameCleanup or name2 ~= module6.ShareGameToChat)
		or module7[name2] and module7[name2].disableBackButton
	then
		return
	end

	if self.props.centralOverlayType then
		if not self.props.centralOverlayDisableBackButtonClose then
			self.props.closeCentralOverlay()
		end
	else
		if not (count > 1) then
			GuiService:BroadcastNotification("", module5.BACK_BUTTON_NOT_CONSUMED)

			return
		end

		if fFlagNavigationCallbackParam and require("@luauforge/bundled/fHW").runOnHardwareBack(v5[count]) then
			return
		end

		self.props.navigateBack()
	end
end

function extended:init()
	local robloxEventReceiver = self.props.RobloxEventReceiver

	function self.getShouldBlockDeeplink(): boolean
		return not (self.props.getCanSeeChatTab and self.props.getCanSeeChatTab())
	end

	if fFlagAndroidTVExitWithB then
		self.tvExitDisconnect = androidTVExitButtonManager.register(function()
			self:handleBackButtonPressed()
		end)
	end

	self.tokens = {
		robloxEventReceiver:observeEvent("Navigations", function(p2, p3)
			if p3 == "Destination" or p3 == "Reload" then
				if p2.appName == module6.ShareGameToChat then
					self.props.navigateDown({
						name = module6.ShareGameToChat,
						detail = p2.parameters.placeId
					})
				elseif p2.appName == module6.Chat then
					if self.getShouldBlockDeeplink() then
						return
					end

					self.props.setPage({
						name = module6.Chat,
						detail = p2.parameters and p2.parameters.conversationId
					})
				elseif p2.appName == avatarScreen.AvatarEditor then
					self.props.resetNavigationHistory({
						{
							{ name = avatarScreen.AvatarExperienceLandingPage }
						},
						{
							{ name = avatarScreen.AvatarExperienceLandingPage },
							{ name = avatarScreen.AvatarEditor }
						}
					})
				else
					self.props.setPage({
						name = module6[p2.appName] or module6.None
					})
				end
			end
		end),
		GuiService.ShowLeaveConfirmation:Connect(function()
			self:handleBackButtonPressed()
		end),
		robloxEventReceiver:observeEvent("AppShellNotifications", function(p2, p3)
			if p3 == "StartConversationWithUserId" then
				if self.getShouldBlockDeeplink() then
					return
				end

				self.props.navigateIntoChat({ userId = p2 })
			elseif p3 == "StartConversationWithId" then
				if self.getShouldBlockDeeplink() then
					return
				end

				self.props.navigateIntoChat({ conversationId = p2 })
			elseif p3 == "Preloading" then
				local v5 = p2 == "true"
				self.props.setPreloading(v5)
			end
		end),
		robloxEventReceiver:observeEvent("QrCodeScanResult", function(p2, p3)
			if p3 == "Cancelled" then
				self.props.navigateBack()
				return
			end

			self.props.navigateBack()
			self.props.setCurrentToast({
				toastMessage = "Feature.Toast.ScanQrCodeError.UnrecognizableQrCode",
				toastType = module14.NetworkingError
			})
		end)
	}
end

function extended.render(p2) end

function extended:willUnmount()
	for k, token in pairs(self.tokens) do
		token:disconnect()
	end

	if fFlagAndroidTVExitWithB and self.tvExitDisconnect then
		self.tvExitDisconnect()
		self.tvExitDisconnect = nil
	end
end

local v5 = RoactRodux.connect(function(p2, p3)
	local v7

	if not fFlagSignalsNavP3cEvents then
		if fFlagUseNavigationSelectors then
			v7 = selectors.selectCurrentLegacyRoute(p2)
		else
			v7 = p2.Navigation.history[#p2.Navigation.history]
		end
	end

	return {
		currentRoute = v7,
		centralOverlayType = p2.CentralOverlay.OverlayType,
		centralOverlayDisableBackButtonClose = p2.CentralOverlay.Configs.DisableBackButtonClose
	}
end, function(callback)
	return {
		setPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.to(navigationCommands.fromLegacyPage(p2), true)
			end

			return callback(module8({ p2 }, true))
		end,
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2), true)
			end

			return callback(module9(p2, true))
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back(true)
			end

			return callback(RobloxAppToastsRodux(true))
		end,
		closeCentralOverlay = function()
			callback(module13())
		end,
		resetNavigationHistory = function(p2)
			return callback(module12(nil, p2))
		end,
		setCurrentToast = function(p2)
			callback(module15(p2))
		end,
		navigateIntoChat = function(p2)
			return callback(module11(p2, false))
		end,
		setPreloading = function(p2)
			if fFlagUseSignalsForStartup then
				getStartupStore(false).setPreloading(p2)
			else
				callback(module16(p2))
			end
		end
	}
end)(extended)

local v6 = universalAppPolicy.connect(function(p2)
	return { getCanSeeChatTab = p2.getCanSeeChatTab }
end)(v5)

local function NavigationEventReceiverWrapper(p2)
	if fFlagSignalsNavP3cEvents then
		usePageLoadEventsWithSignals()
	else
		usePageLoadEvents()
	end

	return React.createElement(v6, p2)
end

return NavigationEventReceiverWrapper
