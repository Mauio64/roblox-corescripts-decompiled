local parent = script.Parent.Parent
local lib = parent.lib
local src = parent.src

local HttpService = game:GetService("HttpService")

local mimetypes = require(lib.mimetypes)
local b64 = require(lib.b64)

local function randomString(p)
	local v = ""

	for _ = 1, p do
		v ..= string.char(math.random(97, 122))
	end

	return v
end

local class = {}
class.__index = class
function class.new(...)
	local self = setmetatable({}, class)

	self.__IsFile = true

	self.name = "unknown"
	self.content = ""
	self.content_type = nil

	local v = { ... }

	if #v == 1 then
		self.content = v[1]
	elseif #v >= 2 then
		self.name = v[1]
		self.content = v[2]
		self.content_type = v[3]
	end

	if not self.content_type then
		local parts = self.name:split(".")
		self.content_type = mimetypes[parts[#parts]:lower()] or "text/plain"
	end

	if type(self.content) ~= "string" then
		error(("[http] Invalid file content for file %s"):format(self.name))
	end

	return self
end

function class.__tostring(p)
	return ("File('%s', '%s')"):format(p.name, p.content_type)
end

local class2 = {}
class2.__index = class2
function class2.new(options)
	local self = setmetatable({}, class2)
	self.__FormData = true

	self.boundary = "--FormBoundary-" .. randomString(28)
	self.content_type = "application/x-www-form-urlencoded"

	self.fields = {}

	for k, v in pairs(options or {}) do
		self:AddField(k, v)
	end

	return self
end

function class2:AddField(name, p)
	if p.__IsFile then
		self.content_type = "multipart/form-data; boundary=\"" .. self.boundary .. "\""
	end

	table.insert(self.fields, { Name = name, Value = p })
end

function class2.build(data)
	local v = ""

	if data.content_type == "application/x-www-form-urlencoded" then
		for _, field in ipairs(data.fields) do
			if field.Value.__IsFile then
				error("[http] URL encoded forms cannot contain any files")
			end

			if field.Name:find("=") or field.Name:find("&") then
				error("[http] Form field names must not contain '=' or '&'")
			end

			if type(field.Value) == "table" then
				for _, v2 in ipairs(field.Value) do
					if #v > 0 then
						v ..= "&"
					end

					v ..= field.Name .. "=" .. HttpService:UrlEncode(v2)
				end
			else
				if #v > 0 then
					v ..= "&"
				end

				v ..= field.Name .. "=" .. HttpService:UrlEncode(field.Value)
			end
		end

		return v
	end

	for _, field in pairs(data.fields) do
		local v2 = v .. "--" .. data.boundary .. "\r\n"

		local v3 = field.Value

		local v4 = v2 .. ("Content-Disposition: form-data; name=\"%s\""):format(field.Name)

		if field.Value.__IsFile then
			v3 = field.Value.content

			v4 = (v4 .. ("; filename=\"%s\""):format(field.Value.name)) .. "\r\nContent-Type: " .. field.Value.content_type

			if field.Value.content_type:sub(1, 5) ~= "text/" then
				v3 = b64.encode(v3)
				v4 ..= "\r\nContent-Transfer-Encoding: base64"
			end
		end

		v = v4 .. "\r\n\r\n" .. v3 .. "\r\n"
	end

	return v .. "--" .. data.boundary .. "--"
end

return { ["FormData"] = class2, File = class }
