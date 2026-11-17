local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome.Enums.SideSheetPlacement

local Signal = AppCommonLib.Signal
local FocusUtils = Chrome.FocusUtils
local FocusOnChromeSignal = FocusUtils.FocusOnChromeSignal
local FocusOffChromeSignal = FocusUtils.FocusOffChromeSignal
local ChromeUtils = require(ChromeShared.Service.ChromeUtils)
local LocalStore = require(ChromeShared.Service.LocalStore)
local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local WindowSizeSignal = require(ChromeShared.Service.WindowSizeSignal)
local ObservableValue = ChromeUtils.ObservableValue
local NotifySignal = ChromeUtils.NotifySignal
local AvailabilitySignal = ChromeUtils.AvailabilitySignal
local Constants = require(ChromeShared.Unibar.Constants)
local ShortcutService = require(ChromeShared.Service.ShortcutService)

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local FFlagIntegrationsChromeShortcutTelemetry = require(ChromeShared.Parent.Flags.FFlagIntegrationsChromeShortcutTelemetry)
local defineFastFlag = game:DefineFastFlag("ChromeDeprecateMRUs", false)
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagEnableSideSheetWidgets = SharedFlags.FFlagEnableSideSheetWidgets
local FFlagSideSheetUnifiedMenuOrder = SharedFlags.FFlagSideSheetUnifiedMenuOrder
local Flags = require(ChromeShared.Flags)
local FFlagEnableChromeWindowsNotInMenu = Flags.FFlagEnableChromeWindowsNotInMenu
local Flags2 = require(ChromeShared.Flags)
local FFlagChromeNineDotActivityIndicator = Flags2.FFlagChromeNineDotActivityIndicator

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility
local registerSideSheetIntegrations = InExperienceSideSheet.registerSideSheetIntegrations

local ChromeService = {}
ChromeService.__index = ChromeService

ChromeService.AvailabilitySignal = ChromeUtils.AvailabilitySignalState
ChromeService.IntegrationStatus = { None = 0, Icon = 1, Window = 2 }

function noop() end

local integration2 = {
	id = "div",
	label = "div",
	initialAvailability = ChromeService.AvailabilitySignal.Unavailable,
	availability = AvailabilitySignal.new(ChromeService.AvailabilitySignal.Unavailable),
	notification = NotifySignal.new(),
	components = {},
	hideNotificationCountWhileOpen = false,
	sideSheetPlacement = 0
}
local sideSheetPlacement

if isSideSheetEnabled then
	sideSheetPlacement = SideSheetPlacement.None
end

integration2.sideSheetPlacement = sideSheetPlacement

function createUnibarLayoutInfo(vector2: Vector2, vector2_2: Vector2)
	return Rect.new(vector2, vector2 + vector2_2)
end

