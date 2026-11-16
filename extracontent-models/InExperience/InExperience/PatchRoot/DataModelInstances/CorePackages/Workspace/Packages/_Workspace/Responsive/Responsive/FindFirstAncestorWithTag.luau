function FindFirstAncestorWithTag(instance, tag: string)
	if instance == nil then
		return nil
	end

	if instance:HasTag(tag) then
		return instance
	end

	return FindFirstAncestorWithTag(instance.Parent, tag)
end

return FindFirstAncestorWithTag
