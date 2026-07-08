local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local PanelType = VrSpatialUi.Constants.PanelType
local Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
local ParentParent = script.Parent.Parent.Parent
local Unibar = require(ParentParent.Chrome.ChromeShared.Unibar)
local MenuIcon = require(ParentParent.TopBar.Components.Presentation.MenuIcon)
local MenuIcon2 = require(ParentParent.TopBar.ComponentsV2.MenuIcon)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas
local FFlagTopBarRefactor = require(CorePackages.Workspace.Packages.InExperienceTopBar).Flags.FFlagTopBarRefactor

local function MenuIconWrapper(p1) -- line: 27
	-- upvalues: FFlagTopBarSignalizeKeepOutAreas (copy), CoreGuiCommon (copy), useSelector (copy), FFlagTopBarRefactor (copy), React (copy), MenuIcon2 (copy), MenuIcon (copy)
	local v18 = nil

	if FFlagTopBarSignalizeKeepOutAreas then
		v18 = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end

	local v19 = not useSelector(function(p2) -- line: 33
		if p2 and p2.displayOptions then
			return p2.displayOptions.menuOpen
		end

		return false
	end) and 1 or 1.5

	if FFlagTopBarRefactor then
		return (React.createElement(MenuIcon2, {
			showBadgeOver12 = p1.showBadgeOver12
		}))
	end

	return (React.createElement(MenuIcon, {
		layout = p1.layout,
		iconScale = v19,
		showBadgeOver12 = p1.showBadgeOver12,
		onAreaChanged = if not FFlagTopBarSignalizeKeepOutAreas then nil else v18.setKeepOutArea
	}))
end
local function VRBottomUnibar(t1: {[any]: any}) -- line: 49
	-- upvalues: Panel3DInSpatialUI (copy), React (copy), PanelType (copy), FFlagTopBarRefactor (copy), Foundation (copy), MenuIconWrapper (copy), Unibar (copy)
	if not Panel3DInSpatialUI then
		return nil
	end

	return React.createElement(Panel3DInSpatialUI, {
		requireCanvasGroup = true,
		panelType = PanelType.BottomBar,
		renderFunction = function() -- line: 55
			-- upvalues: React (copy), FFlagTopBarRefactor (copy), Foundation (copy), MenuIconWrapper (copy), t1 (copy), Unibar (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = if not FFlagTopBarRefactor then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 0),
				AutomaticSize = if not FFlagTopBarRefactor then nil else Enum.AutomaticSize.Y
			}, {
				ListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 8)
				}),
				MenuIconFrame = if not FFlagTopBarRefactor then React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					MenuIcon = React.createElement(MenuIconWrapper, {
						layout = 1,
						showBadgeOver12 = t1.showBadgeOver12
					})
				}) else React.createElement(Foundation.View, {
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					aspectRatio = {
						AspectRatio = 1,
						AspectType = Enum.AspectType.ScaleWithParentSize,
						DominantAxis = Enum.DominantAxis.Height
					}
				}, {
					MenuIcon = React.createElement(MenuIconWrapper, {
						layout = 1,
						showBadgeOver12 = t1.showBadgeOver12
					})
				}),
				UnibarFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					Unibar = React.createElement(Unibar, {
						layoutOrder = 1,
						onAreaChanged = function() -- line: 102
						end,
						onMinWidthChanged = function() -- line: 103
						end
					})
				})
			})
		end
	})
end

return React.memo(VRBottomUnibar)
