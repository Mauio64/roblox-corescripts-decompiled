local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local SpringAnimatedItem = require(CorePackages.Packages.UIBlox).Utility.SpringAnimatedItem
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local selectTopBarHeight = require(Modules.LuaApp.Components.TopBar.Utils.selectTopBarHeight)
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty
local NamedRefsContext = require(Modules.AvatarExperience.Common.Context.NamedRefsContext)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local FullViewEntryButton = require(Modules.AvatarExperience.Common.Components.FullViewEntryButton)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useRouteName = require(CorePackages.Workspace.Packages.Navigation).useRouteName
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local vector2 = Vector2.new(8, 8)
local vector2_2 = Vector2.new(36, 36)
local t1 = {
	dampingRatio = 0.6,
	frequency = 4.25
}
local t2 = {
	dampingRatio = 1,
	frequency = 3.5
}

local function mapValuesToProps(p1) -- line: 45
	return {
		Size = UDim2.new(1, 0, 0, p1.height)
	}
end
local function selectDeviceOrientation(p2) -- line: 51
	return p2.DeviceOrientation
end
local function useTopPanelRef() -- line: 63
	-- upvalues: useRouteName (copy), React (copy), NamedRefsContext (copy)
	local v25 = useRouteName()

	return React.useContext(NamedRefsContext)[v25 .. "TopPanel"]
end
local function useButtonHeight(b1: boolean, n1: number) -- line: 69
	-- upvalues: useRouteName (copy), React (copy), NamedRefsContext (copy), useProperty (copy), useSelector (copy), selectDeviceOrientation (copy), getUseSelectorDeepEquals (copy), DeviceOrientationMode (copy), vector2_2 (copy), vector2 (copy)
	local v28 = useRouteName()
	local v29 = React.useContext(NamedRefsContext)[v28 .. "TopPanel"]
	local v30 = useProperty(v29, "Size") or UDim2.fromScale(0, 0)
	local v31 = useSelector(selectDeviceOrientation, getUseSelectorDeepEquals()) == DeviceOrientationMode.Portrait

	if b1 and v31 then
		n1 += vector2_2.Y + vector2.Y + 14 + v30.Y.Offset
	end

	return n1
end
local function SceneButtons(t3: {[any]: any}) -- line: 86
	-- upvalues: useSelector (copy), selectTopBarHeight (copy), getUseSelectorDeepEquals (copy), selectDeviceOrientation (copy), DeviceOrientationMode (copy), useButtonHeight (copy), t2 (copy), t1 (copy), React (copy), SpringAnimatedItem (copy), mapValuesToProps (copy), FullViewEntryButton (copy)
	local v33 = t3.isUIFullView or false
	local v34 = t3.sceneHeight or 0
	local isSceneFullView = t3.isSceneFullView
	local changeViewFunction = t3.changeViewFunction
	local t3ZIndex = t3.ZIndex
	local v38 = useSelector(selectTopBarHeight, getUseSelectorDeepEquals())
	local v39 = useSelector(selectDeviceOrientation, getUseSelectorDeepEquals()) == DeviceOrientationMode.Portrait
	local v40 = useButtonHeight(v33, v34)
	local n2 = 0
	local v42

	if not v33 then
		v42 = t2
		n2 = 11
	else
		v42 = t1
	end

	local v43 = v39 and v38 or 0

	return React.createElement(SpringAnimatedItem.AnimatedFrame, {
		regularProps = {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, v43),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = t3ZIndex,
			Visible = changeViewFunction ~= nil and (v39 or isSceneFullView)
		},
		animatedValues = {
			height = v40
		},
		mapValuesToProps = mapValuesToProps,
		springOptions = v42
	}, {
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0),
			Size = UDim2.fromScale(1, 1)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 14)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, n2),
				PaddingRight = UDim.new(0, n2)
			}),
			FullViewEntryButton = React.createElement(FullViewEntryButton, {
				LayoutOrder = 2,
				isUIFullView = t3.isUIFullView,
				isSceneFullView = t3.isSceneFullView,
				changeViewFunction = t3.changeViewFunction
			})
		})
	})
end

return SceneButtons
