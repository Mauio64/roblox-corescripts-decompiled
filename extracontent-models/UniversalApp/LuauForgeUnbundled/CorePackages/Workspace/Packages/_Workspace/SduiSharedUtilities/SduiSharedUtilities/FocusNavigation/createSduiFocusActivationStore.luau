local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppCommonLib")

local function createSduiFocusActivationStore()
	local object = setmetatable({}, { __mode = "v" })

	return {
		register = function(p2, p3)
			local v5 = object[p2]

			if v5 == nil then
				v5 = AppCommonLib.Signal.new()
				object[p2] = v5
			end

			local connection = v5:connect(p3)
			return function()
				connection.disconnect()
			end
		end,
		activate = function(p2)
			local v5 = object[p2]

			if v5 then
				v5:fire()
			end
		end
	}
end

return createSduiFocusActivationStore
