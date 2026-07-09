local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local ContextualMenu = require(Modules.LuaApp.Components.ContextualMenu)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local GRAY1 = Constants.Color.GRAY1
local SourceSans = Enum.Font.SourceSans
local GRAY1_2 = Constants.Color.GRAY1
local SourceSans2 = Enum.Font.SourceSans
local t1 = {
	Image = "LuaApp/buttons/buttonFill",
	SliceCenter = Rect.new(8, 8, 9, 9)
}
local t2 = {
	Image = "LuaApp/buttons/buttonStroke",
	SliceCenter = Rect.new(8, 8, 9, 9)
}
local v24 = Roact.Component:extend("DropDownList")

v24.defaultProps = {
	height = 38,
	itemHeight = 54,
	itemTextSize = 23,
	textSize = 18,
	itemTextColor = GRAY1_2,
	itemFont = SourceSans2,
	size = UDim2.new(1, 0, 0, 38),
	textColor = GRAY1,
	font = SourceSans
}

function v24.init(p1) -- line: 67
	-- upvalues: IsVRAppBuild (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), VRConstants (copy)
	p1.state = {
		isOpen = false
	}

	function p1.onActivated(p2) -- line: 72
		-- upvalues: p1 (copy), IsVRAppBuild (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), VRConstants (copy)
		local n1 = 0
		local n2 = 0
		local ScreenGui = p2:FindFirstAncestorOfClass("ScreenGui")

		if ScreenGui ~= nil then
			n1 = ScreenGui.AbsoluteSize.x
			n2 = ScreenGui.AbsoluteSize.y
		end

		p1:setState({
			isOpen = true,
			screenShape = {
				x = p2.AbsolutePosition.x,
				y = p2.AbsolutePosition.y,
				width = p2.AbsoluteSize.x,
				height = p2.AbsoluteSize.y,
				parentWidth = if not IsVRAppBuild() then n1 else if FFlagLuaAppForceVrAppPanelWidthRollout or not p1.props.vrPanelWidthMultiplier then VRConstants.MainScreenResolution.x else VRConstants.MainScreenResolution.x * p1.props.vrPanelWidthMultiplier,
				parentHeight = if not IsVRAppBuild() then n2 else VRConstants.MainScreenResolution.y
			}
		})
	end
	function p1.callbackCancel() -- line: 101
		-- upvalues: p1 (copy)
		p1:setState({
			isOpen = false
		})
	end
	function p1.callbackSelect(p3, p4) -- line: 106
		-- upvalues: p1 (copy)
		p1:setState({
			isOpen = false
		})

		if p1.props.onSelected then
			p1.props.onSelected(p3, p4)
		end
	end
end
function v24.render(p5) -- line: 118
	-- upvalues: Roact (copy), ContextualMenu (copy), withStyle (copy), DEPRECATED_ImageSetButton (copy), t1 (copy), DEPRECATED_ImageSetLabel (copy), t2 (copy), Constants (copy)
	local position = p5.props.position
	local anchorPoint = p5.props.anchorPoint
	local height = p5.props.height
	local items = p5.props.items
	local itemSelected = p5.props.itemSelected
	local layoutOrder = p5.props.layoutOrder
	local screenShape = p5.state.screenShape
	local size = p5.props.size
	local u35 = nil

	if p5.state.isOpen then
		u35 = Roact.createElement(ContextualMenu, {
			menuItems = items,
			screenShape = screenShape,
			callbackCancel = p5.callbackCancel,
			callbackSelect = p5.callbackSelect
		})
	end

	return withStyle(function(p6) -- line: 145
		-- upvalues: Roact (copy), DEPRECATED_ImageSetButton (copy), size (copy), position (copy), anchorPoint (copy), layoutOrder (copy), t1 (copy), p5 (copy), DEPRECATED_ImageSetLabel (copy), t2 (copy), Constants (copy), height (copy), itemSelected (copy), u35 (ref)
		return Roact.createElement(DEPRECATED_ImageSetButton, {
			Size = size,
			Position = position,
			AnchorPoint = anchorPoint,
			LayoutOrder = layoutOrder,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Image = t1.Image,
			ImageColor3 = p6.Theme.BackgroundDefault.Color,
			ImageTransparency = p6.Theme.BackgroundDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = t1.SliceCenter,
			[Roact.Event.Activated] = p5.onActivated
		}, {
			Border = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Image = t2.Image,
				ImageColor3 = p6.Theme.SecondaryDefault.Color,
				ImageTransparency = p6.Theme.SecondaryDefault.Transparency,
				LayoutOrder = layoutOrder,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = t2.SliceCenter
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				BackgroundColor3 = Constants.Color.WHITE,
				Size = UDim2.new(1, -47, 0, height),
				Text = itemSelected.displayName,
				Font = p6.Font.Body.Font,
				TextSize = p6.Font.BaseSize * p6.Font.Body.RelativeSize,
				TextColor3 = p6.Theme.TextDefault.Color,
				TextTransparency = p6.Theme.TextDefault.Transparency,
				Position = UDim2.new(0, 10, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			Arrow = Roact.createElement(DEPRECATED_ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = "LuaApp/icons/dropdown_arrowDown",
				AnchorPoint = Vector2.new(1, 0.5),
				ImageColor3 = p6.Theme.IconDefault.Color,
				ImageTransparency = p6.Theme.IconDefault.Transparency,
				Position = UDim2.new(1, -7, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20)
			}),
			Items = u35
		})
	end)
end

if not FFlagLuaAppForceVrAppPanelWidthRollout and GetFFlagVRPanelWidthIXPEnabled() then
	v24 = IxpUtils.connectTestVariables({
		vrPanelWidthMultiplier = VRPanelWidthIXP.VrAppPanelWidthMultiplier
	})(v24)
end

return v24