function ChromeService.new()
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v = {}
	local shortcutService

	if FFlagEnableConsoleExpControls then
		shortcutService = ShortcutService.new()
	end

	v._shortcutService = shortcutService

	v._layout = ChromeUtils.ObservableValue.new(createUnibarLayoutInfo(Vector2.zero, Vector2.zero))
	v._menuAbsolutePosition = Vector2.zero
	v._menuAbsoluteSizeOpen = Vector2.zero
	v._currentSubMenu = ChromeUtils.ObservableValue.new(nil)
	v._selectedItem = ChromeUtils.ObservableValue.new(nil)
	v._selectedItemIdx = 0
	v._integrations = {}
	v._integrationsConnections = {}
	v._integrationsStatus = {}
	v._menuConfig = {}
	v._subMenuConfig = {}
	v._subMenuNotifications = {}
	v._menuList = ObservableValue.new({})
	v._windowList = ObservableValue.new({})
	v._dragConnection = {}
	v._windowPositions = ObservableValue.new({})
	v._totalNotifications = NotifySignal.new(true)
	v._mostRecentlyUsedAndPinnedLimit = -1
	v._localization = Localization.new(robloxLocaleId)
	v._localizedLabelKeys = {}
	v._currentShortcutBar = ObservableValue.new(nil)

	v._notificationIndicator = ObservableValue.new(nil)
	local nineDotActivityIndicatorVisible

	if FFlagChromeNineDotActivityIndicator then
		nineDotActivityIndicatorVisible = ObservableValue.new(false)
	end

	v._nineDotActivityIndicatorVisible = nineDotActivityIndicatorVisible

	v._nineDotActivityIndicatorKeys = FFlagChromeNineDotActivityIndicator and {} or nil
	v._orderAlignment = ObservableValue.new(Enum.HorizontalAlignment.Left)

	v._onIntegrationRegistered = Signal.new()
	v._onIntegrationActivated = Signal.new()
	v._onIntegrationStatusChanged = Signal.new()
	v._onIntegrationHovered = Signal.new()
	v._triggerMenuIcon = Signal.new()
	local triggerVRToggleButton

	if isInExperienceUIVREnabled then
		triggerVRToggleButton = Signal.new()
	end

	v._triggerVRToggleButton = triggerVRToggleButton
	local topBarVisibility

	if isInExperienceUIVREnabled then
		topBarVisibility = ObservableValue.new(nil)
	end

	v._topBarVisibility = topBarVisibility

	v._inFocusNav = ObservableValue.new(false)

	local object = setmetatable(v, ChromeService)

	ViewportUtil.viewport:connect(function(data)
		if defineFastFlag then
			object:updateWindowSizeSignals()
		else
			object:updateScreenSize(data.size, data.isMobileDevice, data.portraitOrientation, data.tinyPortrait)
		end
	end, true)

	if FFlagEnableConsoleExpControls then
		v._shortcutService.onShortcutBarChanged:connect(function(p)
			object._currentShortcutBar:set(p)
		end)
	end

	if FFlagChromeNineDotActivityIndicator then
		v._currentSubMenu:connect(function()
			object:updateNineDotActivityIndicatorVisible()
		end)
	end

	FocusOnChromeSignal:connect(function(p)
		if p and not v._subMenuConfig.nine_dot[p] then
			object:setSelected(p)
		end

		object:enableFocusNav()
	end)
	FocusOffChromeSignal:connect(function()
		object:disableFocusNav()

		if FFlagEnableConsoleExpControls then
			object:setShortcutBar(nil)
		end
	end)

	return object
end

function ChromeService:storeChromeInteracted()
	if LocalStore.isEnabled() then
		LocalStore.storeForLocalPlayer("ChromeInteracted3", true)
	end
end

function ChromeService:updateScreenSize(_: Vector2, flag: boolean, flag2: boolean, flag3: boolean)
	local mostRecentlyUsedAndPinnedLimit

	if flag then
		if flag3 then
			mostRecentlyUsedAndPinnedLimit = Constants.MOBILE_TINY_PORTRAIT_SLOTS - Constants.CORE_SLOTS
		elseif flag2 then
			mostRecentlyUsedAndPinnedLimit = Constants.MOBILE_PORTRAIT_SLOTS - Constants.CORE_SLOTS
		else
			mostRecentlyUsedAndPinnedLimit = Constants.MOBILE_LANDSCAPE_SLOTS - Constants.CORE_SLOTS
		end
	else
		mostRecentlyUsedAndPinnedLimit = Constants.NON_MOBILE_SLOTS - Constants.CORE_SLOTS
	end

	if mostRecentlyUsedAndPinnedLimit ~= self._mostRecentlyUsedAndPinnedLimit then
		self._mostRecentlyUsedAndPinnedLimit = mostRecentlyUsedAndPinnedLimit

		self:updateMenuList()
		self:updateNotificationTotals()
	end

	self:updateWindowSizeSignals()
end

function ChromeService:updateWindowSizeSignals()
	for _, integration in self._integrations do
		if integration.windowSize then
			integration.windowSize:updateConstraints()
		end
	end
end

function ChromeService:notificationIndicator()
	return self._notificationIndicator
