local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local useWearTimeSelectedOptionViewModel = require(script.Parent.useWearTimeSelectedOptionViewModel)
local WearTimeSelectedOptionView = require(script.Parent.WearTimeSelectedOptionView)

require(Parent.AvatarExperienceCommon)

local function WearTimeSelectedOptionContainer(t1: {[any]: any}) -- line: 18
	-- upvalues: useWearTimeSelectedOptionViewModel (copy), WearTimeSelectedOptionView (copy)
	local v6 = useWearTimeSelectedOptionViewModel(t1)

	return WearTimeSelectedOptionView(v6)
end

return WearTimeSelectedOptionContainer
