local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local function connectTelemetry(p1) -- line: 8
	-- upvalues: useTelemetry (copy), React (copy), Cryo (copy)
	return function(p2) -- line: 9
		-- upvalues: useTelemetry (copy), p1 (copy), React (copy), Cryo (copy)
		return function(p3) -- line: 10
			-- upvalues: useTelemetry (copy), p1 (copy), React (copy), p2 (copy), Cryo (copy)
			local v10 = useTelemetry(p1)

			return React.createElement(p2, Cryo.Dictionary.union(p3, {
				telemetry = v10
			}))
		end
	end
end

return connectTelemetry
