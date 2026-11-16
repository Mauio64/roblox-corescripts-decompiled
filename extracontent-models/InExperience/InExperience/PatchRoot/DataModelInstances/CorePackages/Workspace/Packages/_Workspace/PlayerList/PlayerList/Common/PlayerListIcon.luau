local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Image = Foundation.Image
local Icon = Foundation.Icon

local function PlayerListIcon(props)
	local icon = props.icon

	if icon == nil or icon == "" then
		return nil
	end

	local size = props.size

	if typeof(icon) == "table" and icon.isFoundationIcon then
		return React.createElement(Icon, {
			name = icon.name,
			variant = icon.variant,
			size = size,
			LayoutOrder = props.layoutOrder,
			testId = props.testId
		})
	end

	if typeof(icon) == "string" then
		return React.createElement(Image, {
			Image = icon,
			Size = UDim2.fromOffset(size, size),
			LayoutOrder = props.layoutOrder,
			testId = props.testId
		})
	end

	if typeof(icon) == "table" and icon.Image ~= nil then
		return React.createElement(Image, {
			Image = icon.Image,
			imageRect = { offset = icon.ImageRectOffset, size = icon.ImageRectSize },
			Size = UDim2.fromOffset(size, size),
			LayoutOrder = props.layoutOrder,
			testId = props.testId
		})
	end

	return nil
end

return PlayerListIcon
