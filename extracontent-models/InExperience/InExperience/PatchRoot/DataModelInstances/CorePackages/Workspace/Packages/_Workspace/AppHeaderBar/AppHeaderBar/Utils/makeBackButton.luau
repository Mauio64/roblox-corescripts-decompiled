local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize

local function makeBackButton(onActivated)
	return function()
		return React.createElement(IconButton, {
			size = UDim2.fromOffset(0, 0),
			iconSize = IconSize.Medium,
			icon = Images["icons/navigation/pushBack"],
			onActivated = onActivated
		})
	end
end

return makeBackButton
