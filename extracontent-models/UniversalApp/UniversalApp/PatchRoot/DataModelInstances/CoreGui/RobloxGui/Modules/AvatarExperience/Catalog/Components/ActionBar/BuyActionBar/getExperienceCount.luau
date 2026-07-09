local function getExperienceCount(t1: {[any]: any}?) -- line: 1
	return #if not t1 then {} else t1.experiences or {}
end

return getExperienceCount
