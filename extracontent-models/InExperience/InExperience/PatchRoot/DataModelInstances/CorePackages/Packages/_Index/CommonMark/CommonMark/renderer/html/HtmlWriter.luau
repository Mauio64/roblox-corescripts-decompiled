local CommonMark = script:FindFirstAncestor("CommonMark")
local Escaping = require(CommonMark.internal.util.Escaping)
require(CommonMark.internal.port.LinkedHashMap)

local byte = string.byte

local HtmlWriter = {}
HtmlWriter.__index = HtmlWriter

function HtmlWriter.new(buf)
	return (setmetatable({
		_buffer = buf,
		_n = #buf,
		_lastChar = 0
	}, HtmlWriter))
end

function HtmlWriter:raw(p: string)
	self:append(p)
end

function HtmlWriter:text(p: string)
	self:append(Escaping.escapeHtml(p))
end

function HtmlWriter:tag(p: string, object, flag: boolean?)
	self:append("<")
	self:append(p)

	if object ~= nil and not object:isEmpty() then
		for k, v in object:entrySet() do
			self:append(" ")
			self:append(Escaping.escapeHtml(k))

			if v == nil then
				continue
			end

			self:append("=\"")
			self:append(Escaping.escapeHtml(v))
			self:append("\"")
		end
	end

	if flag then
		self:append(" /")
	end

	self:append(">")
end

function HtmlWriter:line()
	if self._lastChar ~= 0 and self._lastChar ~= 10 then
		self:append("\n")
	end
end

function HtmlWriter:append(value: string)
	self._n += 1
	self._buffer[self._n] = value
	local count = #value

	if count ~= 0 then
		self._lastChar = byte(value, count)
	end
end

return HtmlWriter
