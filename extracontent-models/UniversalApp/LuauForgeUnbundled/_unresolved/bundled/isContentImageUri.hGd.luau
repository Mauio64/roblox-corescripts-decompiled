local v5 = {
	"rbxassetid://",
	"rbxthumb://",
	"rbxgameasset://",
	"rbxhttp://",
	"http://",
	"https://"
}

local function startsWith(value, list): boolean
	return string.sub(value, 1, #list) == list
end

local function isContentImageUri(value): boolean
	if value == nil or value == "" then
		return false
	end

	for k, v6 in v5 do
		if string.sub(value, 1, #v6) == v6 then
			return true
		end
	end

	return false
end

return isContentImageUri
