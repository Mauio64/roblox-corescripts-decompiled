local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Logger = require(Foundation.Utility.Logger)
local React = require(parent.React)

return (React.createContext(function(): string
	Logger:warning("No Style Provider found")
	return ""
end))
