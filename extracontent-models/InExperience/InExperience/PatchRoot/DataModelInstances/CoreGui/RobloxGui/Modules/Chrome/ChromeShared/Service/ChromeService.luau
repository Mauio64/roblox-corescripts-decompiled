local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local reverse = require(CorePackages.Packages.LuauPolyfill).Array.reverse
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
local v28 = game:DefineFastFlag("ChromeDeprecateMRUs", false)
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FIntSideSheetVariant = SharedFlags.FIntSideSheetVariant
local FFlagEnableChromeWindowsNotInMenu = require(ChromeShared.Flags).FFlagEnableChromeWindowsNotInMenu
local FFlagReverseUnibar = require(script.Parent.Parent.Parent.Flags.FFlagReverseUnibar)
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

function noop() -- line: 100
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

function createUnibarLayoutInfo(vector2: Vector2, vector2_2: Vector2) -- line: 244
	return Rect.new(vector2, vector2 + vector2_2)
end
function t1.new() -- line: 248
	-- upvalues: LocalizationService (copy), FFlagEnableConsoleExpControls (copy), ShortcutService (copy), ChromeUtils (copy), ObservableValue (copy), NotifySignal (copy), Localization (copy), Signal (copy), isInExperienceUIVREnabled (copy), t1 (copy), ViewportUtil (copy), v28 (copy), FocusOnChromeSignal (copy), FocusOffChromeSignal (copy)
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
	local v43 = setmetatable(t3, t1)

	ViewportUtil.viewport:connect(function(p1) -- line: 291
		-- upvalues: v28 (copy), v43 (copy)
		if v28 then
			v43:updateWindowSizeSignals()

			return
		end

		v43:updateScreenSize(p1.size, p1.isMobileDevice, p1.portraitOrientation, p1.tinyPortrait)
	end, true)

	if FFlagEnableConsoleExpControls then
		t3._shortcutService.onShortcutBarChanged:connect(function(p2) -- line: 305
			-- upvalues: v43 (copy)
			v43._currentShortcutBar:set(p2)
		end)
	end

	FocusOnChromeSignal:connect(function(p3) -- line: 309
		-- upvalues: t3 (copy), v43 (copy)
		if p3 and not t3._subMenuConfig.nine_dot[p3] then
			v43:setSelected(p3)
		end

		v43:enableFocusNav()
	end)
	FocusOffChromeSignal:connect(function() -- line: 316
		-- upvalues: v43 (copy), FFlagEnableConsoleExpControls (copy)
		v43:disableFocusNav()

		if FFlagEnableConsoleExpControls then
			v43:setShortcutBar(nil)
		end
	end)

	return v43
end
function t1.storeChromeInteracted(_) -- line: 328
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() then
		LocalStore.storeForLocalPlayer("ChromeInteracted3", true)
	end
end
function t1.updateScreenSize(t4: {[any]: any}, _: Vector2, b1: boolean, b2: boolean, b3: boolean) -- line: 334
	-- upvalues: Constants (copy)
	local v50 = if not b1 then Constants.NON_MOBILE_SLOTS - Constants.CORE_SLOTS else if not b3 then if not b2 then Constants.MOBILE_LANDSCAPE_SLOTS - Constants.CORE_SLOTS else Constants.MOBILE_PORTRAIT_SLOTS - Constants.CORE_SLOTS else Constants.MOBILE_TINY_PORTRAIT_SLOTS - Constants.CORE_SLOTS

	if v50 ~= t4._mostRecentlyUsedAndPinnedLimit then
		t4._mostRecentlyUsedAndPinnedLimit = v50
		t4:updateMenuList()
		t4:updateNotificationTotals()
	end

	t4:updateWindowSizeSignals()
end
function t1.updateWindowSizeSignals(p5) -- line: 370
	for _, v53 in p5._integrations do
		if v53.windowSize then
			v53.windowSize:updateConstraints()
		end
	end
end
function t1.notificationIndicator(p6) -- line: 378
	return p6._notificationIndicator
end
function t1.toggleSubMenu(p7, p8) -- line: 382
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
function t1.currentSubMenu(p9) -- line: 402
	return p9._currentSubMenu
end
function t1.inFocusNav(p10) -- line: 406
	return p10._inFocusNav
end
function t1.enableFocusNav(p11) -- line: 410
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
function t1.disableFocusNav(p12) -- line: 423
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
function t1.toggleWindow(p13, p14) -- line: 435
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
		local v63 = LocalStore.loadForLocalPlayer("ChromeWindowStatus") or {}

		v63[p14] = p13._integrationsStatus[p14] == t1.IntegrationStatus.Window
		LocalStore.storeForLocalPlayer("ChromeWindowStatus", v63)
	end

	p13:updateMenuList()
