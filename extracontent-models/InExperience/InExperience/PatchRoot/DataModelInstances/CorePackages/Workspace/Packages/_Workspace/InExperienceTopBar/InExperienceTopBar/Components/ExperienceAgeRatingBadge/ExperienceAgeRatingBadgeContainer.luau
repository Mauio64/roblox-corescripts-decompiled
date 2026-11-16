local parent = script:FindFirstAncestor("InExperienceTopBar").Parent

local React = require(parent.React)
local ExperienceAgeRatingBadgeView = require(script.Parent.ExperienceAgeRatingBadgeView)
local useExperienceAgeRatingBadgeViewModel = require(script.Parent.useExperienceAgeRatingBadgeViewModel)

local function ExperienceAgeRatingBadgeContainer(p)
	local v = useExperienceAgeRatingBadgeViewModel(p)

	if v then
		return (React.createElement(ExperienceAgeRatingBadgeView, v))
	end

	return nil
end

return ExperienceAgeRatingBadgeContainer
