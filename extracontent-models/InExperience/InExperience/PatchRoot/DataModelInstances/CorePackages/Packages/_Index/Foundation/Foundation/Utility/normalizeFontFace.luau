local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function normalizeFontFace(value)
	if typeof(value) == "table" then
		if ReactIs.isBinding(value) then
			return value
		end

		return Font.new(value.Family, value.Weight, value.Style)
	end

	if typeof(value) ~= "EnumItem" then
		return value
	end

	if value == Enum.Font.Unknown then
		return nil
	end

	return Font.fromEnum(value)
end

return normalizeFontFace
