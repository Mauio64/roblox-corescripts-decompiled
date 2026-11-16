local CorePackages = game:GetService("CorePackages")
local v = game:GetService("CoreGui")
v = v.RobloxGui
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)

local extended = Roact.Component:extend("CheckboxDropdown")

function extended.render(p)
	local v2 = p.props[Roact.Children] or {}
	local absolutePosition = p.props.absolutePosition
	local frameWidth = p.props.frameWidth
	local elementHeight = p.props.elementHeight
	local numElements = p.props.numElements
	local target = p.props.dropdownTargetGui

	local onCloseCheckbox = p.props.onCloseCheckbox

	local v3 = elementHeight * numElements
	local udim = UDim2.new(0, frameWidth, 0, 24 + v3)

	local createElement = Roact.createElement
	local portal = Roact.Portal

	if target == nil or not target then
		local CoreGui = game:GetService("CoreGui")
		target = CoreGui.DevConsoleMaster
	end

	return createElement(portal, { target = target }, {
		InputCatcher = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				[Roact.Event.InputEnded] = onCloseCheckbox
			},
			{
				OuterFrame = Roact.createElement("ImageButton", {
					Size = udim,
					AutoButtonColor = false,
					Position = absolutePosition,
					BackgroundColor3 = Constants.Color.TextBoxGray,
					BackgroundTransparency = 0
				}, {
					innerFrame = Roact.createElement(
						"Frame",
						{
							Position = UDim2.new(0, 12, 0, 12),
							Size = UDim2.new(0, frameWidth, 0, v3),
							BackgroundTransparency = 1
						},
						v2
					)
				})
			}
		)
	})
end

return extended
