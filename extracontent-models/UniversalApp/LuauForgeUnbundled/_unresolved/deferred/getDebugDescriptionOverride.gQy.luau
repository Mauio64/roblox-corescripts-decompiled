game:DefineFastString("DebugAXItemDetailsDescriptionOverride", "")

local function getDebugDescriptionOverride(p2)
	if p2 == nil then
		return nil
	end

	local fastString = game:GetFastString("DebugAXItemDetailsDescriptionOverride")

	if fastString == "" then
		return nil
	end

	local v5 = string.find(fastString, "!", 1, true)

	if v5 == nil then
		return fastString
	end

	local v6 = string.sub(fastString, 1, v5 - 1)
	local v7 = string.sub(fastString, v5 + 1)

	if v6 == "" then
		return v7
	end

	local v8 = if p2.creator then p2.creator.name else nil

	if v6 == v8 then
		return v7
	end

	return nil
end

return getDebugDescriptionOverride
