local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local InputSize = require(Foundation.Enums.InputSize)

return require(FoundationParent.React).createContext({
	onAccordionItemActivated = nil,
	testId = "",
	itemSize = InputSize.Medium
})
