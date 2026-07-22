local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local React = require(Parent.React)
local SharedFlags = require(Parent.SharedFlags)
local v5 = SharedFlags.FFlagLuaAppUseDeviceSafeInsetsForAppContainer and SharedFlags.FFlagLuaAppSupportDeviceSafeInsets

local function readStatusBarHeight() -- line: 39
	-- upvalues: v5 (copy), UserInputService (copy)
	if v5 then
		return 0
	end

	local StatusBarSize = UserInputService.StatusBarSize

	if StatusBarSize then
		return StatusBarSize.Y
	end

	return 0
end

return function() -- line: 47
	-- upvalues: React (copy), v5 (copy), UserInputService (copy)
	local v8, v9 = React.useState(function() -- line: 48
		-- upvalues: v5 (copy), UserInputService (copy)
		if v5 then
			return 0
		end

		local StatusBarSize = UserInputService.StatusBarSize

		if StatusBarSize then
			return StatusBarSize.Y
		end

		return 0
	end)

	React.useEffect(function() -- line: 52
		-- upvalues: v9 (copy), v5 (copy), UserInputService (copy)
		local v11 = v9
		local n1

		if v5 then
			n1 = 0
		else
			local StatusBarSize = UserInputService.StatusBarSize

			n1 = not StatusBarSize and 0 or StatusBarSize.Y
		end

		v11(n1)

		local connection = UserInputService:GetPropertyChangedSignal("StatusBarSize"):Connect(function() -- line: 57
			-- upvalues: v9 (copy), v5 (copy), UserInputService (copy)
			local v15 = v9
			local n2

			if v5 then
				n2 = 0
			else
				local StatusBarSize = UserInputService.StatusBarSize

				n2 = not StatusBarSize and 0 or StatusBarSize.Y
			end

			v15(n2)
		end)

		return function() -- line: 61
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v8
end
