local parent = script.Parent.Parent.Parent
require(parent.LuauPolyfill)

local function fn(...)
	error("Not implemented. Dependencies used upstream aren't implemented")
end

return {
	default = function(p)
		local result = {}

		for _, supportedCommand in ipairs(p.supportedCommands) do
			result[supportedCommand] = function(p2, ...)
				fn(p2, supportedCommand, ...)
			end
		end

		return result
	end
}
