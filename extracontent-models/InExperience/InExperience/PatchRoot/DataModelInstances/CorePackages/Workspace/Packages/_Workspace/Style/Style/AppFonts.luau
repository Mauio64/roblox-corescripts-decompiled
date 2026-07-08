local t1 = {}

t1.__index = t1

function t1.new(b1: boolean) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		_enableNewFont = b1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.getDefault(p1) -- line: 12
	if p1._enableNewFont then
		return Enum.Font.BuilderSans
	end

	return Enum.Font.Gotham
end
function t1.getMedium(p2) -- line: 21
	if p2._enableNewFont then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.GothamMedium
end
function t1.getBlack(p3) -- line: 30
	if p3._enableNewFont then
		return Enum.Font.BuilderSansExtraBold
	end

	return Enum.Font.GothamBlack
end
function t1.getBold(p4) -- line: 39
	if p4._enableNewFont then
		return Enum.Font.BuilderSansBold
	end

	return Enum.Font.GothamBold
end
function t1.getSemibold(p5) -- line: 48
	if p5._enableNewFont then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.GothamMedium
end

t1.default = t1.new(true)

return t1
