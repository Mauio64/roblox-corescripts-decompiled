local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/gsg")
local colors = require("@game/CorePackages/Workspace/Packages/Style").Colors

local udim = UDim2.new(0, 37, 0, 37)

local extended = Roact.PureComponent:extend("QQButton")

function extended.render(p2)
	local props = p2.props
	local v5 = {
		Color = props.Color or colors.Blue,
		Transparency = props.Transparency or 0,
		OnPressTransparency = 0.5,
		DisabledTransparency = 0.5,
		DisabledColor = colors.White,
		Text = { Color = colors.White, Transparency = 0 },
		Border = { Hidden = true, Transparency = 1 }
	}

	return Roact.createElement(module, Cryo.Dictionary.join(props, {
		iconImage = "rbxasset://textures/ui/LuaApp/graphic/Auth/qqlogo.png",
		iconSize = udim,
		leftIconEnabled = true,
		themeSettings = v5,
		iconRightPadding = 10
	}))
end

return extended
