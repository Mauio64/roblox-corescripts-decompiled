local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
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
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagIntegrationsChromeShortcutTelemetry = require(ChromeShared.Parent.Flags.FFlagIntegrationsChromeShortcutTelemetry)
local v27 = game:DefineFastFlag("ChromeDeprecateMRUs", false)
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FIntSideSheetVariant = SharedFlags.FIntSideSheetVariant
local FFlagEnableChromeWindowsNotInMenu = require(ChromeShared.Flags).FFlagEnableChromeWindowsNotInMenu
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility
local registerSideSheetIntegrations = InExperienceSideSheet.registerSideSheetIntegrations
local t1 = {}

t1.__index = t1
t1.AvailabilitySignal = ChromeUtils.AvailabilitySignalState
t1.IntegrationStatus = {
	None = 0,
	Icon = 1,
	Window = 2
}

function noop() -- line: 96
end

local t2 = {
	id = "div",
	label = "div",
	hideNotificationCountWhileOpen = false,
	initialAvailability = t1.AvailabilitySignal.Unavailable,
	availability = AvailabilitySignal.new(t1.AvailabilitySignal.Unavailable),
	notification = NotifySignal.new(),
	components = {},
	sideSheetPlacement = if not FFlagEnableSideSheet then nil else SideSheetPlacement.None
}

function createUnibarLayoutInfo(vector2: Vector2, vector2_2: Vector2) -- line: 240
	return Rect.new(vector2, vector2 + vector2_2)
