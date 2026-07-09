local v1 = game:DefineFastFlag("UseLocalTraversalHistory699v1", false)
local v2 = game:DefineFastFlag("UseTeleportTraversalHistory699v1", false)
local v3 = v1 or v2

return {
	FFlagAddTraversalBackButton = game:DefineFastFlag("AddTraversalBackButton699v1", false) and v3,
	FFlagAddTraversalBackButtonAnimation = game:DefineFastFlag("AddTraversalBackButtonAnimation699v1", false) and v3,
	FFlagAddTraversalHistory = game:DefineFastFlag("AddTraversalHistory699v1", false) and v3,
	FFlagUseLocalTraversalHistory = v1,
	FFlagUseTeleportTraversalHistory = v2,
	FIntMaximumTraversalHistoryItemsFetch = game:DefineFastInt("MaximumTraversalHistoryItemsFetch", 20),
	FFlagTraversalExpCardFontSizeFix = game:DefineFastFlag("TraversalExpCardFontSizeFix", false),
	FFlagTraversalExpPagePaddingFixes = game:DefineFastFlag("TraversalExpPagePaddingFixes709", false),
	FFlagTraversalHistoryMenuFocusNavFix = game:DefineFastFlag("TraversalHistoryMenuFocusNavFix709", false),
	FFlagFixTraversalHistoryMenuFixesV3 = game:DefineFastFlag("FixTraversalHistoryMenuFixesV3v1", false)
}
