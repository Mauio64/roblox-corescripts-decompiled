local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local UIBlox = require(ParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize

local function makeBackButton(p1: ((...any) -> ...any)?) -- line: 10
	-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy)
	return function() -- line: 11
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), p1 (copy)
		return React.createElement(IconButton, {
			size = UDim2.fromOffset(0, 0),
			iconSize = IconSize.Medium,
			icon = Images["icons/navigation/pushBack"],
			onActivated = p1
		})
	end
end

return makeBackButton
