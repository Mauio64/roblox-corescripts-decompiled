local parent = script.Parent.Parent
local lib = parent.lib
local src = parent.src

local nocasetable = require(lib.nocasetable)
local html = require(lib.html)

local json = require(src.json)
local cookies = require(src.cookies)

local v = { "text/html", "application/xhtml+xml" }

local Response = {}
Response.__index = Response
function Response.new(request, data, response_time)
	local object = setmetatable({}, Response)

	object.request = request

	object.response_time = response_time
	object.timestamp = object.request.timestamp

	object.url = request.url
	object.method = request.method

	object.code = data.StatusCode
	object.status_code = data.StatusCode

	object.success = data.Success
	object.ok = object.status_code >= 200 and object.status_code < 300

	object.message = data.StatusMessage
	object.headers = nocasetable(data.Headers)

	object.content = data.Body
	object.text = data.Body

	object.headers["content-type"] = object.headers["content-type"] or "text/plain"

	object.from_cache = false

	local parts = object.headers["content-type"]:split(";")
	object.content_type = parts[1]:lower()
	object.encoding = parts[2] and parts[2]:split("=")[2] or ""

	object.content_length = #object.text

	object.cookies = cookies.new()

	if object.headers["set-cookie"] then
		object.cookies:SetCookie(object.headers["set-cookie"])
	end

	return object
end

function Response.expand(_) end

function Response.__tostring(p)
	return p.text
end

function Response.json(p)
	local success, result = pcall(function()
		return json.dec(p.text)
	end)

	if not success then
		error(("[http] Failed to convert response content to JSON:\n%s"):format(p.text))
	end

	return result
end

function Response.html(data, p)
	if p or table.find(v, data.content_type) then
		return html.parse(data.text, 100000, (tostring(data.url)))
	end

	error("[http] Response is not specified as HTML.")
end

function Response.xml(p, p2)
	if p2 or p.content_type:find("+xml") or p.content_type:find("/xml") then
		return html.parse(p.text, 100000)
	end

	error("[http] Response is not specified as XML.")
end

return Response
