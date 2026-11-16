local charCodeAt = require(script.Parent.String.charCodeAt)
local Error = require(script.Parent.Error)
local HttpService = game:GetService("HttpService")

local function encodeURIComponent(p: string)
	local v = utf8.len(p)

	if v == 0 or v == nil then
		return ""
	end

	local v2 = charCodeAt(p, 1)

	if v == 1 then
		if v2 == 55296 then
			error(Error.new("URI malformed"))
		end

		if v2 == 57343 then
			error(Error.new("URI malformed"))
		end
	end

	if v2 >= 56320 and v2 < 57343 then
		error(Error.new("URI malformed"))
	end

	return (HttpService:UrlEncode(p):gsub("%%2D", "-"):gsub("%%5F", "_"):gsub("%%2E", "."):gsub("%%21", "!"):gsub(
		"%%7E",
		"~"
	):gsub(
		"%%2A",
		"*"
	):gsub(
		"%%27",
		"'"
	):gsub(
		"%%28",
		"("
	):gsub(
		"%%29",
		")"
	))
end

return encodeURIComponent
