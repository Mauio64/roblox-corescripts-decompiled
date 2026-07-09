local t1 = {
	"rbxassetid://",
	"rbxthumb://",
	"rbxgameasset://",
	"rbxhttp://",
	"http://",
	"https://"
}

local function startsWith(s1: string, s2: string) -- line: 22
	return s2 == string.sub(s1, 1, #s2)
end
local function isContentImageUri(s3: string?) -- line: 26
	-- upvalues: t1 (copy)
	if s3 == nil or s3 == "" then
		return false
	end

	for _, v8 in t1 do
		if v8 == string.sub(s3, 1, #v8) then
			return true
		end
	end

	return false
end

return isContentImageUri
