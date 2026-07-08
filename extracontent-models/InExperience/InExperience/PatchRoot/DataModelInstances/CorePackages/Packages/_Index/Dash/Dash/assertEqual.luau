local scriptParent = script.Parent

local function assertEqual(p1, p2, s1: string?) -- line: 12
	-- upvalues: scriptParent (copy)
	if p1 ~= p2 then
		require(scriptParent.Error).new("AssertError", s1 or `Left "{ p1 }" does not equal right "{ p2 }"`):throw({
			left = p1,
			right = p2
		})
	end
end

return assertEqual
