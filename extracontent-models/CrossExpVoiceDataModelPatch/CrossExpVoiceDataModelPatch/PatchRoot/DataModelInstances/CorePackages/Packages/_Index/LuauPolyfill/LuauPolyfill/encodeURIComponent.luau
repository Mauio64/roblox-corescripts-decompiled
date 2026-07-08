local charCodeAt = require(script.Parent.String.charCodeAt)
local Error = require(script.Parent.Error)
local HttpService = game:GetService("HttpService")

local function encodeURIComponent(s1: string) -- line: 6
	-- upvalues: charCodeAt (copy), Error (copy), HttpService (copy)
	local v6 = utf8.len(s1)

	if v6 == 0 or v6 == nil then
		return ""
	end

	local v7 = charCodeAt(s1, 1)

	if v6 == 1 then
		if v7 == 55296 then
			error(Error.new("URI malformed"))
		end

		if v7 == 57343 then
			error(Error.new("URI malformed"))
		end
	end

	if v7 >= 56320 and v7 < 57343 then
		error(Error.new("URI malformed"))
	end

	return (HttpService:UrlEncode(s1):gsub("%%2D", "-"):gsub("%%5F", "_"):gsub("%%2E", "."):gsub("%%21", "!"):gsub("%%7E", "~"):gsub("%%2A", "*"):gsub("%%27", "'"):gsub("%%28", "("):gsub("%%29", ")"))
end

return encodeURIComponent
