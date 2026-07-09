local t1 = {
	SchoolStatus = {
		Live = "Live",
		Waitlist = "Waitlist",
		Pending = "Pending"
	}
}
local t2 = {
	groupId = 1234567,
	name = "UCLA",
	location = "Los Angeles, CA",
	memberCount = 119,
	status = t1.SchoolStatus.Live
}

function t1.getSchool() -- line: 35
	-- upvalues: t2 (copy)
	return t2
end

return t1
