local TenFootUiGlobalNav = script:FindFirstAncestor("TenFootUiGlobalNav")
local TenFootUiGlobalNavParent = TenFootUiGlobalNav.Parent
local Cryo = require(TenFootUiGlobalNavParent.Cryo)
local React = require(TenFootUiGlobalNavParent.React)
local UIBlox = require(TenFootUiGlobalNavParent.UIBlox)
local Style = require(TenFootUiGlobalNavParent.Style)
local AppHeaderBar = require(TenFootUiGlobalNavParent.AppHeaderBar).AppHeaderBar
local NavigationBar = UIBlox.App.Navigation.NavigationBar
local NavigationTab = UIBlox.App.Navigation.NavigationTab
local NavigationBarAlignment = UIBlox.App.Navigation.Enum.NavigationBarAlignment
local NavigationTabLayout = UIBlox.App.Navigation.Enum.NavigationTabLayout
local Placement = UIBlox.App.Navigation.Enum.Placement
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local useDesignTokens = Style.useDesignTokens
local v15 = game:DefineFastFlag("LuaAppFix10ftGlobalNavAppHeaderBarSelection", false)

require(TenFootUiGlobalNav.Components.GlobalNav.GlobalNav)

local FFlagEnableConsoleRobloxLogo = require(TenFootUiGlobalNavParent.SharedFlags).FFlagEnableConsoleRobloxLogo

return (React.forwardRef(function(p1, _) -- line: 24
	-- upvalues: TenFootUiGlobalNavParent (copy), useDesignTokens (copy), React (copy), NavigationTab (copy), Placement (copy), NavigationTabLayout (copy), NavigationBar (copy), NavigationBarAlignment (copy), v15 (copy), FFlagEnableConsoleRobloxLogo (copy), Cryo (copy), UtilityActionIcon (copy), AppHeaderBar (copy)
	local FlyoutLeftHeader = require(TenFootUiGlobalNavParent.FlyoutSidePanel).Components.FlyoutLeftHeader
	local tabGroupProps = p1.tabGroupProps
	local optionGroupProps = p1.optionGroupProps
	local v22 = useDesignTokens(function(p3) -- line: 29
		return {
			safeAreaMargin = p3.Size.Size_1600,
			tabGroupHeight = p3.Size.Size_1200,
			tabLabelFontStyle = p3.Typography.HeadingSmall,
			defaultSpacing = p3.Size.Size_800
		}
	end)
	local v23 = if not tabGroupProps or not tabGroupProps.selection then nil else tabGroupProps.selection[1]
	local v24 = React.useCallback(function(p4, b1: boolean) -- line: 42
		-- upvalues: React (copy), NavigationTab (copy), Placement (copy), v22 (copy), NavigationTabLayout (copy)
		return React.createElement(NavigationTab, {
			hasLabel = true,
			iconImage = p4.icon,
			renderIcon = if p4.iconComponent == nil then nil else function(b2: boolean) -- line: 46
				-- upvalues: React (copy), p4 (copy), Placement (copy)
				return React.createElement(p4.iconComponent, {
					pressed = false,
					hovered = false,
					placement = Placement.Bottom,
					selected = b2
				})
			end,
			labelText = p4.title,
			labelTypography = v22.tabLabelFontStyle,
			isChecked = b1,
			layout = NavigationTabLayout.Inline,
			onActivated = p4.onActivated
		})
	end, { v22 })
	local v25 = React.useCallback(function() -- line: 65
		-- upvalues: React (copy), tabGroupProps (copy), NavigationBar (copy), NavigationBarAlignment (copy), v22 (copy), v15 (copy), v23 (copy), v24 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			TabGroup = if not tabGroupProps then nil else React.createElement(NavigationBar, {
				maxWidth = 1e999,
				alignment = NavigationBarAlignment.Left,
				size = UDim2.new(0, 0, 0, v22.tabGroupHeight),
				automaticSize = Enum.AutomaticSize.X,
				selection = if not v15 then tabGroupProps.selection else v23,
				items = tabGroupProps.items,
				renderItem = v24,
				spacing = UDim.new(0, v22.defaultSpacing),
				paddings = if not tabGroupProps.padding then nil else {
					Left = tabGroupProps.padding.left or 0,
					Top = tabGroupProps.padding.top or 0,
					Right = tabGroupProps.padding.right or 0,
					Bottom = tabGroupProps.padding.bottom or 0
				},
				backgroundColor = {
					Transparency = 1
				}
			})
		})
	end, if not v15 then {
		v24,
		tabGroupProps,
		v22
	} else {
		v24,
		tabGroupProps,
		v22,
		v23
	})
	local v26 = if not FFlagEnableConsoleRobloxLogo then nil else React.useCallback(function() -- line: 104
		-- upvalues: React (copy), FlyoutLeftHeader (copy)
		return React.createElement(FlyoutLeftHeader, {
			alwaysShowLogo = true,
			isRobloxLogoEnabled = true,
			isFlyoutEntrypointEnabled = false
		})
	end, {})
	local v27 = React.useCallback(function() -- line: 113
		-- upvalues: Cryo (copy), optionGroupProps (copy), React (copy), UtilityActionIcon (copy), v22 (copy)
		local v31 = Cryo.List.map(if not optionGroupProps then {} else optionGroupProps.items, function(p5, n1: number) -- line: 116
			-- upvalues: React (copy), UtilityActionIcon (copy)
			return React.createElement(UtilityActionIcon, {
				disableOutset = true,
				icon = p5.icon,
				tooltipText = p5.label,
				layoutOrder = n1,
				onActivated = p5.onActivated
			})
		end)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X
		}, Cryo.Dictionary.join({
			UILayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v22.defaultSpacing)
			})
		}, v31))
	end, {
		optionGroupProps,
		v22
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		AppHeaderBarLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		AppHeaderBar = React.createElement(AppHeaderBar, {
			automaticHeight = true,
			onMedia = false,
			renderNavigation = if not FFlagEnableConsoleRobloxLogo then v25 else v26,
			renderCenter = if not FFlagEnableConsoleRobloxLogo then nil else v25,
			renderUtilities = v27,
			shouldRenderCenter = not not FFlagEnableConsoleRobloxLogo or nil,
			paddingLeft = UDim.new(0, v22.safeAreaMargin),
			paddingRight = UDim.new(0, v22.safeAreaMargin),
			groupTransparencyLeft = if not FFlagEnableConsoleRobloxLogo then {
				transparency = p1.animationProps.tabGroupTransparency,
				guiObjectRef = p1.animationProps.tabGroupRef
			} else {
				transparency = p1.animationProps.logoGroupTransparency,
				guiObjectRef = p1.animationProps.logoGroupRef
			},
			groupTransparencyCenter = if not FFlagEnableConsoleRobloxLogo then nil else {
				transparency = p1.animationProps.tabGroupTransparency,
				guiObjectRef = p1.animationProps.tabGroupRef
			},
			groupTransparencyRight = {
				transparency = p1.animationProps.optionGroupTransparency,
				guiObjectRef = p1.animationProps.optionGroupRef
			},
			backgroundStyle = {
				Transparency = 1,
				Color3 = Color3.new(0, 0, 0)
			}
		})
	})
end))
