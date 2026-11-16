local defineFastInt = game:DefineFastInt("WidgetPaddingSizing", 32)

local function resolveWidgetListItemBottomPaddingPx(p)
	local xxLarge = p.Padding.XXLarge
	return ({
			[32] = xxLarge,
			[24] = p.Padding.XXLarge,
			[20] = p.Padding.XLarge,
			[16] = p.Padding.Large
		})[defineFastInt]
		or xxLarge
end

return resolveWidgetListItemBottomPaddingPx
