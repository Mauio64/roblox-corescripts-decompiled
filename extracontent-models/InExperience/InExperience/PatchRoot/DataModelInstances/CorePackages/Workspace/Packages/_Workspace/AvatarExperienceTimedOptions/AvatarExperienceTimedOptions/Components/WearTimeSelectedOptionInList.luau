local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local useWearTimeSelectedOptionViewModel = require(script.Parent.useWearTimeSelectedOptionViewModel)
local WearTimeSelectedOptionInListView = require(script.Parent.WearTimeSelectedOptionInListView)

require(Parent.AvatarExperienceCommon)

local function WearTimeSelectedOptionContainer(t1: {[any]: any}) -- line: 18
	-- upvalues: useWearTimeSelectedOptionViewModel (copy), WearTimeSelectedOptionInListView (copy)
	local v6 = useWearTimeSelectedOptionViewModel(t1)

	return WearTimeSelectedOptionInListView(v6)
end

return WearTimeSelectedOptionContainer
