local function assetIdAsContent(value)
	if typeof(value) == "string" and value:find("^.+://") then
		return value
	end

	return `rbxassetid://{value}`
end

return assetIdAsContent
