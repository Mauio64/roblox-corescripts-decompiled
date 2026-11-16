local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local SharedFlags = require(parent.SharedFlags)
local v = SharedFlags.FFlagBuildExperienceModelPickerData
	and require(BuildExperience.Flags.FFlagBuildExperienceUseCommonTextArea)

if v then
	local SharedFlags2 = require(parent.SharedFlags)
	return SharedFlags2.FFlagComposerFooter
end

return v
