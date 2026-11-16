local AppFonts = {}
AppFonts.__index = AppFonts

function AppFonts.new(enableNewFont: boolean)
	local v = { _enableNewFont = enableNewFont }

	setmetatable(v, AppFonts)
	return v
end

function AppFonts:getDefault()
	if self._enableNewFont then
		return Enum.Font.BuilderSans
	end

	return Enum.Font.Gotham
end

function AppFonts:getMedium()
	if self._enableNewFont then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.GothamMedium
end

function AppFonts:getBlack()
	if self._enableNewFont then
		return Enum.Font.BuilderSansExtraBold
	end

	return Enum.Font.GothamBlack
end

function AppFonts:getBold()
	if self._enableNewFont then
		return Enum.Font.BuilderSansBold
	end

	return Enum.Font.GothamBold
end

function AppFonts:getSemibold()
	if self._enableNewFont then
		return Enum.Font.BuilderSansMedium
	end

	return Enum.Font.GothamMedium
end

AppFonts.default = AppFonts.new(true)
return AppFonts
