local v1 = game:DefineFastInt("AXCategoryPillPositionAnimationFrequency", 300) / 100
local v2 = game:DefineFastInt("AXCategoryPillPositionAnimationDampingRatio", 100) / 100
local v3 = game:DefineFastInt("AXCategoryPillTransparencyAnimationFrequency", 150) / 100
local v4 = game:DefineFastInt("AXCategoryPillTransparencyAnimationDampingRatio", 100) / 100
local v5 = game:DefineFastInt("AXSubcategoryPillFadeAnimationFrequency", 300) / 100
local v6 = game:DefineFastInt("AXSubcategoryPillFadeAnimationDampingRatio", 100) / 100
local v7 = game:DefineFastInt("AXSubcategoryPillFadeAnimationDurationMs", 500)

return {
	FIntAXCategoryPillPositionAnimationFrequency = v1,
	FIntAXCategoryPillPositionAnimationDampingRatio = v2,
	FIntAXCategoryPillTransparencyAnimationFrequency = v3,
	FIntAXCategoryPillTransparencyAnimationDampingRatio = v4,
	FIntAXSubcategoryPillFadeAnimationFrequency = v5,
	FIntAXSubcategoryPillFadeAnimationDampingRatio = v6,
	FIntAXSubcategoryPillFadeAnimationDurationMs = v7
}
