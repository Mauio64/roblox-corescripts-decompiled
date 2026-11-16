local parent = script:FindFirstAncestor("BuildExperience").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceChatResourceAttachments

return game:DefineFastFlag("BuildExperienceDeveloperProductContext", false)
	and FFlagBuildExperienceChatResourceAttachments
