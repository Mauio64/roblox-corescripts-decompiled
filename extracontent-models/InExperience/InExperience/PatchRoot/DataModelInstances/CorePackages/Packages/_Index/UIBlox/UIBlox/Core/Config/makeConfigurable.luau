local Config = require(script.Parent.Config)

local function trimTrailingNewline(traceback) -- 2 equivalent calls inferred from this helper
	if traceback:sub(-1, -1) == "\n" then
		return traceback:sub(1, -2)
	end

	return traceback
end

return function(callback, value, p)
	if typeof(value) ~= "string" then
		error("Bad argument #2 - expected a string for the name of the library")
	end

	if typeof(p) ~= "table" then
		error("Bad argument #3 - expected a default config table for the library")
	end

	local v = {}
	local v2 = Config.new(p)

	function v.init(p2)
		setmetatable(v, nil)

		if p2 then
			v2.set(p2)
		end

		v.Config = v2.get()

		local v3 = callback(v.Config)

		for k, v4 in pairs(v3) do
			v[k] = v4
		end

		local v4 = trimTrailingNewline(debug.traceback()) -- inferred equivalent call
		function v.init(p3)
			if p3 == p2 then
				return
			end

			local v5 = trimTrailingNewline(debug.traceback()) -- inferred equivalent call
			warn(string.format(
				"%s has already been configured\nFirst init traceback:\n%s\nCurrent init traceback:\n%s",
				value,
				v4,
				v5
			))
		end

		if _G.__UIBLOX_TRACK_USAGE__ then
			return (setmetatable(v, (getmetatable(v3))))
		end

		return (setmetatable(v, {
			__index = function(_, p3)
				local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), value)

				error(formatted, 2)
			end,
			__newindex = function(_, p3, _)
				local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p3), typeof(p3), value)

				error(formatted, 2)
			end
		}))
	end

	return (setmetatable(v, {
		__index = function(_, _)
			error(("You must call %s.init(config) before using it!"):format(value), 2)
		end,
		__newindex = function(_, _, _)
			error(("You must call %s.init(config) before using it!"):format(value), 2)
		end
	}))
end