end
function t1.new() -- line: 244
	-- upvalues: LocalizationService (copy), FFlagEnableConsoleExpControls (copy), ShortcutService (copy), ChromeUtils (copy), ObservableValue (copy), NotifySignal (copy), Localization (copy), Signal (copy), isInExperienceUIVREnabled (copy), t1 (copy), ViewportUtil (copy), v27 (copy), FocusOnChromeSignal (copy), FocusOffChromeSignal (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local t3 = {
		_shortcutService = if not FFlagEnableConsoleExpControls then nil else ShortcutService.new(),
		_layout = ChromeUtils.ObservableValue.new(createUnibarLayoutInfo(Vector2.zero, Vector2.zero)),
		_menuAbsolutePosition = Vector2.zero,
		_menuAbsoluteSizeOpen = Vector2.zero,
		_currentSubMenu = ChromeUtils.ObservableValue.new(nil),
		_selectedItem = ChromeUtils.ObservableValue.new(nil),
		_selectedItemIdx = 0,
		_integrations = {},
		_integrationsConnections = {},
		_integrationsStatus = {},
		_menuConfig = {},
		_subMenuConfig = {},
		_subMenuNotifications = {},
		_menuList = ObservableValue.new({}),
		_windowList = ObservableValue.new({}),
		_dragConnection = {},
		_windowPositions = ObservableValue.new({}),
		_totalNotifications = NotifySignal.new(true),
		_mostRecentlyUsedAndPinnedLimit = -1,
		_localization = Localization.new(RobloxLocaleId),
		_localizedLabelKeys = {},
		_currentShortcutBar = ObservableValue.new(nil),
		_notificationIndicator = ObservableValue.new(nil),
		_orderAlignment = ObservableValue.new(Enum.HorizontalAlignment.Left),
		_onIntegrationRegistered = Signal.new(),
		_onIntegrationActivated = Signal.new(),
		_onIntegrationStatusChanged = Signal.new(),
		_onIntegrationHovered = Signal.new(),
		_triggerMenuIcon = Signal.new(),
		_triggerVRToggleButton = if not isInExperienceUIVREnabled then nil else Signal.new(),
		_topBarVisibility = if not isInExperienceUIVREnabled then nil else ObservableValue.new(nil),
		_inFocusNav = ObservableValue.new(false)
	}
	local v41 = setmetatable(t3, t1)

	ViewportUtil.viewport:connect(function(p1) -- line: 287
		-- upvalues: v27 (copy), v41 (copy)
		if v27 then
			v41:updateWindowSizeSignals()

			return
		end

		v41:updateScreenSize(p1.size, p1.isMobileDevice, p1.portraitOrientation, p1.tinyPortrait)
	end, true)

	if FFlagEnableConsoleExpControls then
		t3._shortcutService.onShortcutBarChanged:connect(function(p2) -- line: 301
			-- upvalues: v41 (copy)
			v41._currentShortcutBar:set(p2)
		end)
	end

	FocusOnChromeSignal:connect(function(p3) -- line: 305
		-- upvalues: t3 (copy), v41 (copy)
		if p3 and not t3._subMenuConfig.nine_dot[p3] then
			v41:setSelected(p3)
		end

		v41:enableFocusNav()
	end)
	FocusOffChromeSignal:connect(function() -- line: 312
		-- upvalues: v41 (copy), FFlagEnableConsoleExpControls (copy)
		v41:disableFocusNav()

		if FFlagEnableConsoleExpControls then
			v41:setShortcutBar(nil)
		end
	end)

	return v41
end
function t1.storeChromeInteracted(_) -- line: 324
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() then
		LocalStore.storeForLocalPlayer("ChromeInteracted3", true)
	end
end
function t1.updateScreenSize(t4: {[any]: any}, _: Vector2, b1: boolean, b2: boolean, b3: boolean) -- line: 330
	-- upvalues: Constants (copy)
	local v48 = if not b1 then Constants.NON_MOBILE_SLOTS - Constants.CORE_SLOTS else if not b3 then if not b2 then Constants.MOBILE_LANDSCAPE_SLOTS - Constants.CORE_SLOTS else Constants.MOBILE_PORTRAIT_SLOTS - Constants.CORE_SLOTS else Constants.MOBILE_TINY_PORTRAIT_SLOTS - Constants.CORE_SLOTS

	if v48 ~= t4._mostRecentlyUsedAndPinnedLimit then
		t4._mostRecentlyUsedAndPinnedLimit = v48
		t4:updateMenuList()
		t4:updateNotificationTotals()
	end

	t4:updateWindowSizeSignals()
end
function t1.updateWindowSizeSignals(p5) -- line: 366
	for _, v51 in p5._integrations do
		if v51.windowSize then
			v51.windowSize:updateConstraints()
		end
	end
end
function t1.notificationIndicator(p6) -- line: 374
	return p6._notificationIndicator
end
function t1.toggleSubMenu(p7, p8) -- line: 378
	-- upvalues: FFlagEnableSideSheet (copy), toggleSideSheet (ref)
	if FFlagEnableSideSheet and toggleSideSheet then
		toggleSideSheet(true)

		return
	end

	if not p7._subMenuConfig[p8] then
		warn("Not a valid subMenuId:" .. p8)

		return
	end

	if p8 == p7._currentSubMenu:get() then
		p7._currentSubMenu:set(nil)

		return
	end

	p7._currentSubMenu:set(p8)
end
function t1.currentSubMenu(p9) -- line: 398
	return p9._currentSubMenu
end
function t1.inFocusNav(p10) -- line: 402
	return p10._inFocusNav
end
function t1.enableFocusNav(p11) -- line: 406
	-- upvalues: GamepadService (copy), FFlagEnableConsoleExpControls (copy), Constants (copy)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if not p11._inFocusNav:get() then
		p11._inFocusNav:set(true)
	end

	if FFlagEnableConsoleExpControls then
		p11:setShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID)
	end
end
function t1.disableFocusNav(p12) -- line: 419
	-- upvalues: GamepadService (copy)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if p12._inFocusNav:get() then
		p12._inFocusNav:set(false)
		p12._selectedItem:set(nil)
		p12._currentSubMenu:set(nil)
	end