end

function ChromeService:nineDotActivityIndicatorVisible()
	return self._nineDotActivityIndicatorVisible
end

function ChromeService:setNineDotActivityIndicatorVisible(p: string, flag: boolean)
	self._nineDotActivityIndicatorKeys[p] = flag and true or nil
	self:updateNineDotActivityIndicatorVisible()
end

function ChromeService:updateNineDotActivityIndicatorVisible()
	local v = next(self._nineDotActivityIndicatorKeys) ~= nil

	if self._currentSubMenu:get() == "nine_dot" then
		v = false
	end

	self._nineDotActivityIndicatorVisible:set(v)
end

function ChromeService:toggleSubMenu(p)
	if isSideSheetEnabled and toggleSideSheet then
		toggleSideSheet(true)
	elseif not self._subMenuConfig[p] then
		warn("Not a valid subMenuId:" .. p)
	elseif self._currentSubMenu:get() == p then
		self._currentSubMenu:set(nil)
	else
		self._currentSubMenu:set(p)
	end
end

function ChromeService:currentSubMenu()
	return self._currentSubMenu
end

function ChromeService:inFocusNav()
	return self._inFocusNav
end

function ChromeService:enableFocusNav()
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if not self._inFocusNav:get() then
		self._inFocusNav:set(true)
	end

	if FFlagEnableConsoleExpControls then
		self:setShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID)
	end
end

function ChromeService:disableFocusNav()
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if self._inFocusNav:get() then
		self._inFocusNav:set(false)
		self._selectedItem:set(nil)

		self._currentSubMenu:set(nil)
	end
end

function ChromeService:toggleWindow(p)
	if self._integrations[p].components.Window then
		if
			self._integrationsStatus[p]
			and self._integrationsStatus[p] ~= ChromeService.IntegrationStatus.None
			and self._integrationsStatus[p] ~= ChromeService.IntegrationStatus.Icon
		then
			self._integrationsStatus[p] = ChromeService.IntegrationStatus.Icon
		else
			self._integrationsStatus[p] = ChromeService.IntegrationStatus.Window
		end

		self._onIntegrationStatusChanged:fire(p, self._integrationsStatus[p])
	end

	if LocalStore.isEnabled() and self._integrations[p] and self._integrations[p].persistWindowState then
		local v = LocalStore.loadForLocalPlayer("ChromeWindowStatus") or {}
		v[p] = self._integrationsStatus[p] == ChromeService.IntegrationStatus.Window
		LocalStore.storeForLocalPlayer("ChromeWindowStatus", v)
	end

	self:updateMenuList()
end

function ChromeService:isWindowOpen(p)
	return self._integrations[p].components.Window
		and self._integrationsStatus[p] == ChromeService.IntegrationStatus.Window
end

function ChromeService:menuList()
	return self._menuList
end

function ChromeService:windowList()
	return self._windowList
end

function ChromeService:dragConnection(p)
	if self._integrations[p] then
		return self._dragConnection[p]
	end

	return nil
end

function ChromeService:updateLocalization(state)
	self._localizedLabelKeys[state.id] = {}

	self._localizedLabelKeys[state.id].label = state.label
	local label = state.label
	local success, result = pcall(function()
		label = self._localization:Format(label)
	end)

	if not success then
		label = state.label
		warn(result)
	end

	state.label = label

	if not state.secondaryAction then
		return state
	end

	self._localizedLabelKeys[state.id].secondaryActionLabel = state.secondaryAction.label
	local label2 = state.secondaryAction.label
	local success2, result2 = pcall(function()
		label2 = self._localization:Format(label2)
	end)

	if not success2 then
		label2 = state.secondaryAction.label
		warn(result2)
	end

	state.secondaryAction.label = label2

	return state
end

