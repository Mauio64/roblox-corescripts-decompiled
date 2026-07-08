local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Logger = require(Foundation.Utility.Logger)

return (require(FoundationParent.React).createContext(function() -- line: 10
	-- upvalues: Logger (copy)
	Logger:warning("No Style Provider found")

	return ""
end))