end
function t1.toggleWindow(p13, p14) -- line: 431
	-- upvalues: t1 (copy), LocalStore (copy)
	if p13._integrations[p14].components.Window then
		if not p13._integrationsStatus[p14] or p13._integrationsStatus[p14] == t1.IntegrationStatus.None or p13._integrationsStatus[p14] == t1.IntegrationStatus.Icon then
			p13._integrationsStatus[p14] = t1.IntegrationStatus.Window
		else
			p13._integrationsStatus[p14] = t1.IntegrationStatus.Icon
		end

		p13._onIntegrationStatusChanged:fire(p14, p13._integrationsStatus[p14])
	end

	if LocalStore.isEnabled() and p13._integrations[p14] and p13._integrations[p14].persistWindowState then
		local v61 = LocalStore.loadForLocalPlayer("ChromeWindowStatus") or {}

		v61[p14] = p13._integrationsStatus[p14] == t1.IntegrationStatus.Window
		LocalStore.storeForLocalPlayer("ChromeWindowStatus", v61)
	end

	p13:updateMenuList()
end
function t1.isWindowOpen(p15, p16) -- line: 457
	-- upvalues: t1 (copy)
	return p15._integrations[p16].components.Window and p15._integrationsStatus[p16] == t1.IntegrationStatus.Window
end
function t1.menuList(p17) -- line: 461
	return p17._menuList
end
function t1.windowList(p18) -- line: 465
	return p18._windowList
end
function t1.dragConnection(p19, p20) -- line: 469
	if p19._integrations[p20] then
		return p19._dragConnection[p20]
	end

	return nil
end
function t1.updateLocalization(p21, p22) -- line: 477
	local s1 = ""

	p21._localizedLabelKeys[p22.id] = {}
	p21._localizedLabelKeys[p22.id].label = p22.label

	local label = p22.label
	local ok, result = pcall(function() -- line: 488
		-- upvalues: label (ref), p21 (copy)
		label = p21._localization:Format(label)
	end)

	if not ok then
		label = p22.label
		warn(result)
	end

	p22.label = label

	if p22.secondaryAction then
		p21._localizedLabelKeys[p22.id].secondaryActionLabel = p22.secondaryAction.label
		s1 = p22.secondaryAction.label

		local ok2, result2 = pcall(function() -- line: 502
			-- upvalues: s1 (ref), p21 (copy)
			s1 = p21._localization:Format(s1)
		end)

		if not ok2 then
			s1 = p22.secondaryAction.label
			warn(result2)
		end

		p22.secondaryAction.label = s1
	end

	return p22
end
function t1.register(p23, p24) -- line: 517
	-- upvalues: FFlagEnableSideSheet (copy), SideSheetPlacement (copy), t1 (copy), AvailabilitySignal (copy), NotifySignal (copy), WindowSizeSignal (copy), Constants (copy), FFlagEnableConsoleExpControls (copy), GamepadService (copy)
	if p23._integrations[p24.id] then
		warn(string.format(p24.id .. "already registered", debug.traceback()))

		for _, v80 in p23._integrationsConnections[p24.id] do
			v80:disconnect()
		end
	end

	p23._integrationsConnections[p24.id] = {}

	local v81 = p23._integrationsConnections[p24.id]

	if FFlagEnableSideSheet and p24.sideSheetPlacement == nil then
		p24.sideSheetPlacement = SideSheetPlacement.Vertical
	end

	if p24.initialAvailability == nil then
		p24.initialAvailability = t1.AvailabilitySignal.Unavailable
	end

	if p24.availability == nil then
		p24.availability = AvailabilitySignal.new(p24.initialAvailability or t1.AvailabilitySignal.Unavailable)
	end

	if p24.notification == nil then
		p24.notification = NotifySignal.new()
	end

	if p24.components == nil then
		p24.components = {}
	end

	if p24.availability then
		v81[#v81 + 1] = p24.availability:connect(function() -- line: 552
			-- upvalues: p23 (copy), p24 (ref)
			p23:availabilityChanged(p24)
		end)
	end

	if p24.notification and not p24.notification:excludeFromTotalCounts() then
		v81[#v81 + 1] = p24.notification:connect(function() -- line: 558
			-- upvalues: p23 (copy)
			p23:updateNotificationTotals()
		end)
	end

	if p24.windowSize == nil and p24.components and p24.components.Window then
		p24.windowSize = WindowSizeSignal.new()
	end

	if t1:getWindowStatusFromStore(p24.id) and p24.persistWindowState or p24.windowDefaultOpen then
		p23._integrationsStatus[p24.id] = t1.IntegrationStatus.Window
		p23._onIntegrationStatusChanged:fire(p24.id, p23._integrationsStatus[p24.id])
	end

	local uDim2 = UDim2.fromOffset(Constants.MENU_ICON_SCREEN_SIDE_OFFSET, Constants.WINDOW_DEFAULT_PADDING)

	if p24.startingWindowPosition then
		uDim2 = if not p24.persistWindowState then p24.startingWindowPosition else p23:getWindowPositionFromStore(p24.id) or p24.startingWindowPosition
	end

	p23._windowPositions[p24.id] = uDim2
	p24 = p23:updateLocalization(p24)

	local v83 = p24

	p23._integrations[p24.id] = v83

	if FFlagEnableConsoleExpControls and p24.selected then
		v81[#v81 + 1] = p23:selectedItem():connect(function(p25) -- line: 592
			-- upvalues: v83 (copy), GamepadService (copy), p24 (ref)
			if p25 == v83.id then
				if GamepadService.GamepadCursorEnabled then
					return
				end

				p24.selected(v83)
			end
		end)
	end

	return v83