end
function t1.isWindowOpen(p15, p16) -- line: 461
	-- upvalues: t1 (copy)
	return p15._integrations[p16].components.Window and p15._integrationsStatus[p16] == t1.IntegrationStatus.Window
end
function t1.menuList(p17) -- line: 465
	return p17._menuList
end
function t1.windowList(p18) -- line: 469
	return p18._windowList
end
function t1.dragConnection(p19, p20) -- line: 473
	if p19._integrations[p20] then
		return p19._dragConnection[p20]
	end

	return nil
end
function t1.updateLocalization(p21, p22) -- line: 481
	local s1 = ""

	p21._localizedLabelKeys[p22.id] = {}
	p21._localizedLabelKeys[p22.id].label = p22.label

	local label = p22.label
	local ok, result = pcall(function() -- line: 492
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

		local ok2, result2 = pcall(function() -- line: 506
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
function t1.register(p23, p24) -- line: 521
	-- upvalues: FFlagEnableSideSheet (copy), SideSheetPlacement (copy), t1 (copy), AvailabilitySignal (copy), NotifySignal (copy), WindowSizeSignal (copy), Constants (copy), FFlagEnableConsoleExpControls (copy), GamepadService (copy)
	if p23._integrations[p24.id] then
		warn(string.format(p24.id .. "already registered", debug.traceback()))

		for _, v82 in p23._integrationsConnections[p24.id] do
			v82:disconnect()
		end
	end

	p23._integrationsConnections[p24.id] = {}

	local v83 = p23._integrationsConnections[p24.id]

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
		v83[#v83 + 1] = p24.availability:connect(function() -- line: 556
			-- upvalues: p23 (copy), p24 (ref)
			p23:availabilityChanged(p24)
		end)
	end

	if p24.notification and not p24.notification:excludeFromTotalCounts() then
		v83[#v83 + 1] = p24.notification:connect(function() -- line: 562
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

	local v85 = p24

	p23._integrations[p24.id] = v85

	if FFlagEnableConsoleExpControls and p24.selected then
		v83[#v83 + 1] = p23:selectedItem():connect(function(p25) -- line: 596
			-- upvalues: v85 (copy), GamepadService (copy), p24 (ref)
			if p25 == v85.id then
				if GamepadService.GamepadCursorEnabled then
					return
				end

				p24.selected(v85)
			end
		end)
	end

	return v85
end
function t1.createIconProps(t5: {[any]: any}, p26, n1: number?) -- line: 609
	-- upvalues: t2 (copy)
	local v89 = n1 or 0

	if t5._integrations[p26] then
		return {
			isDivider = false,
			id = p26,
			children = {},
			order = v89,
			component = t5._integrations[p26].components.Icon,
			integration = t5._integrations[p26],
			activated = function() -- line: 619
				-- upvalues: t5 (copy), p26 (copy)
				t5:activate(p26)
			end
		}
	end

	return {
		id = p26,
		children = {},
		order = v89,
		activated = noop,
		integration = t2
	}
end
function reverseOrder(p27) -- line: 634
	local v91 = #p27
	local t6 = {}

	for i = 1, v91 do
		t6[i] = p27[i].order
	end

	for i = 1, v91 do
		p27[i].order = t6[v91 - i + 1]
	end
end
function t1.isIntegrationValid(p28, p29) -- line: 645
	-- upvalues: t1 (copy)
	local v97 = p28._integrations[p29]

	if v97 then
		local availability = v97.availability

		return availability and availability:get() ~= t1.AvailabilitySignal.Unavailable
	end

	return false
end
function t1.updateMenuList(p30) -- line: 658
	-- upvalues: t2 (copy), FFlagEnableSideSheet (copy), FFlagReverseUnibar (copy), reverse (copy), FFlagEnableChromeWindowsNotInMenu (copy)
	local n2 = 0
	local n3 = 0

	local function iconProps(p31) -- line: 662
		-- upvalues: n3 (ref), p30 (copy)
		n3 += 1

		return p30:createIconProps(p31, n3)
	end
	local function windowProps(p32) -- line: 667
		-- upvalues: n3 (ref), p30 (copy), t2 (copy)
		n3 += 1

		if p30._integrations[p32] then
			return {
				id = p32,
				children = {},
				order = n3,
				component = p30._integrations[p32].components.Window,
				activated = noop,
				integration = p30._integrations[p32]
			}
		end

		return {
			id = p32,
			children = {},
			order = n3,
			activated = noop,
			integration = t2
		}
	end
	local function divider(_) -- line: 689
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
	local function collectMenu(p34, p35, p36) -- line: 702
		-- upvalues: divider (copy), n2 (ref), collectMenu (copy), FFlagEnableSideSheet (copy), p30 (copy), n3 (ref), windowProps (copy), iconProps (copy)
		local n4 = 0

		for k, v in pairs(p34) do
			if type(v) == "table" then
				if not #p35.children then
					table.insert(p35.children, (divider(n2)))
				end

				if collectMenu(v, p35, p36) > 0 then
					table.insert(p35.children, (divider(n2)))
				end
			else
				if typeof(v) ~= "string" then
					error(`Only tables or strings should be passed into the items list, received { v } (at key { k })`)
				end

				if not FFlagEnableSideSheet and p30._subMenuConfig[v] then
					if p30:isIntegrationValid(v) then
						n3 += 1

						local v261 = p30:createIconProps(v, n3)

						n4 += 1
						collectMenu(p30._subMenuConfig[v], v261, p36)

						if #v261.children > 0 then
							table.insert(p35.children, v261)
						end
					end
				elseif p30:isIntegrationValid(v) then
					if p30:isWindowOpen(v) then
						table.insert(p36, (windowProps(v)))
						table.insert(p35.children, iconProps(v))
						n4 += 1
					else
						table.insert(p35.children, iconProps(v))
						n4 += 1
					end
				end
			end
		end

		return n4
	end

	local t7 = {
		children = {}
	}
	local t8 = {}

	collectMenu(p30._menuConfig, t7, t8)

	if #t7.children and (t7.children[#t7.children] and t7.children[#t7.children].isDivider) then
		table.remove(t7.children, #t7.children)
	end

	if not FFlagReverseUnibar and p30._orderAlignment:get() == Enum.HorizontalAlignment.Left then
		t7.children = reverse(t7.children)
		reverseOrder(t7.children)
	end

	if FFlagEnableChromeWindowsNotInMenu then
		local t9 = {}

		for _, v110 in t8 do
			t9[v110.id] = true
		end

		for v111, _ in p30._integrations do
			if p30:isWindowOpen(v111) and not t9[v111] then
				table.insert(t8, (windowProps(v111)))
			end
		end
	end

	p30._menuList:set(t7.children)
	p30._windowList:set(t8)
	p30:repairSelected()
end

if FFlagEnableSideSheet then
	function t1.updateSideSheet(p37) -- line: 783
		-- upvalues: SideSheetPlacement (copy), FFlagReverseUnibar (copy), reverse (copy), FIntSideSheetVariant (copy), registerSideSheetIntegrations (ref)
		local n5 = 0
		local t10 = {}
		local t11 = {}
		local t12 = {}
		local t13 = {}

		local function addIntegration(p38) -- line: 790
			-- upvalues: p37 (copy), SideSheetPlacement (copy), t11 (ref), n5 (ref), t12 (copy), t13 (copy), t10 (ref)
			local v263 = p37._integrations[p38]

			if not v263 or (v263.sideSheetPlacement == SideSheetPlacement.None or not p37:isIntegrationValid(p38)) then
				return
			end

			if v263.sideSheetPlacement == SideSheetPlacement.Unibar then
				table.insert(t11, p37:createIconProps(p38, n5))

				return
			end

			if v263.sideSheetPlacement == SideSheetPlacement.Page then
				table.insert(t12, p37:createIconProps(p38, n5))

				return
			end

			if v263.sideSheetPlacement == SideSheetPlacement.SessionAction then
				table.insert(t13, p37:createIconProps(p38, n5))

				return
			end

			table.insert(t10, p37:createIconProps(p38, n5))
		end

		for _, v121 in p37._menuConfig do
			for _, v123 in v121 do
				n5 += 1
				addIntegration(v123)
			end
		end

		for _, v125 in p37._subMenuConfig do
			for _, v127 in v125 do
				n5 += 1
				addIntegration(v127)
			end
		end

		if not FFlagReverseUnibar and p37._orderAlignment:get() == Enum.HorizontalAlignment.Left then
			t11 = reverse(t11)
		end

		if FIntSideSheetVariant == 0 then
			for _, v129 in t10 do
				table.insert(t11, v129)
			end

			t10 = t11
			t11 = {}
		end

		registerSideSheetIntegrations({
			unibarIntegrations = t11,
			toggleIntegrations = t10,
			pageIntegrations = t12,
			sessionActionIntegrations = t13
		})
	end
end

function t1.availabilityChanged(p39, _) -- line: 849
	-- upvalues: FFlagEnableSideSheet (copy)
	p39:updateNotificationTotals()
	p39:updateMenuList()

	if FFlagEnableSideSheet then
		p39:updateSideSheet()
	end
end
function t1.subMenuNotifications(p41, p42) -- line: 857
	-- upvalues: NotifySignal (copy)
	if not p41._subMenuNotifications[p42] then
		p41._subMenuNotifications[p42] = NotifySignal.new(true)
	end

	return p41._subMenuNotifications[p42]
end
function t1.totalNotifications(p43) -- line: 864
	return p43._totalNotifications
end
function t1.onIntegrationRegistered(p44) -- line: 868
	return p44._onIntegrationRegistered
end
function t1.onIntegrationActivated(p45) -- line: 872
	return p45._onIntegrationActivated
end
function t1.onIntegrationHovered(p46) -- line: 876
	return p46._onIntegrationHovered
end
function t1.onIntegrationStatusChanged(p47) -- line: 880
	return p47._onIntegrationStatusChanged
end
function t1.integrations(p48) -- line: 884
	return p48._integrations
end
function t1.updateNotificationTotals(p49) -- line: 888
	-- upvalues: t1 (copy)
	local n6 = 0

	for _, v143 in p49._integrations do
		if v143.availability:get() ~= t1.AvailabilitySignal.Unavailable and v143.availability:get() ~= t1.AvailabilitySignal.Pinned and not v143.notification:excludeFromTotalCounts() then
			local v144 = v143.notification:get()

			if v144 and v144.type == "count" then
				assert(typeof(v144.value) == "number", "Expected count value to be number")
				n6 += v144.value
			end
		end
	end

	p49._totalNotifications:fireCount(n6)

	for v145, v146 in p49._subMenuNotifications do
		local v147 = p49:withinCurrentTopLevelMenu(v145)
		local n7 = 0

		if v147 then
			for _, v150 in v147.children do
				if not p49:withinCurrentTopLevelMenu(v150.id) and v150.integration.availability:get() ~= t1.AvailabilitySignal.Unavailable and not v150.integration.notification:excludeFromTotalCounts() then
					local v151 = v150.integration.notification:get()

					if v151 and v151.type == "count" then
						assert(typeof(v151.value) == "number", "Expected count value to be number")
						n7 += v151.value
					end
				end
			end

			v146:fireCount(n7)
		end
	end
end
function t1.configureMenu(p50, p51) -- line: 932
	p50._menuConfig = p51
	p50:updateNotificationTotals()
	p50:updateMenuList()
end
function t1.configureSubMenu(p52, p53, p54) -- line: 938
	-- upvalues: NotifySignal (copy), FFlagEnableSideSheet (copy)
	p52._subMenuConfig[p53] = p54

	if not p52._subMenuNotifications[p53] then
		p52._subMenuNotifications[p53] = NotifySignal.new(true)
	end

	p52:updateNotificationTotals()
	p52:updateMenuList()

	if FFlagEnableSideSheet then
		p52:updateSideSheet()
	end
end

if FFlagEnableConsoleExpControls then
	function t1.registerShortcut(p55, p56) -- line: 951
		-- upvalues: t1 (copy)
		p55._shortcutService:registerShortcut(p56)

		local v159 = p55._shortcutService:getShortcut(p56.id)

		if v159.integration and p55._integrations[v159.integration] then
			local v160 = p55._integrations[v159.integration]

			if v160.availability:get() == t1.AvailabilitySignal.Unavailable then
				v159.availability:unavailable()
			end

			v160.availability:connect(function() -- line: 959
				-- upvalues: v160 (copy), t1 (copy), v159 (copy)
				local v264 = v160.availability:get()

				if v264 == t1.AvailabilitySignal.Unavailable then
					v159.availability:unavailable()

					return
				end

				if v264 == t1.AvailabilitySignal.Available or v264 == t1.AvailabilitySignal.Pinned then
					v159.availability:available()
				end
			end)
		end
	end
	function t1.activateShortcut(p57, p58) -- line: 973
		-- upvalues: FFlagIntegrationsChromeShortcutTelemetry (copy)
		local v163 = p57._shortcutService:getShortcut(p58)

		if v163.integration then
			if not v163.activated then
				if FFlagIntegrationsChromeShortcutTelemetry then
					p57:activate(v163.integration, {
						fromShortcut = true
					})

					return
				end

				p57:activate(v163.integration)

				return
			end

			if FFlagIntegrationsChromeShortcutTelemetry then
				p57._shortcutService:activateShortcut(p58)
				p57._onIntegrationActivated:fire(v163.integration, {
					fromShortcut = true
				})

				return
			end
		else
			p57._shortcutService:activateShortcut(p58)
		end
	end
	function t1.configureShortcutBar(p59, p60, p61) -- line: 993
		p59._shortcutService:configureShortcutBar(p60, p61)
	end
	function t1.setShortcutBar(p62, p63) -- line: 997
		p62._shortcutService:setShortcutBar(p63)
	end
	function t1.getCurrentShortcutBar(p64) -- line: 1001
		return p64._currentShortcutBar
	end
	function t1.getShortcutsFromBar(p65, p66) -- line: 1005
		return p65._shortcutService:getShortcutsFromBar(p66, p65._integrations)
	end
	function t1.getCurrentShortcuts(p67) -- line: 1009
		return p67:getShortcutsFromBar(p67._currentShortcutBar:get())
	end
	function t1.onShortcutBarChanged(p68) -- line: 1013
		return p68._shortcutService.onShortcutBarChanged
	end
	function t1.selectMenuIcon(p69) -- line: 1017
		p69._triggerMenuIcon:fire()
	end
	function t1.onTriggerMenuIcon(p70) -- line: 1021
		return p70._triggerMenuIcon
	end
	function t1.setHideShortcutBar(t14: {[any]: any}, p71, b4: boolean?) -- line: 1025
		t14._shortcutService:setHideShortcutBar(p71, b4)
	end
	function t1.getHideShortcutBar(p72) -- line: 1029
		return p72._shortcutService:getHideShortcutBar()
	end
end

if isInExperienceUIVREnabled then
	function t1.onTriggerVRToggleButton(p73) -- line: 1035
		return p73._triggerVRToggleButton
	end
	function t1.showTopBar(p74) -- line: 1039
		return p74._topBarVisibility:get()
	end
	function t1.getTopBarVisibiity(p75) -- line: 1043
		return p75._topBarVisibility
	end
	function t1.connectTopBarVisibility(p76, p77) -- line: 1047
		p76._topBarVisibility = p77
	end
end

function t1.gesture(t15: {[any]: any}, p78, t16: {[any]: any}?, p79) -- line: 1052
	if t15._integrations[p78] then
		t15._dragConnection[p78] = {
			connection = t16,
			inputObject = p79
		}
	end
end
function t1.withinCurrentTopLevelMenu(p80, p81) -- line: 1065
	for v191, v192 in (p80._menuList:get()) do
		if p81 == v192.id then
			return v192, v191
		end
	end

	return nil, 0
end
function t1.withinCurrentSubmenu(p82, p83) -- line: 1075
	local v195 = p82._currentSubMenu:get()

	if not v195 then
		return false
	end

	local children = nil

	for _, v198 in (p82._menuList:get()) do
		if v195 == v198.id then
			children = v198.children

			break
		end
	end

	if not children then
		return false
	end

	for _, v200 in children do
		if p83 == v200.id then
			return true
		end
	end

	return false
end

if FFlagEnableSideSheet then
	function t1.withinOpenSideSheet(p84, p85) -- line: 1105
		-- upvalues: getSideSheetVisibility (ref), SideSheetPlacement (copy)
		if not getSideSheetVisibility() then
			return false
		end

		for _, v204 in p84._integrations do
			if p85 == v204.id and v204.sideSheetPlacement ~= SideSheetPlacement.None then
				return true
			end
		end

		return false
	end
end

function t1.windowPosition(p86, p87) -- line: 1120
	return p86._windowPositions[p87]
end
function t1.updateWindowPosition(t17: {[any]: any}, p88, uDim2: UDim2) -- line: 1124
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() and (t17._integrations[p88] and t17._integrations[p88].persistWindowState) then
		local v210 = LocalStore.loadForLocalPlayer("ChromeWindowPosition") or {}

		v210[p88] = {
			uDim2.X.Scale,
			uDim2.X.Offset,
			uDim2.Y.Scale,
			uDim2.Y.Offset
		}
		LocalStore.storeForLocalPlayer("ChromeWindowPosition", v210)
	end

	t17._windowPositions[p88] = uDim2
end
function t1.getWindowStatusFromStore(_, p90) -- line: 1137
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() then
		return (LocalStore.loadForLocalPlayer("ChromeWindowStatus") or {})[p90] or false
	end

	return nil
end
function t1.getWindowPositionFromStore(_, p92) -- line: 1147
	-- upvalues: LocalStore (copy)
	if LocalStore.isEnabled() then
		local v215 = (LocalStore.loadForLocalPlayer("ChromeWindowPosition") or {})[p92] or nil

		if v215 then
			return (UDim2.new(v215[1], v215[2], v215[3], v215[4]))
		end

		return nil
	end

	return nil
end
function t1.activate(p93, p94, p95) -- line: 1158
	-- upvalues: FFlagIntegrationsChromeShortcutTelemetry (copy), FFlagEnableConsoleExpControls (copy)
	local v219 = nil

	if p93._integrations[p94] then
		local activated = p93._integrations[p94].activated

		if FFlagIntegrationsChromeShortcutTelemetry then
			p93._onIntegrationActivated:fire(p94, p95)
		else
			p93._onIntegrationActivated:fire(p94)
		end

		p93:storeChromeInteracted()

		if activated then
			local ok, result = pcall(function() -- line: 1174
				-- upvalues: activated (copy), p93 (copy), p94 (copy), FFlagEnableConsoleExpControls (copy)
				activated(p93._integrations[p94])

				if not FFlagEnableConsoleExpControls then
					p93:disableFocusNav()
				end
			end)

			if not ok then
				warn("ChromeService: activate error thrown for " .. p94)
				v219 = result
			end
		else
			if p93._subMenuConfig[p94] then
				p93:toggleSubMenu(p94)
			end

			p93:toggleWindow(p94)
		end

		if p94 ~= p93._currentSubMenu:get() then
			p93._currentSubMenu:set(nil)
		end
	end

	if v219 then
		error(v219)
	end
end
function t1.selectedItem(p96) -- line: 1202
	return p96._selectedItem
end
function t1.setSelected(p97, p98) -- line: 1206
	-- upvalues: UserInputService (copy)
	local v226, v227 = p97:withinCurrentTopLevelMenu(p98 or "")

	if not v226 then
		return
	end

	local LastInputType = UserInputService:GetLastInputType()
	local v229 = LastInputType == Enum.UserInputType.MouseButton1 or LastInputType == Enum.UserInputType.Touch
	local v230 = p97._currentSubMenu:get()

	if v230 and v230 ~= p98 and not v229 then
		p97:toggleSubMenu(v230)
	end

	p97._selectedItemIdx = v227
	p97._selectedItem:set(p98)
end
function t1.setSelectedByOffset(t18: {[any]: any}, n8: number) -- line: 1224
	local v233 = t18._menuList:get()
	local _, v235 = t18:withinCurrentTopLevelMenu(t18._selectedItem:get() or "")

	if v235 > 0 then
		t18:setSelected(v233[math.clamp(v235 + n8, 1, #v233)].id)
	end
end
function t1.repairSelected(p99) -- line: 1234
	if p99._selectedItem:get() then
		local _, v238 = p99:withinCurrentTopLevelMenu(p99._selectedItem:get() or "")

		if v238 == 0 then
			v238 = p99._selectedItemIdx
		end

		local v239 = p99._menuList:get()

		p99:setSelected(v239[math.clamp(v238, 1, #v239)].id)
	end
end
function t1.configureOrderAlignment(p100, p101) -- line: 1248
	if p101 ~= p100._orderAlignment:get() then
		p100._orderAlignment:set(p101)
		p100:updateMenuList()
	end
end
function t1.orderAlignment(p102) -- line: 1255
	return p102._orderAlignment
end
function t1.setMenuAbsolutePosition(t19: {[any]: any}, vector2: Vector2) -- line: 1259
	if vector2 ~= t19._menuAbsolutePosition then
		t19._menuAbsolutePosition = vector2
		t19._layout:set(createUnibarLayoutInfo(vector2, t19._menuAbsoluteSizeOpen))
	end
end
function t1.setMenuAbsoluteSize(t20: {[any]: any}, vector2: Vector2) -- line: 1266
	if vector2 ~= t20._menuAbsoluteSizeOpen then
		t20._menuAbsoluteSizeOpen = vector2
		t20._layout:set(createUnibarLayoutInfo(t20._menuAbsolutePosition, vector2))
	end
end
function t1.layout(p103) -- line: 1273
	return p103._layout
end

return t1
