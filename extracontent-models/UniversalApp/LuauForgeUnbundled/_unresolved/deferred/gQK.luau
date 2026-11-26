local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize
require("@luauforge/bundled/dKT")
local overlay = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Overlay

local withStyle = UIBlox.Style.withStyle

require(CorePackages.Packages.React)

local function getWindowSize(props)
	if not props.wideMode then
		return UDim2.fromScale(1, 1)
	end

	local v5 = math.min(getSafeAreaSize(props.screenSize, props.globalGuiInset).X.Offset, 640)
	return UDim2.new(0, v5, 1, 0)
end

local function mapStateToProps(data, p2)
	return {
		wideMode = data.FormFactor == formFactor.WIDE,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(function(props)
	local windowSize = getWindowSize(props)
	local v5 = props[Roact.Children]

	if props.wideMode then
		return withStyle(function(p2)
			local createElement = Roact.createElement
			local v7 = {
				ref = props.forwardRef,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = p2.Theme.Overlay.Transparency,
				BackgroundColor3 = p2.Theme.Overlay.Color,
				Active = true,
				AutoButtonColor = false,
				Text = " ",
				Selectable = false
			}

			local createElement2 = Roact.createElement
			local v10 = {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = windowSize,
				BackgroundTransparency = 0,
				BackgroundColor3 = 0,
				BorderSizePixel = 0
			}

			local v11 = if props.backgroundTransparency then props.backgroundTransparency else p2.Theme.BackgroundDefault.Transparency
			v10.BackgroundTransparency = v11

			v10.BackgroundColor3 = p2.Theme.BackgroundDefault.Color
			return createElement("TextButton", v7, {
				Window = createElement2(overlay, v10, v5)
			})
		end)
	end

	return Roact.createFragment(v5)
end))
