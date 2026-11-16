local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local useWearTimeSelectedOptionViewModel = require(script.Parent.useWearTimeSelectedOptionViewModel)
local WearTimeSelectedOptionInListView = require(script.Parent.WearTimeSelectedOptionInListView)

require(parent.AvatarExperienceCommon)

local function WearTimeSelectedOptionContainer(p)
	return WearTimeSelectedOptionInListView((useWearTimeSelectedOptionViewModel(p)))
end

return WearTimeSelectedOptionContainer
