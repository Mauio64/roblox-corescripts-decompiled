function FindFirstAncestorWithTag(p1, s1: string) -- line: 1
	if p1 == nil then
		return nil
	end

	if p1:HasTag(s1) then
		return p1
	end

	return FindFirstAncestorWithTag(p1.Parent, s1)
end

return FindFirstAncestorWithTag
