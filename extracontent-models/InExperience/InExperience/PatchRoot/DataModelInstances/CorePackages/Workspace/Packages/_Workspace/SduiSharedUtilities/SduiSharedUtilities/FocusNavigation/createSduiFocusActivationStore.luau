local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local AppCommonLib = require(parent.AppCommonLib)

local function createSduiFocusActivationStore()
	local object = setmetatable({}, { __mode = "v" })

	return {
		register = function(p: string, callback)
			local v = object[p]

			if v == nil then
				v = AppCommonLib.Signal.new()
				object[p] = v
			end

			local connection = v:connect(callback)
			return function()
				connection.disconnect()
			end
		end,
		activate = function(p: string)
			local v = object[p]

			if v then
				v:fire()
			end
		end
	}
end

return createSduiFocusActivationStore
