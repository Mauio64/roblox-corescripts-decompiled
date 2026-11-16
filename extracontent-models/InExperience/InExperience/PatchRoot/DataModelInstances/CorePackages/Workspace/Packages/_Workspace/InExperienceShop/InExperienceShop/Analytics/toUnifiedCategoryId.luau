local function toUnifiedCategoryId(p: string?)
	if p == nil then
		return nil
	end

	return (tonumber(p))
end

return toUnifiedCategoryId
