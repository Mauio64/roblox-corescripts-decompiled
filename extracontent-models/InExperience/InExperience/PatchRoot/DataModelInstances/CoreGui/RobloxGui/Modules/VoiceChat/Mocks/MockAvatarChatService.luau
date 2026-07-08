local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3, p4) -- line: 4
	-- upvalues: t1 (copy)
	return (setmetatable({
		IsEnabled = p1,
		EnableVoice = p2,
		GetPropertyChangedSignal = p3,
		GetClientFeaturesAsync = p4
	}, t1))
end

return t1
