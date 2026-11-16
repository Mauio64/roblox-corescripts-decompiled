local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local PanelType = VrSpatialUi.Constants.PanelType
local Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
local parent = script.Parent.Parent.Parent
local Unibar = require(parent.Chrome.ChromeShared.Unibar)
local MenuIcon = require(parent.TopBar.Components.Presentation.MenuIcon)
local MenuIcon2 = require(parent.TopBar.ComponentsV2.MenuIcon)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeKeepOutAreas = CoreGuiCommon.Flags.FFlagTopBarSignalizeKeepOutAreas

local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local ExperienceAgeRatingBadge = require(CorePackages.Workspace.Packages.InExperienceTopBar.ExperienceAgeRatingBadge)
local FFlagExperienceAgeRatingBadge = InExperienceTopBar.Flags.FFlagExperienceAgeRatingBadge
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating
local v = FFlagExperienceAgeRatingBadge and FFlagShowGameAgeRating
local FFlagTopBarRefactor = InExperienceTopBar.Flags.FFlagTopBarRefactor

local function MenuIconWrapper(p)
	local v2

	if FFlagTopBarSignalizeKeepOutAreas then
		v2 = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	end

	local iconScale = useSelector(function(p2)
		if p2 and p2.displayOptions then
			return p2.displayOptions.menuOpen
		end

		return false
	end) and 1.5 or 1

	if FFlagTopBarRefactor then
		return (React.createElement(MenuIcon2, { showBadgeOver12 = p.showBadgeOver12 }))
	end

	local createElement = React.createElement
	local v3 = {
		layout = p.layout,
		iconScale = iconScale,
		showBadgeOver12 = p.showBadgeOver12,
		onAreaChanged = 0
	}
	local onAreaChanged

	if FFlagTopBarSignalizeKeepOutAreas then
		onAreaChanged = v2.setKeepOutArea
	end

	v3.onAreaChanged = onAreaChanged
	return (createElement(MenuIcon, v3))
end

local function VRBottomUnibar(p)
	local v2 = v and p.showBadgeOver12 == true
	local v3 = nil
	local v4 = nil
	local v5

	if FFlagExperienceAgeRatingBadge and FFlagShowGameAgeRating then
		local v6
		v3, v6 = React.useBinding(true)
		v4 = v6
		v5 = React.useCallback(function(p2)
			v4(p2.GroupTransparency < 1)
		end, { v4 })
	else
		v5 = nil
	end

	if not Panel3DInSpatialUI then
		return nil
	end

	local createElement = React.createElement
	local v6 = {
		panelType = PanelType.BottomBar,
		keepVisibleWhenTopBarHidden = 0,
		controlsVisible = 0,
		renderFunction = 0,
		requireCanvasGroup = 0
	}
	local keepVisibleWhenTopBarHidden

	if v then
		keepVisibleWhenTopBarHidden = v2
	end

	v6.keepVisibleWhenTopBarHidden = keepVisibleWhenTopBarHidden
	local controlsVisible

	if v then
		controlsVisible = v3
	end

	v6.controlsVisible = controlsVisible
	function v6.renderFunction(vector2: Vector2)
		local createElement2 = React.createElement
		local v7 = {}
		v7.Name = v and "AnimatablePanelManagedContent" or nil
		local visible

		if v then
			visible = v3
		end

		v7.Visible = visible
		v7[React.Change.GroupTransparency] = v5
		v7.BackgroundTransparency = 1
		v7.BorderSizePixel = 0
		local udim

		if v then
			udim = UDim2.fromOffset(0, vector2.Y)
		elseif FFlagTopBarRefactor then
			udim = UDim2.new(1, 0, 0, 0)
		else
			udim = UDim2.new(1, 0, 1, 0)
		end

		v7.Size = udim
		local automaticSize

		if v then
			automaticSize = Enum.AutomaticSize.X
		elseif FFlagTopBarRefactor then
			automaticSize = Enum.AutomaticSize.Y
		end

		v7.AutomaticSize = automaticSize

		local v8 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			MenuIconFrame = 0,
			UnibarFrame = 0
		}
		local menuIconFrame

		if FFlagTopBarRefactor then
			menuIconFrame = React.createElement(Foundation.View, {
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
					showBadgeOver12 = p.showBadgeOver12 and not v2
				})
			})
		else
			menuIconFrame = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X
				},
				{
					MenuIcon = React.createElement(MenuIconWrapper, {
						layout = 1,
						showBadgeOver12 = p.showBadgeOver12 and not v2
					})
				}
			)
		end

		v8.MenuIconFrame = menuIconFrame

		v8.UnibarFrame = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			},
			{
				Unibar = React.createElement(Unibar, {
					layoutOrder = 1,
					onAreaChanged = function() end,
					onMinWidthChanged = function() end
				})
			}
		)
		local element = createElement2(v and "CanvasGroup" or "Frame", v7, v8)

		if not v then
			return element
		end

		local createElement3 = React.createElement
		local v9 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
		local v10 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			}),
			Controls = element,
			AgeRating = 0
		}
		local ageRating

		if v2 then
			ageRating = React.createElement(ExperienceAgeRatingBadge, {
				universeId = tostring(game.GameId),
				layoutOrder = 1
			})
		end

		v10.AgeRating = ageRating
		return createElement3("Frame", v9, v10)
	end

	v6.requireCanvasGroup = not v
	return createElement(Panel3DInSpatialUI, v6)
end

return React.memo(VRBottomUnibar)
