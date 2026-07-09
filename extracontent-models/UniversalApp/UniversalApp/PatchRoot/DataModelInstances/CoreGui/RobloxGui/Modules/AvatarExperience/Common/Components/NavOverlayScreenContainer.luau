local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local NavOverlayContainer = require(Modules.AvatarExperience.Common.Components.NavOverlayContainer)
local with10ftUIPadding = require(Modules.AvatarExperience.Common.Components.with10ftUIPadding)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectGlobalGuiInset(p1) -- line: 54
	return p1.GlobalGuiInset
end
local function selectStatusBarHeight(p2) -- line: 58
	return p2.TopBar.statusBarHeight
end
local function NavOverlayScreenContainer(t1: {[any]: any}) -- line: 62
	-- upvalues: useStyle (copy), useSelector (copy), selectGlobalGuiInset (copy), selectIsPortrait (copy), selectStatusBarHeight (copy), React (copy), Foundation (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), NavOverlayContainer (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	local Theme = useStyle().Theme
	local v21 = useSelector(selectGlobalGuiInset)
	local v22 = useSelector(selectIsPortrait)
	local v23 = useSelector(selectStatusBarHeight)
	local BackgroundDefault = Theme.BackgroundDefault
	local v25 = v21.bottom > 0
	local designTokens = t1.designTokens
	local v27 = not designTokens and 0 or designTokens.bottomPadding
	local t2 = {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		AutoButtonColor = false,
		LayoutOrder = 3,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		Position = UDim2.fromOffset(0, 44),
		Size = UDim2.new(1, 0, 1, -(44 + v23) + v27)
	}
	local headerBarProps = t1.headerBarProps
	local v30 = React.createElement(Foundation.View, {
		tag = "row align-y-center size-full padding-x-small",
		BackgroundTransparency = 1
	}, {
		Left = if not headerBarProps.renderLeft then nil else React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 1,
			flexItem = {
				FlexMode = Enum.UIFlexMode.None
			}
		}, {
			Content = headerBarProps.renderLeft()
		}),
		TitleRegion = React.createElement(Foundation.View, {
			tag = "fill size-full-0 auto-xy clip",
			LayoutOrder = 2,
			flexItem = {
				FlexMode = Enum.UIFlexMode.Fill
			}
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "size-full-0 auto-y text-heading-small content-emphasis",
				Text = headerBarProps.title,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = if not v22 then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
			})
		}),
		Right = if not headerBarProps.renderRight then nil else React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 3,
			flexItem = {
				FlexMode = Enum.UIFlexMode.None
			}
		}, {
			Content = headerBarProps.renderRight()
		})
	})

	return React.createElement("TextButton", {
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		AutoButtonColor = false,
		ref = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t1.forwardRef,
		[React.Event.Activated] = t1.onDismiss,
		Selectable = if t1.onDismiss then nil else false
	}, {
		NavOverlayContainer = React.createElement(NavOverlayContainer, {
			ZIndex = t1.ZIndex
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			StatusBarBackground = React.createElement("TextButton", {
				LayoutOrder = 1,
				Text = "",
				BorderSizePixel = 0,
				AutoButtonColor = false,
				BackgroundColor3 = BackgroundDefault.Color,
				BackgroundTransparency = not v22 and 1 or BackgroundDefault.Transparency,
				Size = UDim2.new(1, 0, 0, v23),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			}),
			HeaderBarBackground = React.createElement("TextButton", {
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = 2,
				BackgroundColor3 = BackgroundDefault.Color,
				BackgroundTransparency = BackgroundDefault.Transparency,
				Size = UDim2.new(1, 0, 0, 44),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			}, {
				ManualHeader = v30
			}),
			ContentsFrame = React.createElement("ImageButton", t2, t1.children),
			BottomInsetBackground = if not v25 then nil else React.createElement("TextButton", {
				BorderSizePixel = 0,
				Text = "",
				ZIndex = 3,
				AutoButtonColor = false,
				LayoutOrder = 4,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v21.bottom),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			})
		})
	})
end

return (with10ftUIPadding(NavOverlayScreenContainer))
