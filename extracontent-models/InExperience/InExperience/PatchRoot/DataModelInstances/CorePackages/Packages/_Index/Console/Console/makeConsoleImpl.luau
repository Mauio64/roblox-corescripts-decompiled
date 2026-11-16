local parent = script.Parent.Parent
local Collections = require(parent.Collections)
local inspect = Collections.inspect

return function()
	local v = 0

	local function indent() -- 7 equivalent calls inferred from this helper
		return string.rep("  ", v)
	end

	return {
		log = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			print(indent() .. v2) -- inferred equivalent call
		end,
		debug = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			print(indent() .. v2) -- inferred equivalent call
		end,
		info = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			print(indent() .. v2) -- inferred equivalent call
		end,
		warn = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			warn(indent() .. v2) -- inferred equivalent call
		end,
		error = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			warn(indent() .. v2) -- inferred equivalent call
		end,
		group = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			print(indent() .. v2) -- inferred equivalent call
			v += 1
		end,
		groupCollapsed = function(formatString, ...)
			local v2

			if typeof(formatString) == "string" then
				v2 = string.format(formatString, ...)
			else
				v2 = inspect(formatString)
			end

			print(indent() .. v2) -- inferred equivalent call
			v += 1
		end,
		groupEnd = function()
			if v > 0 then
				v -= 1
			end
		end
	}
end
