local HttpService = game:GetService("HttpService")

local function encodeURIComponent(p: string)
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
