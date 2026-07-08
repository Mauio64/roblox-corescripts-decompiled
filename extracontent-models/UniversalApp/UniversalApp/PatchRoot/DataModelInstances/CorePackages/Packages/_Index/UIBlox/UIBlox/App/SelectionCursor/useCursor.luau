local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.React)

local useCursor = require(ParentParent.Foundation).Hooks.useCursor

local function useCursor2(uDim: UDim?, n1: number?, n2: number?) -- line: 7
	-- upvalues: useCursor (copy)
	return useCursor({
		radius = uDim,
		offset = n1,
		borderWidth = n2
	})
end

return useCursor2