function ChromeService:register(state)
	if self._integrations[state.id] then
		warn(string.format(state.id .. "already registered", debug.traceback()))

		for _, v in self._integrationsConnections[state.id] do
			v:disconnect()
		end
	end

	self._integrationsConnections[state.id] = {}
	local connections = self._integrationsConnections[state.id]

	if isSideSheetEnabled and state.sideSheetPlacement == nil then
		state.sideSheetPlacement = SideSheetPlacement.BelowFold
	end

	if state.initialAvailability == nil then
		state.initialAvailability = ChromeService.AvailabilitySignal.Unavailable
	end

	if state.availability == nil then
		state.availability = AvailabilitySignal.new(state.initialAvailability or ChromeService.AvailabilitySignal.Unavailable)
	end

	if state.notification == nil then
		state.notification = NotifySignal.new()
	end

	if state.components == nil then
		state.components = {}
	end

	if state.availability then
		connections[#connections + 1] = state.availability:connect(function()
			self:availabilityChanged(state)
		end)
	end

	if state.notification and not state.notification:excludeFromTotalCounts() then
		connections[#connections + 1] = state.notification:connect(function()
			self:updateNotificationTotals()
		end)
	end

	if state.windowSize == nil and state.components and state.components.Window then
		state.windowSize = WindowSizeSignal.new()
	end

	if ChromeService:getWindowStatusFromStore(state.id) and state.persistWindowState or state.windowDefaultOpen then
		self._integrationsStatus[state.id] = ChromeService.IntegrationStatus.Window
		self._onIntegrationStatusChanged:fire(state.id, self._integrationsStatus[state.id])
	end

	local v = UDim2.fromOffset(Constants.MENU_ICON_SCREEN_SIDE_OFFSET, Constants.WINDOW_DEFAULT_PADDING)

	if state.startingWindowPosition then
		if state.persistWindowState then
			v = self:getWindowPositionFromStore(state.id) or state.startingWindowPosition
		else
			v = state.startingWindowPosition
		end
	end

	self._windowPositions[state.id] = v

	state = self:updateLocalization(state)

	local v2 = state
	self._integrations[state.id] = v2

	if FFlagEnableConsoleExpControls and state.selected then
		connections[#connections + 1] = self:selectedItem():connect(function(p)
			if v2.id == p then
				if GamepadService.GamepadCursorEnabled then
					return
				end

				state.selected(v2)
			end
		end)
	end

	return v2
end

function ChromeService:createIconProps(id, value: number?)
	local order = value or 0

	if self._integrations[id] then
		return {
			id = id,
			children = {},
			order = order,
			component = self._integrations[id].components.Icon,
			integration = self._integrations[id],
			isDivider = false,
			activated = function()
				self:activate(id)
			end
		}
	end

	return {
		id = id,
		children = {},
		order = order,
		activated = noop,
		integration = integration2
	}
end

function ChromeService:createWidgetProps(id, value: number?)
	local integration = self._integrations[id]

	if integration and integration.components.Widget then
		return {
			id = id,
			children = {},
			order = value or 0,
			component = integration.components.Widget,
			integration = integration,
			activated = noop
		}
	end

	return nil
end

function ChromeService:isIntegrationValid(p)
	local integration = self._integrations[p]

	if not integration then
		return false
	end

	local availability = integration.availability
	return availability and availability:get() ~= ChromeService.AvailabilitySignal.Unavailable
end

