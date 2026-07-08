local ParentParent = script.Parent.Parent

require(ParentParent.Signals)

local function onDisposed(p1, p2) -- line: 7
	local function source(_, b1: boolean?) -- line: 8
		-- upvalues: p2 (copy)
		if b1 then
			p2()
		end

		return 0
	end

	p1(source)
end

return onDisposed
