local function getImageUri(value: string?)
	if value == nil or value == "" then
		return ""
	end

	local v = string.find(value, "http://www.roblox.com/asset/?id=", 1, true)

	if v and v == 1 then
		return `rbxthumb://type=Asset&id={string.sub(value, 33)}&w=768&h=432`
	end

	if tonumber(value) then
		return `rbxthumb://type=Asset&id={value}&w=768&h=432`
	end

	return value
end

return getImageUri
