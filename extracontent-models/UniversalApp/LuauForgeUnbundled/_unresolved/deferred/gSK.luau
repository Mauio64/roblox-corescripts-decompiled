local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local module = require("@luauforge/bundled/ehL")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local findValueKeyInRefCache = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local useStyle = UIBlox.Core.Style.useStyle

local module2 = require("@luauforge/deferred/gSL")
require("@luauforge/bundled/dKT")

local v5 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonL1] = focusNavigationEventNameEnum.TabBackward,
	[Enum.KeyCode.ButtonR1] = focusNavigationEventNameEnum.TabForward
}

local function useFocusNavigationBindings(p2, p3, p4, p5)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p3)
			},
			[focusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(p4)
			},
			[focusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(p5)
			}
		}
	end, { p3, p5, p4 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

return function(props)
	local v6 = RoactGamepad.useRefCache()
	local state, setState = React.useState({})

	local v7 = React.useCallback(function(p2)
		if not state[p2] then
			setState(Cryo.Dictionary.join(state, { [p2] = React.createRef() }))
		end

		return state[p2]
	end, { state })

	local layoutOrder = props.layoutOrder
	local navHeight = props.navHeight
	local zIndex = props.zIndex
	local selectedTabIndex = props.selectedTabIndex

	local theme = useStyle().Theme

	local mainNavigationRef = props.mainNavigationRef
	local v8 = useFocusGuiObject()

	local v13 = useTableWrappedCallbackRef((useFocusNavigationBindings(nil, React.useCallback(function(p2)
		p2.cancelled = true

		if v8 and props.NextSelectionUp and props.NextSelectionUp.current then
			v8(props.NextSelectionUp.current)
		end
	end, { v8, props.NextSelectionUp }), React.useCallback(function(p2)
		p2.cancelled = true
		local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v6)

		if valueKeyInRefCache and valueKeyInRefCache > 1 and v8 then
			v8(v6[valueKeyInRefCache - 1].current)
		end
	end, { v8, v6 }), React.useCallback(function(p2)
		p2.cancelled = true
		local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v6)

		if valueKeyInRefCache and valueKeyInRefCache < #v6 and v8 then
			v8(v6[valueKeyInRefCache + 1].current)
		end
	end, { v8, v6 }))))

	local v14 = React.useCallback(function(p2, p3)
		local v15 = selectedTabIndex == p2
		local selectTab = props.selectTab
		local tabs = props.tabs

		return React.createElement(module2, {
			tabIndex = p2,
			tabsLength = #tabs,
			tabTitle = p3.Title,
			layoutOrder = p2,
			isSelected = v15,
			frameRef = v7(p2),
			onActivate = function()
				selectTab(p2)
			end,
			ref = v6[p2]
		})
	end, { selectedTabIndex, props.selectTab, props.tabs, v6, v7 })

	local v15 = React.useCallback(function()
		local tabs = props.tabs

		local result = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		}

		for k, tab in tabs do
			result[tab.Name] = v14(k, tab)
		end

		return result
	end, { props.tabs, v14 })

	return React.createElement("Frame", {
		ClipsDescendants = true,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, navHeight),
		ZIndex = zIndex,
		ref = mainNavigationRef
	}, {
		NavFrame = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ref = v13 },
			v15()
		)
	})
end
