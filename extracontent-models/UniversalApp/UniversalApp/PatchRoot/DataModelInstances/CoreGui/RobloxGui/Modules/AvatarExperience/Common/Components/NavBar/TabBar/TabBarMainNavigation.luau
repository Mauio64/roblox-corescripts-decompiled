local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local findValueKeyInRefCache = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local useStyle = UIBlox.Core.Style.useStyle
local TabBarButton = require(Modules.AvatarExperience.Common.Components.NavBar.TabBar.TabBarButton)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local v18 = game:DefineFastFlag("AXMigrateTabBarMainNavigationToFocusNavigation2", false)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward,
	[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 42
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v25 = ReactFocusNavigation.useEventMap(t1, p1)
	local v26 = React.useMemo(function() -- line: 49
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy), p3 (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p2)
			},
			[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(p3)
			},
			[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(p4)
			}
		}
	end, {
		p2,
		p4,
		p3
	})

	return ReactFocusNavigation.useEventHandlerMap(v26, v25)
end

return function(t2: {[any]: any}) -- line: 78
	-- upvalues: RoactGamepad (copy), React (copy), Cryo (copy), useStyle (copy), useFocusGuiObject (copy), v18 (copy), findValueKeyInRefCache (copy), GuiService (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), TabBarButton (copy)
	local v28 = RoactGamepad.useRefCache()
	local v29, v30 = React.useState({})
	local v31 = React.useCallback(function(p5) -- line: 82
		-- upvalues: v29 (copy), v30 (copy), Cryo (copy), React (copy)
		if not v29[p5] then
			v30(Cryo.Dictionary.join(v29, {
				[p5] = React.createRef()
			}))
		end

		return v29[p5]
	end, { v29 })
	local layoutOrder = t2.layoutOrder
	local navHeight = t2.navHeight
	local zIndex = t2.zIndex
	local selectedTabIndex = t2.selectedTabIndex
	local Theme = useStyle().Theme
	local mainNavigationRef = t2.mainNavigationRef
	local v38 = useFocusGuiObject()
	local v39 = nil

	if v18 then
		local v40 = React.useCallback(function(p6) -- line: 105
			-- upvalues: v38 (copy), t2 (copy)
			p6.cancelled = true

			if v38 and (t2.NextSelectionUp and t2.NextSelectionUp.current) then
				v38(t2.NextSelectionUp.current)
			end
		end, {
			v38,
			t2.NextSelectionUp
		})
		local v41 = React.useCallback(function(p7) -- line: 114
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v28 (copy), v38 (copy)
			p7.cancelled = true

			local v49 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v28)

			if v49 and (v49 > 1 and v38) then
				v38(v28[v49 - 1].current)
			end
		end, { v38 })
		local v42 = React.useCallback(function(p8) -- line: 123
			-- upvalues: findValueKeyInRefCache (copy), GuiService (copy), v28 (copy), v38 (copy)
			p8.cancelled = true

			local v51 = findValueKeyInRefCache(GuiService.SelectedCoreObject, v28)

			if v51 and (v51 < #v28 and v38) then
				v38(v28[v51 + 1].current)
			end
		end, { v38 })
		local v43 = useFocusNavigationBindings(nil, v40, v41, v42)

		v39 = useTableWrappedCallbackRef(v43)
	end

	local v44 = React.useCallback(function(p9, p10) -- line: 136
		-- upvalues: selectedTabIndex (copy), t2 (copy), React (copy), TabBarButton (copy), v31 (copy), v28 (copy)
		local v54 = p9 == selectedTabIndex
		local selectTab = t2.selectTab
		local tabs = t2.tabs

		return React.createElement(TabBarButton, {
			tabIndex = p9,
			tabsLength = #tabs,
			tabTitle = p10.Title,
			layoutOrder = p9,
			isSelected = v54,
			frameRef = v31(p9),
			onActivate = function() -- line: 148
				-- upvalues: selectTab (copy), p9 (copy)
				selectTab(p9)
			end,
			ref = v28[p9]
		})
	end, {
		selectedTabIndex,
		t2.selectTab,
		t2.tabs,
		v28,
		v31
	})
	local v45 = React.useCallback(function() -- line: 161
		-- upvalues: t2 (copy), React (copy), v44 (copy)
		local tabs = t2.tabs
		local t3 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		}

		for v59, v60 in tabs do
			t3[v60.Name] = v44(v59, v60)
		end

		return t3
	end, {
		t2.tabs,
		v44
	})

	return React.createElement("Frame", {
		ClipsDescendants = true,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, navHeight),
		ZIndex = zIndex,
		ref = mainNavigationRef
	}, {
		NavFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ref = if not v18 then nil else v39
		}, v45())
	})
end
