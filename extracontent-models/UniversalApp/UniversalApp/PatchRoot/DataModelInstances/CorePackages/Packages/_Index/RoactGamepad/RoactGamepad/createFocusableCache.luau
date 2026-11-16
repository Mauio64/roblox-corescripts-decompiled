local asFocusable = require(script.Parent.asFocusable)

local function checkHostProperties(className)
	assert(Instance.new(className):IsA("GuiObject"))
end

local function isValidFocusable(p)
	local typeName = typeof(p)

	if typeName ~= "string" then
		return typeName == "function" or typeName == "table"
	end

	local success, _ = pcall(checkHostProperties, p)
	return success
end

local function createFocusableCache()
	local focusableCache = {}

	setmetatable(focusableCache, {
		__index = function(_, p)
			local typeName = typeof(p)
			local success

			if typeName == "string" then
				local result
				success, result = pcall(checkHostProperties, p)
			else
				success = typeName == "function" or typeName == "table"
			end

			if not success then
				error("Component " .. tostring(p) .. " (" .. typeof(p) .. ") is not a valid focusable component", 2)
			end

			local v = asFocusable(p)
			focusableCache[p] = v

			return v
		end,
		__tostring = function(items)
			local v = "{"

			for k, item in pairs(items) do
				v = ("%s\n\t%s -> %s"):format(v, tostring(k), (tostring(item)))
			end

			return v .. "\n}"
		end
	})

	return focusableCache
end

return createFocusableCache
