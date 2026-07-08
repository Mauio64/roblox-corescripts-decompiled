local scriptParent = script.Parent
local Parent = script:FindFirstAncestor("Foundation").Parent

require(scriptParent.Tokens)

return (require(Parent.React).createContext({}))
