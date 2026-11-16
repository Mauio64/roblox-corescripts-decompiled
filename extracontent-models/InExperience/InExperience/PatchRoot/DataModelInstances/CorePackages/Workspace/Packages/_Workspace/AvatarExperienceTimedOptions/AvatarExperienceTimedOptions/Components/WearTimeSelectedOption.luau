local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local useWearTimeSelectedOptionViewModel = require(script.Parent.useWearTimeSelectedOptionViewModel)
local WearTimeSelectedOptionView = require(script.Parent.WearTimeSelectedOptionView)

require(parent.AvatarExperienceCommon)

local function WearTimeSelectedOptionContainer(p)
	return WearTimeSelectedOptionView((useWearTimeSelectedOptionViewModel(p)))
end

return WearTimeSelectedOptionContainer
