local parent = script:FindFirstAncestor("Foundation").Parent

local BuilderIcons = require(parent.BuilderIcons)

return BuilderIcons.getBuilderIconForCurrentPlatform
