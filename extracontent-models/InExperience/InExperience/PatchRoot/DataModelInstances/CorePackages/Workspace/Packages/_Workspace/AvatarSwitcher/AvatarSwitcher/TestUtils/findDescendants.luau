return {
	findFirstDescendant = function(p1, s1: string, p2: ((...any) -> ...any)?) -- line: 1
		for _, descendant in p1:GetDescendants() do
			if descendant:IsA(s1) and (p2 == nil or p2(descendant)) then
				return descendant
			end
		end

		return nil
	end,
	findAllDescendants = function(p3, s2: string) -- line: 14
		local t1 = {}

		for _, descendant in p3:GetDescendants() do
			if descendant:IsA(s2) then
				table.insert(t1, descendant)
			end
		end

		return t1
	end
}
