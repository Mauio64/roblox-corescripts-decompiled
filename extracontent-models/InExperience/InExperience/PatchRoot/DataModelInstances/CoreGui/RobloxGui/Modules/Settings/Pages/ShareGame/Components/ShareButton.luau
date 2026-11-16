local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Theme = require(RobloxGui.Modules.Settings.Theme)

local font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
local textSize = Theme.textSize(19)
local color = Color3.fromRGB(222, 225, 227)
local color2 = Color3.fromRGB(255, 255, 255)

local extended = Roact.PureComponent:extend("ShareButton")

function extended:init()
	self.state = { isHovering = false }
end

function extended.render(object)
	local size = object.props.size
	local layoutOrder = object.props.layoutOrder
	local onShare = object.props.onShare
	local isEnabled = object.props.isEnabled
	local text = object.props.text

	local children = {}
	local createElement = Roact.createElement
	local v = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = 0,
		Thickness = 0,
		Transparency = 0
	}
	local color3

	if object.state.isHovering and isEnabled then
		color3 = color
	else
		color3 = color2
	end

	v.Color = color3
	v.Thickness = Theme.DefaultStokeThickness
	v.Transparency = isEnabled and 0 or 0.5
	children.Border = createElement("UIStroke", v)

	children.UICorner = Roact.createElement("UICorner", { CornerRadius = Theme.DefaultCornerRadius })

	local createElement2 = Roact.createElement
	local v2 = {
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		["LayoutOrder"] = nil,
		LayoutOrder = layoutOrder,
		Size = size,
		Text = text,
		TextSize = textSize,
		Font = font,
		AutoButtonColor = false
	}
	local backgroundColor

	if object.state.isHovering and isEnabled then
		backgroundColor = color
	else
		backgroundColor = color2
	end

	v2.BackgroundColor3 = backgroundColor
	v2.Transparency = isEnabled and 0 or 0.5

	v2[Roact.Event.Activated] = function()
		if isEnabled then
			onShare()
		end
	end
	v2[Roact.Event.InputBegan] = function()
		object:setState({ isHovering = true })
	end
	v2[Roact.Event.InputEnded] = function()
		object:setState({ isHovering = false })
	end

	return createElement2("TextButton", v2, children)
end

return extended
