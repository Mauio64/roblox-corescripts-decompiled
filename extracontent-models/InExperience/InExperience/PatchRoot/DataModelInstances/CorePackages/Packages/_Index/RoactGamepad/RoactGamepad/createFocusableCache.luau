local asFocusable = require(script.Parent.asFocusable)

local function checkHostProperties(p1) -- line: 3
	assert(Instance.new(p1):IsA("GuiObject"))
end
local function isValidFocusable(p2) -- line: 9
	-- upvalues: checkHostProperties (copy)
	local v7 = typeof(p2)

	if v7 == "string" then
		local ok, _ = pcall(checkHostProperties, p2)

		return ok
	end

	if v7 == "function" or v7 == "table" then
		return true
	end

	return false
end
local function createFocusableCache() -- line: 25
	-- upvalues: checkHostProperties (copy), asFocusable (copy)
	local t1 = {}

	setmetatable(t1, {
		__index = function(_, p4) -- line: 29
			-- upvalues: checkHostProperties (copy), asFocusable (copy), t1 (copy)
			local v13 = typeof(p4)
			local ok

			if v13 == "string" then
				local result

				ok, result = pcall(checkHostProperties, p4)
			else
				ok = v13 == "function" or v13 == "table"
			end

			if not ok then
				error("Component " .. tostring(p4) .. " (" .. typeof(p4) .. ") is not a valid focusable component", 2)
			end

			local v16 = asFocusable(p4)

			t1[p4] = v16

			return v16
		end,
		__tostring = function(p5) -- line: 39
			local s1 = "{"

			for k, v in pairs(p5) do
				s1 = ("%s\n\t%s -> %s"):format(s1, tostring(k), (tostring(v)))
			end

			return s1 .. "\n}"
		end
	})

	return t1
end

return createFocusableCache
