local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useTokens = Foundation.Hooks.useTokens
local SlotNavigation = require(script.Parent.Parent.SlotNavigation)
local SlotSubNavigation = require(script.Parent.Parent.SlotSubNavigation)
local FilterButtonLayout = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButtonLayout)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXSlotsDesktopRedesign = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDesktopRedesign
local FFlagAXMoveCatalogFilterToL1Navigation = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXSlotsDisableScrollAwayOnLandscape = AvatarExperienceFlags.FFlagAXSlotsDisableScrollAwayOnLandscape

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 34
	-- upvalues: useTokens (copy), Responsive (copy), FFlagAXSlotsDesktopRedesign (copy), FFlagAXSlotsDisableScrollAwayOnLandscape (copy), React (copy), FilterButtonLayout (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), SlotNavigation (copy), SlotSubNavigation (copy), Foundation (copy)
	local v16 = useTokens()
	local v17 = Responsive.useOrientation()
	local v18 = if not FFlagAXSlotsDesktopRedesign then v17 == Responsive.BreakpointConfig.Enum.Portrait else nil
	local v19 = if not FFlagAXSlotsDisableScrollAwayOnLandscape then nil else React.useMemo(function() -- line: 42
		-- upvalues: t1 (copy)
		if t1.disableScrollAway then
			return 1
		end

		return t1.slotSubNavigationFill
	end, {
		t1.disableScrollAway,
		t1.slotSubNavigationFill
	})

	React.useEffect(function() -- line: 48
		-- upvalues: t1 (copy), FFlagAXSlotsDisableScrollAwayOnLandscape (copy), v19 (copy)
		if t1.absoluteSizeChanged then
			t1.absoluteSizeChanged(Vector2.new(0, if not FFlagAXSlotsDisableScrollAwayOnLandscape then t1.navigationFrameHeight - (1 - t1.slotSubNavigationFill) * t1.slotCardTotalHeight else t1.navigationFrameHeight - (1 - v19) * t1.slotCardTotalHeight))
		end
	end, {
		t1.absoluteSizeChanged,
		t1.navigationFrameHeight,
		t1.slotSubNavigationFill,
		t1.slotCardTotalHeight,
		if not FFlagAXSlotsDisableScrollAwayOnLandscape then nil else v19
	})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v16.Color.Surface.Surface_0.Color3,
		ref = p1
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v16.Radius.Medium)
		}),
		NavigationFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			SlotNavigationFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				ZIndex = 3,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				ref = p1
			}, {
				Padding = if not FFlagAXSlotsDesktopRedesign and not v18 then React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v16.Size.Size_200),
					PaddingBottom = UDim.new(0, v16.Size.Size_500),
					PaddingLeft = UDim.new(0, v16.Size.Size_100)
				}) else nil,
				SlotNavigation = if not FFlagAXSlotsDesktopRedesign and not v18 then React.createElement(SlotNavigation, t1.slotNavigationProps) else React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, { React.createElement(FilterButtonLayout, {
					layoutOrder = 0,
					height = t1.navHeight,
					showFilterButton = not t1.hideFilter,
					showFilterRight = FFlagAXSlotsDesktopRedesign and true or (not not FFlagAXMoveCatalogFilterToL1Navigation or nil)
				}, { React.createElement(SlotNavigation, t1.slotNavigationProps) }) }),
				SlotSubNavigation = if not FFlagAXSlotsDesktopRedesign and not v18 then React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					Position = UDim2.new(0, 0, 0, t1.navigationFrameHeight - t1.slotCardTotalHeight)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v16.Size.Size_200)
					}),
					React.createElement(SlotSubNavigation, t1.slotSubNavigationProps)
				}) else if not (#t1.slotSubNavigationProps.slots > 0) then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 0,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, if not FFlagAXSlotsDisableScrollAwayOnLandscape then t1.slotCardTotalHeight * t1.slotSubNavigationFill else t1.slotCardTotalHeight * v19),
					Position = UDim2.new(0, 0, 0, t1.navigationFrameHeight - t1.slotCardTotalHeight)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, if not FFlagAXSlotsDisableScrollAwayOnLandscape then t1.slotCardTotalHeight * t1.slotSubNavigationFill else t1.slotCardTotalHeight * v19)
					}),
					BackgroundFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, -t1.slotCardTotalHeight)
					}, {
						SlotsFrame = React.createElement("Frame", {
							BackgroundTransparency = 0,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundColor3 = v16.Color.Surface.Surface_100.Color3
						}, {
							Slots = React.createElement(SlotSubNavigation, t1.slotSubNavigationProps)
						})
					})
				})
			})
		})
	})
end))
