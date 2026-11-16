require(script.Parent.Parent.Types)

local function isObservingAuthor(p, p2: string?): boolean
	return p ~= nil and p2 ~= nil and p.userId == p2
end

return isObservingAuthor
