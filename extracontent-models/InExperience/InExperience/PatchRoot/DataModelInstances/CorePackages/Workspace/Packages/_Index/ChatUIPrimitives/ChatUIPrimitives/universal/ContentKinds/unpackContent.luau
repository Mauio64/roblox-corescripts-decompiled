require(script.Parent.Parent.Types)

local function unpackContent(items)
	if type(items) ~= "table" then
		return nil, nil
	end

	local v, v2 = next(items)

	if type(v) == "string" and v2 ~= nil and next(items, v) == nil then
		return v, v2
	end

	return nil, nil
end

return unpackContent
