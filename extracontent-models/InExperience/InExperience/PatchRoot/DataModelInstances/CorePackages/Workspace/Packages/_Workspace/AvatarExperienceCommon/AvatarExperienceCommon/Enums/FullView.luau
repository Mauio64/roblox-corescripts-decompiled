local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local enumerate = require(parent.enumerate)

return (enumerate(script.Name, { "None", "SceneFullView", "UIFullView" }))
