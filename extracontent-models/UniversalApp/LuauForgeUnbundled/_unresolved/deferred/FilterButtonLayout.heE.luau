local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local module = require("@luauforge/deferred/heF")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXSlotsDesktopRedesign = AvatarExperienceFlags.FFlagAXSlotsDesktopRedesign
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation

local function FilterButtonLayout(props)
	local showFilterButton = props.showFilterButton
	local v5 = showFilterButton and 52 or 0
	local ref = React.useRef(nil)

	local createElement = React.createElement
	local frame = focusable.Frame
	local v6 = {
		Size = UDim2.new(1, 0, 0, props.height),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ref = props.layoutRef,
		defaultChild = if showFilterButton then ref else nil,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight
	}

	local v9 = if fFlagAXSlotsDesktopRedesign or fFlagAXMoveCatalogFilterToL1Navigation then React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}) else nil
	return createElement(frame, v6, {
		Layout = v9,
		FilterButton = showFilterButton and React.createElement(module, {
			anchorPoint = Vector2.new(0, 0.5),
			position = UDim2.new(0, 8, 0.5, 0),
			buttonRef = ref
		}),
		ContentFrame = React.createElement(focusable.Frame, {
			Size = UDim2.new(1, -v5, 1, 0),
			Position = UDim2.new(0, v5, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = (fFlagAXSlotsDesktopRedesign or fFlagAXMoveCatalogFilterToL1Navigation) and (props.showFilterRight and 0 or 1) or nil
		}, props.children)
	})
end

return FilterButtonLayout
