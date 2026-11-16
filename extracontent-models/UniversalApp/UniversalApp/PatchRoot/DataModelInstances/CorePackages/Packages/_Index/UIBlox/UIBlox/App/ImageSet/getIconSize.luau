local parent = script.Parent

local parent2 = parent.Parent.Parent
require(parent2.App.Style.StyleTypes)

local IconSize = require(parent.Enum.IconSize)

local v = {
	[IconSize.Small] = 16,
	[IconSize.Medium] = 36,
	[IconSize.Large] = 48,
	[IconSize.XLarge] = 96,
	[IconSize.XXLarge] = 192
}

return function(p: number, p2)
	assert(IconSize.isEnumValue(p))

	if p2 == nil or p2.Tokens == nil then
		return v[p]
	end

	if p == IconSize.Small then
		return p2.Tokens.Size.Size_400
	end

	if p == IconSize.Medium then
		return p2.Tokens.Size.Size_900
	end

	if p == IconSize.Large then
		return p2.Tokens.Size.Size_1200
	end

	if p == IconSize.XLarge then
		return p2.Tokens.Size.Size_2400
	end

	return if p == IconSize.XXLarge then 192 else nil
end
