local function getTestIdTag(p: string?, p2: string?)
	if p == nil then
		return nil
	end

	if p2 then
		return `data-testid={p}--{p2}`
	end

	return `data-testid={p}`
end

return getTestIdTag
