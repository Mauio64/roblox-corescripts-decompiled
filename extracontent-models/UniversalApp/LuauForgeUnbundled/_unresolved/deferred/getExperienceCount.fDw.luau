local function getExperienceCount(p2)
	return #(p2 and p2.experiences or {})
end

return getExperienceCount
