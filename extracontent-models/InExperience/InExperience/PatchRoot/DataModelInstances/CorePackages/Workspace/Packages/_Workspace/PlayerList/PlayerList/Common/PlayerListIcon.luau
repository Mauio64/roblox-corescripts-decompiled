local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local FoundationImage = Foundation.Image
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize

local function PlayerListIcon(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), Icon (copy), IconSize (copy), FoundationImage (copy)
	local icon = t1.icon

	if icon == nil or icon == "" then
		return nil
	end

	local size = t1.size

	if typeof(icon) == "table" and icon.isFoundationIcon then
		return React.createElement(Icon, {
			name = icon.name,
			variant = icon.variant,
			size = IconSize.Small,
			LayoutOrder = t1.layoutOrder
		})
	end

	if typeof(icon) == "string" then
		return React.createElement(FoundationImage, {
			Image = icon,
			Size = UDim2.fromOffset(size, size),
			LayoutOrder = t1.layoutOrder
		})
	end

	if typeof(icon) == "table" and icon.Image ~= nil then
		return React.createElement(FoundationImage, {
			Image = icon.Image,
			imageRect = {
				offset = icon.ImageRectOffset,
				size = icon.ImageRectSize
			},
			Size = UDim2.fromOffset(size, size),
			LayoutOrder = t1.layoutOrder
		})
	end

	return nil
end

return PlayerListIcon