end
function t1.createIconProps(t5: {[any]: any}, p26, n1: number?) -- line: 605
	-- upvalues: t2 (copy)
	local v87 = n1 or 0

	if t5._integrations[p26] then
		return {
			isDivider = false,
			id = p26,
			children = {},
			order = v87,
			component = t5._integrations[p26].components.Icon,
			integration = t5._integrations[p26],
			activated = function() -- line: 615
				-- upvalues: t5 (copy), p26 (copy)
				t5:activate(p26)
			end
		}
	end

	return {
		id = p26,
		children = {},
		order = v87,
		activated = noop,
		integration = t2
	}
end
function t1.isIntegrationValid(p27, p28) -- line: 630
	-- upvalues: t1 (copy)
	local v90 = p27._integrations[p28]

	if v90 then
		local availability = v90.availability

		return availability and availability:get() ~= t1.AvailabilitySignal.Unavailable
	end

	return false
end
function t1.updateMenuList(p29) -- line: 643
	-- upvalues: t2 (copy), FFlagEnableSideSheet (copy), FFlagEnableChromeWindowsNotInMenu (copy)
	local n2 = 0
	local n3 = 0

	local function iconProps(p30) -- line: 647
		-- upvalues: n3 (ref), p29 (copy)
		n3 += 1

		return p29:createIconProps(p30, n3)
	end
	local function windowProps(p31) -- line: 652
		-- upvalues: n3 (ref), p29 (copy), t2 (copy)
		n3 += 1

		if p29._integrations[p31] then
			return {
				id = p31,
				children = {},
				order = n3,
				component = p29._integrations[p31].components.Window,
				activated = noop,
				integration = p29._integrations[p31]
			}
		end

		return {
			id = p31,
			children = {},
			order = n3,
			activated = noop,
			integration = t2
		}
	end
	local function divider(_) -- line: 674
		-- upvalues: n2 (ref), n3 (ref), t2 (copy)
		n2 += 1
		n3 += 1

		return {
			isDivider = true,
			id = "DIV" .. n2,
			order = n3,
			children = {},
			activated = noop,
			integration = t2
		}
	end
	local function collectMenu(p33, p34, p35) -- line: 687
		-- upvalues: divider (copy), n2 (ref), collectMenu (copy), FFlagEnableSideSheet (copy), p29 (copy), n3 (ref), windowProps (copy), iconProps (copy)
		local n4 = 0

		for k, v in pairs(p33) do
			if type(v) == "table" then
				if not #p34.children then
					table.insert(p34.children, (divider(n2)))
				end

				if collectMenu(v, p34, p35) > 0 then
					table.insert(p34.children, (divider(n2)))
				end
			else
				if typeof(v) ~= "string" then
					error(`Only tables or strings should be passed into the items list, received { v } (at key { k })`)
				end

				if not FFlagEnableSideSheet and p29._subMenuConfig[v] then
					if p29:isIntegrationValid(v) then
						n3 += 1

						local v254 = p29:createIconProps(v, n3)

						n4 += 1
						collectMenu(p29._subMenuConfig[v], v254, p35)

						if #v254.children > 0 then
							table.insert(p34.children, v254)
						end
					end
				elseif p29:isIntegrationValid(v) then
					if p29:isWindowOpen(v) then
						table.insert(p35, (windowProps(v)))
						table.insert(p34.children, iconProps(v))
						n4 += 1
					else
						table.insert(p34.children, iconProps(v))
						n4 += 1
					end
				end
			end
		end

		return n4
	end

	local t6 = {
		children = {}
	}
	local t7 = {}

	collectMenu(p29._menuConfig, t6, t7)

	if #t6.children and (t6.children[#t6.children] and t6.children[#t6.children].isDivider) then
		table.remove(t6.children, #t6.children)
	end

	if FFlagEnableChromeWindowsNotInMenu then
		local t8 = {}

		for _, v103 in t7 do
			t8[v103.id] = true
		end

		for v104, _ in p29._integrations do
			if p29:isWindowOpen(v104) and not t8[v104] then
				table.insert(t7, (windowProps(v104)))
			end
		end
	end

	p29._menuList:set(t6.children)
	p29._windowList:set(t7)
	p29:repairSelected()
end

if FFlagEnableSideSheet then
	function t1.updateSideSheet(p36) -- line: 761
		-- upvalues: SideSheetPlacement (copy), FIntSideSheetVariant (copy), registerSideSheetIntegrations (ref)
		local n5 = 0
		local t9 = {}
		local t10 = {}
		local t11 = {}
		local t12 = {}

		local function addIntegration(p37) -- line: 768
			-- upvalues: p36 (copy), SideSheetPlacement (copy), t10 (ref), n5 (ref), t11 (copy), t12 (copy), FIntSideSheetVariant (copy), t9 (ref)
			local v256 = p36._integrations[p37]

			if not v256 or (v256.sideSheetPlacement == SideSheetPlacement.None or not p36:isIntegrationValid(p37)) then
				return
			end

			if v256.sideSheetPlacement == SideSheetPlacement.Unibar then
				table.insert(t10, p36:createIconProps(p37, n5))

				return
			end

			if v256.sideSheetPlacement == SideSheetPlacement.Page then
				table.insert(t11, p36:createIconProps(p37, n5))

				return
			end

			if v256.sideSheetPlacement == SideSheetPlacement.SessionAction then
				table.insert(t12, p36:createIconProps(p37, n5))

				return
			end

			if v256.sideSheetPlacement == SideSheetPlacement.Vertical and FIntSideSheetVariant ~= 0 then
				table.insert(t11, p36:createIconProps(p37, n5))

				return
			end

			table.insert(t9, p36:createIconProps(p37, n5))
		end

		for _, v114 in p36._menuConfig do
			for _, v116 in v114 do
				n5 += 1
				addIntegration(v116)
			end
		end

		for _, v118 in p36._subMenuConfig do
			for _, v120 in v118 do
				n5 += 1
				addIntegration(v120)
			end
		end

		if FIntSideSheetVariant == 0 then
			for _, v122 in t9 do
				table.insert(t10, v122)
			end

			t9 = t10
			t10 = {}
		end

		registerSideSheetIntegrations({
			unibarIntegrations = t10,
			toggleIntegrations = t9,
			pageIntegrations = t11,
			sessionActionIntegrations = t12
		})
	end
end

function t1.availabilityChanged(p38, _) -- line: 823
	-- upvalues: FFlagEnableSideSheet (copy)
	p38:updateNotificationTotals()
	p38:updateMenuList()

	if FFlagEnableSideSheet then
		p38:updateSideSheet()
	end
end
function t1.subMenuNotifications(p40, p41) -- line: 831
	-- upvalues: NotifySignal (copy)
	if not p40._subMenuNotifications[p41] then
		p40._subMenuNotifications[p41] = NotifySignal.new(true)
	end

	return p40._subMenuNotifications[p41]
end
function t1.totalNotifications(p42) -- line: 838
	return p42._totalNotifications
end
function t1.onIntegrationRegistered(p43) -- line: 842
	return p43._onIntegrationRegistered
end
function t1.onIntegrationActivated(p44) -- line: 846
	return p44._onIntegrationActivated
end
function t1.onIntegrationHovered(p45) -- line: 850
	return p45._onIntegrationHovered
end
function t1.onIntegrationStatusChanged(p46) -- line: 854
	return p46._onIntegrationStatusChanged
end
function t1.integrations(p47) -- line: 858
	return p47._integrations
end
function t1.updateNotificationTotals(p48) -- line: 862
	-- upvalues: t1 (copy)
	local n6 = 0

	for _, v136 in p48._integrations do
		if v136.availability:get() ~= t1.AvailabilitySignal.Unavailable and v136.availability:get() ~= t1.AvailabilitySignal.Pinned and not v136.notification:excludeFromTotalCounts() then
			local v137 = v136.notification:get()

			if v137 and v137.type == "count" then
				assert(typeof(v137.value) == "number", "Expected count value to be number")
				n6 += v137.value
			end
		end
	end

	p48._totalNotifications:fireCount(n6)

	for v138, v139 in p48._subMenuNotifications do
		local v140 = p48:withinCurrentTopLevelMenu(v138)
		local n7 = 0

		if v140 then
			for _, v143 in v140.children do
				if not p48:withinCurrentTopLevelMenu(v143.id) and v143.integration.availability:get() ~= t1.AvailabilitySignal.Unavailable and not v143.integration.notification:excludeFromTotalCounts() then
					local v144 = v143.integration.notification:get()

					if v144 and v144.type == "count" then
						assert(typeof(v144.value) == "number", "Expected count value to be number")
						n7 += v144.value
					end
				end
			end

			v139:fireCount(n7)
		end
	end
end
function t1.configureMenu(p49, p50) -- line: 906
	p49._menuConfig = p50
	p49:updateNotificationTotals()
	p49:updateMenuList()
end
function t1.configureSubMenu(p51, p52, p53) -- line: 912
	-- upvalues: NotifySignal (copy), FFlagEnableSideSheet (copy)
	p51._subMenuConfig[p52] = p53

	if not p51._subMenuNotifications[p52] then
		p51._subMenuNotifications[p52] = NotifySignal.new(true)
	end

	p51:updateNotificationTotals()
	p51:updateMenuList()

	if FFlagEnableSideSheet then
		p51:updateSideSheet()
	end
end

if FFlagEnableConsoleExpControls then
	function t1.registerShortcut(p54, p55) -- line: 925
		-- upvalues: t1 (copy)
		p54._shortcutService:registerShortcut(p55)

		local v152 = p54._shortcutService:getShortcut(p55.id)

		if v152.integration and p54._integrations[v152.integration] then
			local v153 = p54._integrations[v152.integration]

			if v153.availability:get() == t1.AvailabilitySignal.Unavailable then
				v152.availability:unavailable()
			end

			v153.availability:connect(function() -- line: 933
				-- upvalues: v153 (copy), t1 (copy), v152 (copy)
				local v257 = v153.availability:get()

				if v257 == t1.AvailabilitySignal.Unavailable then
					v152.availability:unavailable()

					return
				end

				if v257 == t1.AvailabilitySignal.Available or v257 == t1.AvailabilitySignal.Pinned then
					v152.availability:available()
				end
			end)
		end
	end
	function t1.activateShortcut(p56, p57) -- line: 947
		-- upvalues: FFlagIntegrationsChromeShortcutTelemetry (copy)
		local v156 = p56._shortcutService:getShortcut(p57)

		if v156.integration then
			if not v156.activated then
				if FFlagIntegrationsChromeShortcutTelemetry then
					p56:activate(v156.integration, {
						fromShortcut = true
					})

					return
				end

				p56:activate(v156.integration)

				return
			end

			if FFlagIntegrationsChromeShortcutTelemetry then
				p56._shortcutService:activateShortcut(p57)
				p56._onIntegrationActivated:fire(v156.integration, {
					fromShortcut = true
				})

				return
			end
		else
			p56._shortcutService:activateShortcut(p57)
		end
	end
	function t1.configureShortcutBar(p58, p59, p60) -- line: 967
		p58._shortcutService:configureShortcutBar(p59, p60)
	end
	function t1.setShortcutBar(p61, p62) -- line: 971
		p61._shortcutService:setShortcutBar(p62)
	end
	function t1.getCurrentShortcutBar(p63) -- line: 975
		return p63._currentShortcutBar
	end
	function t1.getShortcutsFromBar(p64, p65) -- line: 979
		return p64._shortcutService:getShortcutsFromBar(p65, p64._integrations)
	end
	function t1.getCurrentShortcuts(p66) -- line: 983
		return p66:getShortcutsFromBar(p66._currentShortcutBar:get())
	end
	function t1.onShortcutBarChanged(p67) -- line: 987
		return p67._shortcutService.onShortcutBarChanged
	end
	function t1.selectMenuIcon(p68) -- line: 991
		p68._triggerMenuIcon:fire()
	end
	function t1.onTriggerMenuIcon(p69) -- line: 995
		return p69._triggerMenuIcon
	end
	function t1.setHideShortcutBar(t13: {[any]: any}, p70, b4: boolean?) -- line: 999
		t13._shortcutService:setHideShortcutBar(p70, b4)
	end
	function t1.getHideShortcutBar(p71) -- line: 1003
		return p71._shortcutService:getHideShortcutBar()
	end
end

if isInExperienceUIVREnabled then
	function t1.onTriggerVRToggleButton(p72) -- line: 1009
		return p72._triggerVRToggleButton
	end
	function t1.showTopBar(p73) -- line: 1013
		return p73._topBarVisibility:get()
	end
	function t1.getTopBarVisibiity(p74) -- line: 1017
		return p74._topBarVisibility
	end
	function t1.connectTopBarVisibility(p75, p76) -- line: 1021
		p75._topBarVisibility = p76
	end
end

function t1.gesture(t14: {[any]: any}, p77, t15: {[any]: any}?, p78) -- line: 1026
	if t14._integrations[p77] then
		t14._dragConnection[p77] = {
			connection = t15,
			inputObject = p78
		}
	end
end
function t1.withinCurrentTopLevelMenu(p79, p80) -- line: 1039
	for v184, v185 in (p79._menuList:get()) do
		if p80 == v185.id then
			return v185, v184
		end
	end

	return nil, 0
end
function t1.withinCurrentSubmenu(p81, p82) -- line: 1049
	local v188 = p81._currentSubMenu:get()

	if not v188 then
		return false
	end

	local children = nil

	for _, v191 in (p81._menuList:get()) do
		if v188 == v191.id then
			children = v191.children

			break
		end
	end

	if not children then
		return false
	end

	for _, v193 in children do
		if p82 == v193.id then
			return true
		end
	end

	return false
end

if FFlagEnableSideSheet then
	function t1.withinOpenSideSheet(p83, p84) -- line: 1079
		-- upvalues: getSideSheetVisibility (ref), SideSheetPlacement (copy)
		if not getSideSheetVisibility() then
			return false
		end

		for _, v197 in p83._integrations do
			if p84 == v197.id and v197.sideSheetPlacement ~= SideSheetPlacement.None then
				return true
			end
		end

		return false
	end
end

function t1.windowPosition(p85, p86) -- line: 1094
	return p85._windowPositions[p86]
end
function t1.updateWindowPosition(t16: {[any]: any}, p87, uDim2: UDim2) -- line: 1098
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() and (t16._integrations[p87] and t16._integrations[p87].persistWindowState) then
		local v203 = LocalStore.loadForLocalPlayer("ChromeWindowPosition") or {}

		v203[p87] = {
			uDim2.X.Scale,
			uDim2.X.Offset,
			uDim2.Y.Scale,
			uDim2.Y.Offset
		}
		LocalStore.storeForLocalPlayer("ChromeWindowPosition", v203)
	end

	t16._windowPositions[p87] = uDim2
end
function t1.getWindowStatusFromStore(_, p89) -- line: 1111
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() then
		return (LocalStore.loadForLocalPlayer("ChromeWindowStatus") or {})[p89] or false
	end

	return nil
end
function t1.getWindowPositionFromStore(_, p91) -- line: 1121
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() then
		local v208 = (LocalStore.loadForLocalPlayer("ChromeWindowPosition") or {})[p91] or nil

		if v208 then
			return (UDim2.new(v208[1], v208[2], v208[3], v208[4]))
		end

		return nil
	end

	return nil
end
function t1.activate(p92, p93, p94) -- line: 1132
	-- upvalues: FFlagIntegrationsChromeShortcutTelemetry (copy), FFlagEnableConsoleExpControls (copy)
	local v212 = nil

	if p92._integrations[p93] then
		local activated = p92._integrations[p93].activated

		if FFlagIntegrationsChromeShortcutTelemetry then
			p92._onIntegrationActivated:fire(p93, p94)
		else
			p92._onIntegrationActivated:fire(p93)
		end

		p92:storeChromeInteracted()

		if activated then
			local ok, result = pcall(function() -- line: 1148
				-- upvalues: activated (copy), p92 (copy), p93 (copy), FFlagEnableConsoleExpControls (copy)
				activated(p92._integrations[p93])

				if not FFlagEnableConsoleExpControls then
					p92:disableFocusNav()
				end
			end)

			if not ok then
				warn("ChromeService: activate error thrown for " .. p93)
				v212 = result
			end
		else
			if p92._subMenuConfig[p93] then
				p92:toggleSubMenu(p93)
			end

			p92:toggleWindow(p93)
		end

		if p93 ~= p92._currentSubMenu:get() then
			p92._currentSubMenu:set(nil)
		end
	end

	if v212 then
		error(v212)
	end
end
function t1.selectedItem(p95) -- line: 1176
	return p95._selectedItem
end
function t1.setSelected(p96, p97) -- line: 1180
	-- upvalues: UserInputService (copy)
	local v219, v220 = p96:withinCurrentTopLevelMenu(p97 or "")

	if not v219 then
		return
	end

	local LastInputType = UserInputService:GetLastInputType()
	local v222 = LastInputType == Enum.UserInputType.MouseButton1 or LastInputType == Enum.UserInputType.Touch
	local v223 = p96._currentSubMenu:get()

	if v223 and v223 ~= p97 and not v222 then
		p96:toggleSubMenu(v223)
	end

	p96._selectedItemIdx = v220
	p96._selectedItem:set(p97)
end
function t1.setSelectedByOffset(t17: {[any]: any}, n8: number) -- line: 1198
	local v226 = t17._menuList:get()
	local _, v228 = t17:withinCurrentTopLevelMenu(t17._selectedItem:get() or "")

	if v228 > 0 then
		t17:setSelected(v226[math.clamp(v228 + n8, 1, #v226)].id)
	end
end
function t1.repairSelected(p98) -- line: 1208
	if p98._selectedItem:get() then
		local _, v231 = p98:withinCurrentTopLevelMenu(p98._selectedItem:get() or "")

		if v231 == 0 then
			v231 = p98._selectedItemIdx
		end

		local v232 = p98._menuList:get()

		p98:setSelected(v232[math.clamp(v231, 1, #v232)].id)
	end
end
function t1.configureOrderAlignment(p99, p100) -- line: 1222
	if p100 ~= p99._orderAlignment:get() then
		p99._orderAlignment:set(p100)
		p99:updateMenuList()
	end
end
function t1.orderAlignment(p101) -- line: 1229
	return p101._orderAlignment
end
function t1.setMenuAbsolutePosition(t18: {[any]: any}, vector2: Vector2) -- line: 1233
	if vector2 ~= t18._menuAbsolutePosition then
		t18._menuAbsolutePosition = vector2
		t18._layout:set(createUnibarLayoutInfo(vector2, t18._menuAbsoluteSizeOpen))
	end
end
function t1.setMenuAbsoluteSize(t19: {[any]: any}, vector2: Vector2) -- line: 1240
	if vector2 ~= t19._menuAbsoluteSizeOpen then
		t19._menuAbsoluteSizeOpen = vector2
		t19._layout:set(createUnibarLayoutInfo(t19._menuAbsolutePosition, vector2))
	end
end
function t1.layout(p102) -- line: 1247
	return p102._layout
end

return t1
