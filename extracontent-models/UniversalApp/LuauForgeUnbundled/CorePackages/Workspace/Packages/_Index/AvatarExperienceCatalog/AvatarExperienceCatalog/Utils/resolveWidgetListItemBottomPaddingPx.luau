local defineFastInt = game:DefineFastInt("WidgetPaddingSizing", 32)

local function resolveWidgetListItemBottomPaddingPx(p2)
	local xxLarge = p2.Padding.XXLarge
	return ({
			[32] = xxLarge,
			[24] = p2.Padding.XXLarge,
			[20] = p2.Padding.XLarge,
			[16] = p2.Padding.Large
		})[defineFastInt]
		or xxLarge
end

return resolveWidgetListItemBottomPaddingPx
