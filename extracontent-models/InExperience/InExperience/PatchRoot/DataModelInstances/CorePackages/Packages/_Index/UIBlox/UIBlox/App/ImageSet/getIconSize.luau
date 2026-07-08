local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent

require(ParentParent.App.Style.StyleTypes)

local IconSize = require(scriptParent.Enum.IconSize)
local t1 = {
	[IconSize.Small] = 16,
	[IconSize.Medium] = 36,
	[IconSize.Large] = 48,
	[IconSize.XLarge] = 96,
	[IconSize.XXLarge] = 192
}

return function(n1: number, p1) -- line: 17
	-- upvalues: IconSize (copy), t1 (copy)
	assert(IconSize.isEnumValue(n1))

	if p1 ~= nil and p1.Tokens ~= nil then
		if n1 == IconSize.Small then
			return p1.Tokens.Semantic.Icon.Size.Small
		end

		if n1 == IconSize.Medium then
			return p1.Tokens.Semantic.Icon.Size.Medium
		end

		if n1 == IconSize.Large then
			return p1.Tokens.Semantic.Icon.Size.Large
		end

		if n1 == IconSize.XLarge then
			return p1.Tokens.Semantic.Icon.Size.XLarge
		end

		if n1 == IconSize.XXLarge then
			return p1.Tokens.Semantic.Icon.Size.XxLarge
		end

		return nil
	end

	return t1[n1]
end
