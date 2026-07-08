local CorePackages = game:GetService("CorePackages")
local _ = game:GetService("CoreGui").RobloxGui
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local v5 = Roact.Component:extend("CheckboxDropdown")

function v5.render(p1) -- line: 10
	-- upvalues: Roact (copy), Constants (copy)
	local v7 = p1.props[Roact.Children] or {}
	local absolutePosition = p1.props.absolutePosition
	local frameWidth = p1.props.frameWidth
	local elementHeight = p1.props.elementHeight
	local numElements = p1.props.numElements
	local dropdownTargetGui = p1.props.dropdownTargetGui
	local onCloseCheckbox = p1.props.onCloseCheckbox
	local v14 = elementHeight * numElements
	local uDim2 = UDim2.new(0, frameWidth, 0, 24 + v14)

	return Roact.createElement(Roact.Portal, {
		target = dropdownTargetGui ~= nil and dropdownTargetGui or game:GetService("CoreGui").DevConsoleMaster
	}, {
		InputCatcher = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			[Roact.Event.InputEnded] = onCloseCheckbox
		}, {
			OuterFrame = Roact.createElement("ImageButton", {
				AutoButtonColor = false,
				BackgroundTransparency = 0,
				Size = uDim2,
				Position = absolutePosition,
				BackgroundColor3 = Constants.Color.TextBoxGray
			}, {
				innerFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 12),
					Size = UDim2.new(0, frameWidth, 0, v14)
				}, v7)
			})
		})
	})
end

return v5
