local ParentParent = script.Parent.Parent
local lib = ParentParent.lib
local src = ParentParent.src
local nocasetable = require(lib.nocasetable)
local html = require(lib.html)
local json = require(src.json)
local cookies = require(src.cookies)
local t1 = {
	"text/html",
	"application/xhtml+xml"
}
local t2 = {}

t2.__index = t2

function t2.new(p1, p2, p3) -- line: 20
	-- upvalues: t2 (copy), nocasetable (copy), cookies (copy)
	local self = setmetatable({}, t2)

	self.request = p1
	self.response_time = p3
	self.timestamp = self.request.timestamp
	self.url = p1.url
	self.method = p1.method
	self.code = p2.StatusCode
	self.status_code = p2.StatusCode
	self.success = p2.Success
	self.ok = self.status_code >= 200 and self.status_code < 300
	self.message = p2.StatusMessage
	self.headers = nocasetable(p2.Headers)
	self.content = p2.Body
	self.text = p2.Body
	self.headers["content-type"] = self.headers["content-type"] or "text/plain"
	self.from_cache = false

	local parts = self.headers["content-type"]:split(";")

	self.content_type = parts[1]:lower()
	self.encoding = parts[2] and parts[2]:split("=")[2] or ""
	self.content_length = #self.text
	self.cookies = cookies.new()

	if self.headers["set-cookie"] then
		self.cookies:SetCookie(self.headers["set-cookie"])
	end

	return self
end
function t2.expand(_) -- line: 68
end
function t2.__tostring(p5) -- line: 70
	return p5.text
end
function t2.json(p6) -- line: 74
	-- upvalues: json (copy)
	local ok, result = pcall(function() -- line: 77
		-- upvalues: json (copy), p6 (copy)
		return json.dec(p6.text)
	end)

	if not ok then
		error(("[http] Failed to convert response content to JSON:\n%s"):format(p6.text))
	end

	return result
end
function t2.html(p7, p8) -- line: 88
	-- upvalues: t1 (copy), html (copy)
	if p8 or table.find(t1, p7.content_type) then
		return html.parse(p7.text, 100000, (tostring(p7.url)))
	end

	error("[http] Response is not specified as HTML.")
end
function t2.xml(p9, p10) -- line: 96
	-- upvalues: html (copy)
	if p10 or (p9.content_type:find("+xml") or p9.content_type:find("/xml")) then
		return html.parse(p9.text, 100000)
	end

	error("[http] Response is not specified as XML.")
end

return t2
