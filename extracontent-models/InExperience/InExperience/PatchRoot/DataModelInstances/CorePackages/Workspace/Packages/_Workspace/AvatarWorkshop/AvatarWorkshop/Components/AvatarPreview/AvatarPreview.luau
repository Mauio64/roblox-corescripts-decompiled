local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function AvatarPreview()
	return React.createElement(Foundation.View, {
		tag = "size-full-full radius-medium bg-shift-200",
		testId = "avatar-workshop-avatar-preview"
	})
end

return AvatarPreview
