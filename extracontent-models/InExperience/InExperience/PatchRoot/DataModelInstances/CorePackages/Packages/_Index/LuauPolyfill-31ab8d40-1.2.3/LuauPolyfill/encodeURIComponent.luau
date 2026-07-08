local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local charCodeAt = require(ParentParent.String).charCodeAt
local Error = require(script.Parent.Error)

local function encodeURIComponent(s1: string) -- line: 25
	-- upvalues: charCodeAt (copy), Error (copy), HttpService (copy)
	local v7 = utf8.len(s1)

	if v7 == 0 or v7 == nil then
		return ""
	end

	local v8 = charCodeAt(s1, 1)

	if v7 == 1 then
		if v8 == 55296 then
			error(Error.new("URI malformed"))
		end

		if v8 == 57343 then
			error(Error.new("URI malformed"))
		end
	end

	if v8 >= 56320 and v8 < 57343 then
		error(Error.new("URI malformed"))
	end

	return (HttpService:UrlEncode(s1):gsub("%%2D", "-"):gsub("%%5F", "_"):gsub("%%2E", "."):gsub("%%21", "!"):gsub("%%7E", "~"):gsub("%%2A", "*"):gsub("%%27", "'"):gsub("%%28", "("):gsub("%%29", ")"))
end

return encodeURIComponent
