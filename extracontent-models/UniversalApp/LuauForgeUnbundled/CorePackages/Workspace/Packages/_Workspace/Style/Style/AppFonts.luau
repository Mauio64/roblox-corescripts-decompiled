local class = {}
class.__index = class

function class.new(p2)
	local v5 = { _enableNewFont = p2 }

	setmetatable(v5, class)
	return v5
end

function class:getDefault()
	if self._enableNewFont then
		return Enum.Font.BuilderSans
	end

	return Enum.Font.Gotham
end

function class:getMedium()
	if self._enableNewFont then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.GothamMedium
end

function class:getBlack()
	if self._enableNewFont then
		return Enum.Font.BuilderSansExtraBold
	end

	return Enum.Font.GothamBlack
end

function class:getBold()
	if self._enableNewFont then
		return Enum.Font.BuilderSansBold
	end

	return Enum.Font.GothamBold
end

function class:getSemibold()
	if self._enableNewFont then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.GothamMedium
end

class.default = class.new(true)
return class
