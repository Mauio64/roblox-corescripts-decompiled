local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/UIBlox")

local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local function makeBackButton(onActivated)
	return function()
		return React.createElement(iconButton, {
			size = UDim2.fromOffset(0, 0),
			iconSize = iconSize.Medium,
			icon = images["icons/navigation/pushBack"],
			onActivated = onActivated
		})
	end
end

return makeBackButton
