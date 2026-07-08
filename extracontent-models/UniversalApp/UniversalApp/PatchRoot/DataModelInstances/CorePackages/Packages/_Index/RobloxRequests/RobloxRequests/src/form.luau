local ParentParent = script.Parent.Parent
local lib = ParentParent.lib
local _ = ParentParent.src
local HttpService = game:GetService("HttpService")
local mimetypes = require(lib.mimetypes)
local b64 = require(lib.b64)

local function randomString(p1) -- line: 16
	local s1 = ""

	for _ = 1, p1 do
		s1 ..= string.char(math.random(97, 122))
	end

	return s1
end

local t1 = {}

t1.__index = t1

function t1.new(...) -- line: 30
	-- upvalues: t1 (copy), mimetypes (copy)
	local self = setmetatable({}, t1)

	self.__IsFile = true
	self.name = "unknown"
	self.content = ""
	self.content_type = nil

	local t2 = { ... }

	if #t2 == 1 then
		self.content = t2[1]
	elseif #t2 >= 2 then
		self.name = t2[1]
		self.content = t2[2]
		self.content_type = t2[3]
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
function t1.__tostring(p2) -- line: 71
	return ("File('%s', '%s')"):format(p2.name, p2.content_type)
end

local t3 = {}

t3.__index = t3

function t3.new(p3) -- line: 79
	-- upvalues: t3 (copy), randomString (copy)
	local self = setmetatable({}, t3)

	self.__FormData = true

	local v19 = p3 or {}

	self.boundary = "--FormBoundary-" .. randomString(28)
	self.content_type = "application/x-www-form-urlencoded"
	self.fields = {}

	for k, v in pairs(v19) do
		self:AddField(k, v)
	end

	return self
end
function t3.AddField(p4, p5, p6) -- line: 96
	if p6.__IsFile then
		p4.content_type = "multipart/form-data; boundary=\"" .. p4.boundary .. "\""
	end

	table.insert(p4.fields, {
		Name = p5,
		Value = p6
	})
end
function t3.build(p7) -- line: 108
	-- upvalues: HttpService (copy), b64 (copy)
	local s2 = ""

	if p7.content_type == "application/x-www-form-urlencoded" then
		for _, v in ipairs(p7.fields) do
			if v.Value.__IsFile then
				error("[http] URL encoded forms cannot contain any files")
			end

			if v.Name:find("=") or v.Name:find("&") then
				error("[http] Form field names must not contain '=' or '&'")
			end

			if type(v.Value) == "table" then
				for _, v2 in ipairs(v.Value) do
					if #s2 > 0 then
						s2 ..= "&"
					end

					s2 ..= v.Name .. "=" .. HttpService:UrlEncode(v2)
				end
			else
				if #s2 > 0 then
					s2 ..= "&"
				end

				s2 ..= v.Name .. "=" .. HttpService:UrlEncode(v.Value)
			end
		end

		return s2
	end

	for _, v in pairs(p7.fields) do
		local v33 = s2 .. "--" .. p7.boundary .. "\r\n"
		local vValue = v.Value
		local v35 = v33 .. ("Content-Disposition: form-data; name=\"%s\""):format(v.Name)

		if v.Value.__IsFile then
			vValue = v.Value.content
			v35 = (v35 .. ("; filename=\"%s\""):format(v.Value.name)) .. "\r\nContent-Type: " .. v.Value.content_type

			if v.Value.content_type:sub(1, 5) ~= "text/" then
				vValue = b64.encode(vValue)
				v35 ..= "\r\nContent-Transfer-Encoding: base64"
			end
		end

		s2 = v35 .. "\r\n\r\n" .. vValue .. "\r\n"
	end

	return s2 .. "--" .. p7.boundary .. "--"
end

return {
	FormData = t3,
	File = t1
}
