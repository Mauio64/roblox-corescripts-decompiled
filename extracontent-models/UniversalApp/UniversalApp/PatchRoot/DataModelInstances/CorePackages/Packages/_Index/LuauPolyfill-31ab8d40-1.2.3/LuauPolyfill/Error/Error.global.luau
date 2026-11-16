local parent = script.Parent.Parent.Parent

require(parent.ES7Types)

local class = {}

class.__index = class
function class.__tostring(p)
	return getmetatable(class).__tostring(p)
end

local function __createError(value: string?)
	local self = setmetatable({
		name = "Error",
		message = value or ""
	}, class)

	class.__captureStackTrace(self, 4)
	return self
end

function class.new(value: string?)
	local self = setmetatable({
		name = "Error",
		message = value or ""
	}, class)

	class.__captureStackTrace(self, 4)
	return self
end

function class.captureStackTrace(p, p2)
	class.__captureStackTrace(p, 3, p2)
end

function class:__captureStackTrace(p: number, callback)
	if typeof(callback) == "function" then
		local traceback = debug.traceback(nil, p)
		local v = debug.info(callback, "n")
		local v2 = debug.info(callback, "s")

		local v3 = string.gsub(v2, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1") .. ":%d* function " .. v
		local v4 = string.find(traceback, v3)
		local v5

		if v4 ~= nil then
			local _
			_, v5 = string.find(traceback, "\n", v4 + 1)
		end

		if v5 ~= nil then
			traceback = string.sub(traceback, v5 + 1)
		end

		self.__stack = traceback
	else
		self.__stack = debug.traceback(nil, p)
	end

	class.__recalculateStacktrace(self)
end

function class:__recalculateStacktrace()
	local message = self.message
	self.stack = ((self.name or "Error") .. ((message == nil or message == "") and "" or ": " .. message)) .. "\n" .. (not self.__stack and "" or self.__stack)
end

return (setmetatable(class, {
	__call = function(_, ...)
		local self = setmetatable({
			name = "Error",
			message = ... or ""
		}, class)

		class.__captureStackTrace(self, 4)
		return self
	end,
	__tostring = function(p)
		if p.name == nil then
			return (tostring("Error"))
		end

		if p.message and p.message ~= "" then
			return string.format("%s: %s", tostring(p.name), (tostring(p.message)))
		end

		return (tostring(p.name))
	end
}))
