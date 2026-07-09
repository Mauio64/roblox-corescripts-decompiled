local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local AppCommonLib = require(Parent.AppCommonLib)

local function createSduiFocusActivationStore() -- line: 26
	-- upvalues: AppCommonLib (copy)
	local self = setmetatable({}, {
		__mode = "v"
	})

	return {
		register = function(s1: string, p1: ((...any) -> ...any)) -- line: 34
			-- upvalues: self (copy), AppCommonLib (copy)
			local v7 = self[s1]

			if v7 == nil then
				v7 = AppCommonLib.Signal.new()
				self[s1] = v7
			end

			local v8 = v7:connect(p1)

			return function() -- line: 41
				-- upvalues: v8 (copy)
				v8.disconnect()
			end
		end,
		activate = function(s2: string) -- line: 46
			-- upvalues: self (copy)
			local v10 = self[s2]

			if v10 then
				v10:fire()
			end
		end
	}
end

return createSduiFocusActivationStore