function ChromeService:updateMenuList()
	local count = 0
	local count2 = 0

	local function iconProps(item) -- 1 equivalent call inferred from this helper
		count2 += 1
		return self:createIconProps(item, count2)
	end

	local function windowProps(id)
		count2 += 1

		if self._integrations[id] then
			return {
				id = id,
				children = {},
				order = count2,
				component = self._integrations[id].components.Window,
				activated = noop,
				integration = self._integrations[id]
			}
		end

		return {
			id = id,
			children = {},
			order = count2,
			activated = noop,
			integration = integration2
		}
	end

	local function divider(_)
		count += 1
		count2 += 1
		return {
			id = "DIV" .. count,
			order = count2,
			isDivider = true,
			children = {},
			activated = noop,
			integration = integration2
		}
	end

	local function collectMenu(menuConfig, p, list)
		local count3 = 0

		for k, item in pairs(menuConfig) do
			if type(item) == "table" then
				if not #p.children then
					table.insert(p.children, divider(count))
				end

				if collectMenu(item, p, list) > 0 then
					table.insert(p.children, divider(count))
				end
			else
				if typeof(item) ~= "string" then
					error(`Only tables or strings should be passed into the items list, received {item} (at key {k})`)
				end

				if isSideSheetEnabled or not self._subMenuConfig[item] then
					if self:isIntegrationValid(item) then
						if self:isWindowOpen(item) then
							table.insert(list, windowProps(item))
						end

						table.insert(p.children, iconProps(item))
						count3 += 1
					end
				elseif self:isIntegrationValid(item) then
					local v = iconProps(item) -- inferred equivalent call
					count3 += 1
					collectMenu(self._subMenuConfig[item], v, list)

					if #v.children > 0 then
						table.insert(p.children, v)
					end
				end
			end
		end

		return count3
	end

	local v = { children = {} }
	local v2 = {}
	collectMenu(self._menuConfig, v, v2)

	if #v.children and v.children[#v.children] and v.children[#v.children].isDivider then
		table.remove(v.children, #v.children)
	end

	if FFlagEnableChromeWindowsNotInMenu then
		local idSet = {}

		for _, v3 in v2 do
			idSet[v3.id] = true
		end

		for k, _ in self._integrations do
			if not self:isWindowOpen(k) or idSet[k] then
				continue
			end

			table.insert(v2, windowProps(k))
		end
	end

	self._menuList:set(v.children)
	self._windowList:set(v2)
	self:repairSelected()
end

if isSideSheetEnabled then
	function ChromeService:updateSideSheet()
		local count = 0
		local aboveFoldIntegrations = {}
		local unibarIntegrations = {}
		local belowFoldIntegrations = {}
		local sessionActionIntegrations = {}
		local scrollableContentTopWidgetIntegrations = {}
		local scrollableContentBottomWidgetIntegrations = {}

		local function addIntegration(p)
			local integration = self._integrations[p]

			if
				not integration
				or integration.sideSheetPlacement == SideSheetPlacement.None
				or not self:isIntegrationValid(p)
			then
				return
			end

			if integration.sideSheetPlacement == SideSheetPlacement.Unibar then
				table.insert(unibarIntegrations, self:createIconProps(p, count))
			elseif
				integration.sideSheetPlacement == SideSheetPlacement.BelowFold
				or FFlagSideSheetUnifiedMenuOrder and integration.sideSheetPlacement == SideSheetPlacement.AboveFold
			then
				table.insert(belowFoldIntegrations, self:createIconProps(p, count))
			elseif integration.sideSheetPlacement == SideSheetPlacement.AboveFold then
				table.insert(aboveFoldIntegrations, self:createIconProps(p, count))
			elseif integration.sideSheetPlacement == SideSheetPlacement.SessionAction then
				table.insert(sessionActionIntegrations, self:createIconProps(p, count))
			elseif integration.sideSheetPlacement == SideSheetPlacement.ScrollableContentTop then
				local v = (FFlagEnableSideSheetWidgets or isPioneerLaunch()) and self:createWidgetProps(p, count)

				if v then
					table.insert(scrollableContentTopWidgetIntegrations, v)
				end
			else
				local v = integration.sideSheetPlacement == SideSheetPlacement.ScrollableContentBottom
					and (FFlagEnableSideSheetWidgets or isPioneerLaunch())
					and self:createWidgetProps(p, count)

				if v then
					table.insert(scrollableContentBottomWidgetIntegrations, v)
				end
			end
		end

		for _, v in self._menuConfig do
			for _, v2 in v do
				count += 1
				addIntegration(v2)
			end
		end

		for _, v in self._subMenuConfig do
			for _, v2 in v do
				count += 1
				addIntegration(v2)
			end
		end

		registerSideSheetIntegrations({
			unibarIntegrations = unibarIntegrations,
			aboveFoldIntegrations = aboveFoldIntegrations,
			belowFoldIntegrations = belowFoldIntegrations,
			sessionActionIntegrations = sessionActionIntegrations,
			scrollableContentTopWidgetIntegrations = scrollableContentTopWidgetIntegrations,
			scrollableContentBottomWidgetIntegrations = scrollableContentBottomWidgetIntegrations
		})
	end
end

function ChromeService:availabilityChanged(_)
	self:updateNotificationTotals()
	self:updateMenuList()

	if isSideSheetEnabled then
		self:updateSideSheet()
	end
end

function ChromeService:subMenuNotifications(p)
	if not self._subMenuNotifications[p] then
		self._subMenuNotifications[p] = NotifySignal.new(true)
	end

	return self._subMenuNotifications[p]
end

function ChromeService:totalNotifications()
	return self._totalNotifications
end

function ChromeService:onIntegrationRegistered()
	return self._onIntegrationRegistered
end

function ChromeService:onIntegrationActivated()
	return self._onIntegrationActivated
end

function ChromeService:onIntegrationHovered()
	return self._onIntegrationHovered
end

function ChromeService:onIntegrationStatusChanged()
	return self._onIntegrationStatusChanged
end

function ChromeService:integrations()
	return self._integrations
end

function ChromeService:updateNotificationTotals()
	local total = 0

	for _, integration in self._integrations do
		if
			integration.availability:get() == ChromeService.AvailabilitySignal.Unavailable
			or integration.availability:get() == ChromeService.AvailabilitySignal.Pinned
			or integration.notification:excludeFromTotalCounts()
		then
			continue
		end

		local v = integration.notification:get()

		if not (v and v.type == "count") then
			continue
		end

		assert(typeof(v.value) == "number", "Expected count value to be number")
		total += v.value
	end

	self._totalNotifications:fireCount(total)

	for k, subMenuNotification in self._subMenuNotifications do
		local withinCurrentTopLevelMenu = self:withinCurrentTopLevelMenu(k)
		local total2 = 0

		if not withinCurrentTopLevelMenu then
			continue
		end

		for _, child in withinCurrentTopLevelMenu.children do
			if
				self:withinCurrentTopLevelMenu(child.id)
				or child.integration.availability:get() == ChromeService.AvailabilitySignal.Unavailable
				or child.integration.notification:excludeFromTotalCounts()
			then
				continue
			end

			local v = child.integration.notification:get()

			if not (v and v.type == "count") then
				continue
			end

			assert(typeof(v.value) == "number", "Expected count value to be number")
			total2 += v.value
		end

		subMenuNotification:fireCount(total2)
	end
end

function ChromeService:configureMenu(menuConfig)
	self._menuConfig = menuConfig
	self:updateNotificationTotals()
	self:updateMenuList()
end

function ChromeService:configureSubMenu(p, p2)
	self._subMenuConfig[p] = p2

	if not self._subMenuNotifications[p] then
		self._subMenuNotifications[p] = NotifySignal.new(true)
	end

	self:updateNotificationTotals()
	self:updateMenuList()

	if isSideSheetEnabled then
		self:updateSideSheet()
	end
end

if FFlagEnableConsoleExpControls then
	function ChromeService:registerShortcut(p)
		self._shortcutService:registerShortcut(p)
		local shortcut = self._shortcutService:getShortcut(p.id)

		if shortcut.integration and self._integrations[shortcut.integration] then
			local integration = self._integrations[shortcut.integration]

			if integration.availability:get() == ChromeService.AvailabilitySignal.Unavailable then
				shortcut.availability:unavailable()
			end

			integration.availability:connect(function()
				local v = integration.availability:get()

				if v == ChromeService.AvailabilitySignal.Unavailable then
					shortcut.availability:unavailable()
				elseif
					v == ChromeService.AvailabilitySignal.Available
					or v == ChromeService.AvailabilitySignal.Pinned
				then
					shortcut.availability:available()
				end
			end)
		end
	end

	function ChromeService:activateShortcut(p)
		local shortcut = self._shortcutService:getShortcut(p)

		if shortcut.integration then
			if shortcut.activated then
				if FFlagIntegrationsChromeShortcutTelemetry then
					self._shortcutService:activateShortcut(p)
					self._onIntegrationActivated:fire(shortcut.integration, { fromShortcut = true })
				end
			elseif FFlagIntegrationsChromeShortcutTelemetry then
				self:activate(shortcut.integration, { fromShortcut = true })
			else
				self:activate(shortcut.integration)
			end
		else
			self._shortcutService:activateShortcut(p)
		end
	end

	function ChromeService:configureShortcutBar(p, p2)
		self._shortcutService:configureShortcutBar(p, p2)
	end

	function ChromeService:setShortcutBar(p)
		self._shortcutService:setShortcutBar(p)
	end

	function ChromeService:getCurrentShortcutBar()
		return self._currentShortcutBar
	end

	function ChromeService:getShortcutsFromBar(p)
		return self._shortcutService:getShortcutsFromBar(p, self._integrations)
	end

	function ChromeService:getCurrentShortcuts()
		return self:getShortcutsFromBar(self._currentShortcutBar:get())
	end

	function ChromeService:onShortcutBarChanged()
		return self._shortcutService.onShortcutBarChanged
	end

	function ChromeService:selectMenuIcon()
		self._triggerMenuIcon:fire()
	end

	function ChromeService:onTriggerMenuIcon()
		return self._triggerMenuIcon
	end

	function ChromeService:setHideShortcutBar(p, flag: boolean?)
		self._shortcutService:setHideShortcutBar(p, flag)
	end

	function ChromeService:getHideShortcutBar()
		return self._shortcutService:getHideShortcutBar()
	end
end

if isInExperienceUIVREnabled then
	function ChromeService:onTriggerVRToggleButton()
		return self._triggerVRToggleButton
	end

	function ChromeService:showTopBar()
		return self._topBarVisibility:get()
	end

	function ChromeService:getTopBarVisibiity()
		return self._topBarVisibility
	end

	function ChromeService:connectTopBarVisibility(topBarVisibility)
		self._topBarVisibility = topBarVisibility
	end
end

function ChromeService:gesture(p, connection, inputObject)
	if self._integrations[p] then
		self._dragConnection[p] = { connection = connection, inputObject = inputObject }
	end
end

function ChromeService:withinCurrentTopLevelMenu(p)
	local v = self._menuList:get()

	for k, v2 in v do
		if v2.id == p then
			return v2, k
		end
	end

	return nil, 0
end

function ChromeService:withinCurrentSubmenu(p): boolean
	local v = self._currentSubMenu:get()

	if not v then
		return false
	end

	local v2 = self._menuList:get()
	local children = nil

	for _, v3 in v2 do
		if v3.id == v then
			children = v3.children
			break
		end
	end

	if not children then
		return false
	end

	for _, child in children do
		if child.id == p then
			return true
		end
	end

	return false
end

if isSideSheetEnabled then
	function ChromeService:withinOpenSideSheet(p): boolean
		if not getSideSheetVisibility() then
			return false
		end

		for _, integration in self._integrations do
			if integration.id == p and integration.sideSheetPlacement ~= SideSheetPlacement.None then
				return true
			end
		end

		return false
	end
end

function ChromeService:windowPosition(p)
	return self._windowPositions[p]
end

function ChromeService:updateWindowPosition(p, udim: UDim2)
	if LocalStore.isEnabled() and self._integrations[p] and self._integrations[p].persistWindowState then
		local v = LocalStore.loadForLocalPlayer("ChromeWindowPosition") or {}

		v[p] = { udim.X.Scale, udim.X.Offset, udim.Y.Scale, udim.Y.Offset }
		LocalStore.storeForLocalPlayer("ChromeWindowPosition", v)
	end

	self._windowPositions[p] = udim
end

function ChromeService:getWindowStatusFromStore(p)
	if LocalStore.isEnabled() then
		return (LocalStore.loadForLocalPlayer("ChromeWindowStatus") or {})[p] or false
	end

	return nil
end

function ChromeService:getWindowPositionFromStore(p)
	if not LocalStore.isEnabled() then
		return nil
	end

	local v = (LocalStore.loadForLocalPlayer("ChromeWindowPosition") or {})[p] or nil

	if v then
		return (UDim2.new(v[1], v[2], v[3], v[4]))
	end

	return nil
end

function ChromeService:activate(p, p2)
	local v = nil

	if self._integrations[p] then
		local activated = self._integrations[p].activated

		if FFlagIntegrationsChromeShortcutTelemetry then
			self._onIntegrationActivated:fire(p, p2)
		else
			self._onIntegrationActivated:fire(p)
		end

		self:storeChromeInteracted()

		if activated then
			local success, result = pcall(function()
				activated(self._integrations[p])

				if not FFlagEnableConsoleExpControls then
					self:disableFocusNav()
				end
			end)

			if not success then
				warn("ChromeService: activate error thrown for " .. p)
				v = result
			end
		else
			if self._subMenuConfig[p] then
				self:toggleSubMenu(p)
			end

			self:toggleWindow(p)
		end

		if self._currentSubMenu:get() ~= p then
			self._currentSubMenu:set(nil)
		end
	end

	if v then
		error(v)
	end
end

function ChromeService:selectedItem()
	return self._selectedItem
end

function ChromeService:setSelected(value)
	local withinCurrentTopLevelMenu, selectedItemIdx = self:withinCurrentTopLevelMenu(value or "")

	if not withinCurrentTopLevelMenu then
		return
	end

	local lastInputType = UserInputService:GetLastInputType()
	local v = lastInputType == Enum.UserInputType.MouseButton1 or lastInputType == Enum.UserInputType.Touch

	local v2 = self._currentSubMenu:get()

	if v2 and v2 ~= value and not v then
		self:toggleSubMenu(v2)
	end

	self._selectedItemIdx = selectedItemIdx
	self._selectedItem:set(value)
end

function ChromeService:setSelectedByOffset(p: number)
	local v = self._menuList:get()
	local _, v2 = self:withinCurrentTopLevelMenu(self._selectedItem:get() or "")

	if v2 > 0 then
		self:setSelected(v[math.clamp(v2 + p, 1, #v)].id)
	end
end

function ChromeService:repairSelected()
	if self._selectedItem:get() then
		local _, v = self:withinCurrentTopLevelMenu(self._selectedItem:get() or "")

		if v == 0 then
			v = self._selectedItemIdx
		end

		local v2 = self._menuList:get()
		self:setSelected(v2[math.clamp(v, 1, #v2)].id)
	end
end
function ChromeService:configureOrderAlignment(p)
	if self._orderAlignment:get() ~= p then
		self._orderAlignment:set(p)
		self:updateMenuList()
	end
end

function ChromeService:orderAlignment()
	return self._orderAlignment
end

function ChromeService:setMenuAbsolutePosition(menuAbsolutePosition: Vector2)
	if menuAbsolutePosition ~= self._menuAbsolutePosition then
		self._menuAbsolutePosition = menuAbsolutePosition
		self._layout:set(createUnibarLayoutInfo(menuAbsolutePosition, self._menuAbsoluteSizeOpen))
	end
end

function ChromeService:setMenuAbsoluteSize(menuAbsoluteSizeOpen: Vector2)
	if menuAbsoluteSizeOpen ~= self._menuAbsoluteSizeOpen then
		self._menuAbsoluteSizeOpen = menuAbsoluteSizeOpen
		self._layout:set(createUnibarLayoutInfo(self._menuAbsolutePosition, menuAbsoluteSizeOpen))
	end
end

function ChromeService:layout()
	return self._layout
end

return ChromeService
