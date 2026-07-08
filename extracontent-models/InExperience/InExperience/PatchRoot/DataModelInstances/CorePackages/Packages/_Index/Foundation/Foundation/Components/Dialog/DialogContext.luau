local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local DialogSize = require(Foundation.Enums.DialogSize)

return require(FoundationParent.React).createContext({
	hasHeroMedia = false,
	testId = "",
	closeAffordanceRef = nil,
	contentStartRef = nil,
	size = DialogSize.Small,
	responsiveSize = DialogSize.Small,
	setResponsiveSize = function(_) -- line: 11
	end,
	setHasHeroMedia = function(_: boolean) -- line: 13
	end,
	setContentStartRef = function(_) -- line: 17
	end
})
