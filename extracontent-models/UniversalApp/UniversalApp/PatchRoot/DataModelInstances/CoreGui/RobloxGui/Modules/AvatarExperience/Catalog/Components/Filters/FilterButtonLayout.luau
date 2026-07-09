local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local FilterButton = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButton)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXSlotsDesktopRedesign = AvatarExperienceFlags.FFlagAXSlotsDesktopRedesign
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXReduceCatalogFilterWidth = AvatarExperienceFlags.FFlagAXReduceCatalogFilterWidth

local function FilterButtonLayout(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), Focusable (copy), FFlagAXSlotsDesktopRedesign (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), FFlagAXReduceCatalogFilterWidth (copy), FilterButton (copy)
	local showFilterButton = t1.showFilterButton
	local v14 = not showFilterButton and 0 or 52
	local v15 = React.useRef(nil)

	return React.createElement(Focusable.Frame, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, t1.height),
		LayoutOrder = t1.layoutOrder,
		ref = t1.layoutRef,
		defaultChild = if not showFilterButton then nil else v15,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight
	}, {
		Layout = if FFlagAXSlotsDesktopRedesign or FFlagAXMoveCatalogFilterToL1Navigation then React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = if not FFlagAXReduceCatalogFilterWidth then nil else Enum.VerticalAlignment.Center
		}) else nil,
		FilterButton = showFilterButton and React.createElement(FilterButton, {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.new(0, 8, 0.5, 0),
			buttonRef = v15
		}),
		ContentFrame = React.createElement(Focusable.Frame, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, -v14, 1, 0),
			Position = UDim2.new(0, v14, 0, 0),
			LayoutOrder = if FFlagAXSlotsDesktopRedesign or FFlagAXMoveCatalogFilterToL1Navigation then not t1.showFilterRight and 1 or 0 else nil
		}, t1.children)
	})
end

return FilterButtonLayout
