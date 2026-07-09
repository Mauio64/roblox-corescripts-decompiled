local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local GenericIconTextButton = require(Modules.LuaApp.Components.GenericIconTextButton)
local Colors = require(CorePackages.Workspace.Packages.Style).Colors
local uDim2 = UDim2.new(0, 37, 0, 37)
local v8 = Roact.PureComponent:extend("QQButton")

function v8.render(p1) -- line: 14
	-- upvalues: Colors (copy), Roact (copy), GenericIconTextButton (copy), Cryo (copy), uDim2 (copy)
	local props = p1.props
	local t1 = {
		OnPressTransparency = 0.5,
		DisabledTransparency = 0.5,
		Color = props.Color or Colors.Blue,
		Transparency = props.Transparency or 0,
		DisabledColor = Colors.White,
		Text = {
			Transparency = 0,
			Color = Colors.White
		},
		Border = {
			Hidden = true,
			Transparency = 1
		}
	}

	return Roact.createElement(GenericIconTextButton, Cryo.Dictionary.join(props, {
		iconImage = "rbxasset://textures/ui/LuaApp/graphic/Auth/qqlogo.png",
		leftIconEnabled = true,
		iconRightPadding = 10,
		iconSize = uDim2,
		themeSettings = t1
	}))
end

return v8
