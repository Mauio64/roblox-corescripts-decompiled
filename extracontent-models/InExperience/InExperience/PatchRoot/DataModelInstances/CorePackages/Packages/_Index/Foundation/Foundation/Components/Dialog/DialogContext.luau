local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local DialogSize = require(Foundation.Enums.DialogSize)
local React = require(parent.React)

return React.createContext({
	size = DialogSize.Small,
	responsiveSize = DialogSize.Small,
	setResponsiveSize = function(_) end,
	hasHeroMedia = false,
	setHasHeroMedia = function(_: boolean) end,
	testId = "",
	closeAffordanceRef = nil,
	contentStartRef = nil,
	setContentStartRef = function(_) end
})
