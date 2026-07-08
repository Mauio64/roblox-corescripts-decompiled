local t1 = {}

t1.__index = t1

function t1.getSupportedFeatures(_) -- line: 5
	return "zero, ss03"
end
function t1.getPasswordStylisticAlternative(_) -- line: 9
	return "zero, ss03"
end
function t1.getUserNameStylisticAlternative(_) -- line: 13
	return "zero, ss03"
end

return t1
