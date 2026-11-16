local defineFastFlag = game:DefineFastFlag("UseLocalTraversalHistory699v1", false)
local defineFastFlag2 = game:DefineFastFlag("UseTeleportTraversalHistory699v1", false)

local v5 = defineFastFlag or defineFastFlag2

return {
	FFlagAddTraversalBackButton = game:DefineFastFlag("AddTraversalBackButton699v1", false) and v5,
	FFlagAddTraversalBackButtonAnimation = game:DefineFastFlag(
		"AddTraversalBackButtonAnimation699v1",
		false
	) and v5,
	FFlagAddTraversalHistory = game:DefineFastFlag("AddTraversalHistory699v1", false) and v5,
	FFlagUseLocalTraversalHistory = defineFastFlag,
	FFlagUseTeleportTraversalHistory = defineFastFlag2,
	FIntMaximumTraversalHistoryItemsFetch = game:DefineFastInt("MaximumTraversalHistoryItemsFetch", 20),
	FFlagTraversalExpPagePaddingFixes = game:DefineFastFlag("TraversalExpPagePaddingFixes709", false)
}
