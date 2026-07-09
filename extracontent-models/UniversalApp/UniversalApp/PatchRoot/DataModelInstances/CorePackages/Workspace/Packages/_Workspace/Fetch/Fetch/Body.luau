local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Promise)

require(ParentParent.LuauPolyfill)

local t1 = {}

t1.__index = t1

function t1.new(s1: string?) -- line: 37
	-- upvalues: t1 (copy)
	local t2 = {}

	if type(s1) == "string" then
		t2.body = s1
	elseif s1 == nil then
		t2.body = nil
	else
		error(string.format("Expected string or nil as the first argument to Body.new(), but got: %s", (type(s1))))
	end

	t2.bodyUsed = false
	setmetatable(t2, t1)

	return t2
end
function t1.arrayBuffer(_) -- line: 53
	-- upvalues: Promise (copy)
	return Promise.new(function(_, reject) -- line: 54
		reject("arrayBuffer not implemented")
	end)
end
function t1.blob(_) -- line: 60
	-- upvalues: Promise (copy)
	return Promise.new(function(_, reject) -- line: 61
		reject("blob not implemented")
	end)
end
function t1.formData(_) -- line: 67
	-- upvalues: Promise (copy)
	return Promise.new(function(_, reject) -- line: 68
		reject("formData not implemented")
	end)
end
function t1.json(p7) -- line: 74
	-- upvalues: Promise (copy), HttpService (copy)
	return Promise.new(function(resolve, reject) -- line: 75
		-- upvalues: p7 (copy), HttpService (copy)
		if p7._json then
			resolve(p7._json)

			return
		end

		local ok, result = pcall(function() -- line: 81
			-- upvalues: HttpService (copy), p7 (copy)
			return HttpService:JSONDecode(p7.body)
		end)

		if not ok then
			reject("Failed to decode response body as JSON. JSON decoding is only supported for Content-Type = application/json")

			return
		end

		p7._json = result
		resolve(result)
	end)
end
function t1.text(p8) -- line: 97
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 98
		-- upvalues: p8 (copy)
		resolve(p8.body or "")
	end)
end

return {
	Body = t1
}
