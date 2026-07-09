local function assetIdAsContent(p1) -- line: 1
	if typeof(p1) == "string" and p1:find("^.+://") then
		return p1
	end

	return `rbxassetid://{ p1 }`
end

return assetIdAsContent
