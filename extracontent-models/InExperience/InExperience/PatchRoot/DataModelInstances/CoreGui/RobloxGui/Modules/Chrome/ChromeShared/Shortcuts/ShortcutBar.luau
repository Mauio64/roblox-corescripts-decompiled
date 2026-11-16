local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local GamepadConnector = require(ChromeShared.Parent.Parent.TopBar.Components.GamepadConnector)

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local shortcutBar = UIBlox.App.Navigation.ShortcutBar
require(CorePackages.Workspace.Packages.Chrome)
local Constants = require(ChromeShared.Unibar.Constants)
local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useTokens = Foundation.Hooks.useTokens
local Drawer = require(CorePackages.Workspace.Packages.Drawer)
local useDrawerAnimating = Drawer.Hooks.useDrawerAnimating

local Service = require(ChromeShared.Service)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local FFlagEnableDrawerAnimatingHook = SharedFlags.FFlagEnableDrawerAnimatingHook

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility

function ChromeShortcutBar(_)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState({})
	local enabled, v = React.useBinding(false)
	local v2 = useTokens()

	local v3 = useObservableValue(ViewportUtil.screenSize)
	local ref = React.useRef(0)

	local function checkOverflow()
		if ref.current > v3.X then
			local v4 = 1

			for k, v5 in state do
				if v5.displayPriority <= state[v4].displayPriority then
					v4 = k
				end
			end

			local clone = table.clone(state)
			table.remove(clone, v4)
			setState2(clone)
		end
	end

	React.useEffect(function()
		setState2({})
		checkOverflow()
	end, { v3 })

	React.useEffect(function()
		local function updateShortcuts()
			if FFlagGamepadIconSupportCheck and not GamepadConnector:getGamepadActive():get() then
				return
			end

			setState((Service:getCurrentShortcuts()))
			setState2({})
		end

		Service:onShortcutBarChanged():connect(updateShortcuts)

		if FFlagGamepadIconSupportCheck then
			UserInputService.LastInputTypeChanged:Connect(updateShortcuts)
		end

		if not isSpatial() then
			local showTopBar = GamepadConnector:getShowTopBar()
			local gamepadActive = GamepadConnector:getGamepadActive()

			if FFlagEnableConsoleExpControls then
				local function shouldHideShortcutBar() -- 1 equivalent call inferred from this helper
					Service:setHideShortcutBar("TopBar", not (showTopBar:get() and gamepadActive:get()))
				end

				shouldHideShortcutBar() -- inferred equivalent call
				showTopBar:connect(shouldHideShortcutBar)
				gamepadActive:connect(shouldHideShortcutBar)
			else
				local function shouldShowShortcutBar()
					v(showTopBar:get() and gamepadActive:get())
				end

				showTopBar:connect(shouldShowShortcutBar)
				gamepadActive:connect(shouldShowShortcutBar)
			end
		end
	end, {})

	if isSideSheetEnabled and FFlagSideSheetFocusNav and FFlagEnableDrawerAnimatingHook then
		local sideSheetVisibility = getSideSheetVisibility(false)

		local v4 = useDrawerAnimating()

		React.useEffect(function()
			Service:setHideShortcutBar("SideSheet", sideSheetVisibility or v4)
		end, { sideSheetVisibility, v4 })
	end

	if not (#state2 > 0) then
		state2 = state
	end

	local items = {}

	for _, v4 in state2 do
		if not v4.label then
			continue
		end

		local v5 = { icon = "", text = "" }

		if v4.icon then
			v5.icon = v4.icon
		end

		v5.text = v4.label

		table.insert(items, v5)
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local shortcutBar2 = {
		Name = "ShortcutBar",
		DisplayOrder = Constants.SHORTCUTBAR_DISPLAYORDER,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Enabled = 0
	}

	if FFlagEnableConsoleExpControls then
		enabled = nil
	end

	shortcutBar2.Enabled = enabled
	return createPortal({
		Name = createElement("ScreenGui", shortcutBar2, { React.createElement("Frame", {
				Name = "ShortcutBarWrapper",
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0.5, 0, 1, not v2 and 0 or -v2.Gap.Medium),
				AnchorPoint = Vector2.new(0.5, 1),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = function(p)
					ref.current = p.AbsoluteSize.X
					checkOverflow()
				end
			}, {
				Layout = React.createElement("UIListLayout"),
				React.createElement(shortcutBar, { items = items })
			}) })
	}, CoreGui)
end

return ChromeShortcutBar
