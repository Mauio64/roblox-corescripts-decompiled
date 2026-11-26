local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local UserInputService = game:GetService("UserInputService")

local useEffect = React.useEffect
local useState = React.useState

local function useIsMultiTouchActive(p2)
	local state, setState = useState(false)

	useEffect(function()
		if not p2 then
			setState(false)
			return nil
		end

		local v5 = {}
		local function refreshFromActiveTouches()
			local count = 0

			for k in v5 do
				count += 1
			end

			setState(count >= 2)
		end

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p3)
			v5[p3] = true
			local count = 0

			for k in v5 do
				count += 1
			end

			setState(count >= 2)
		end)
		local touchEndedConnection = UserInputService.TouchEnded:Connect(function(otherPart)
			v5[otherPart] = nil
			local count = 0

			for k in v5 do
				count += 1
			end

			setState(count >= 2)
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
		end
	end, { p2 })

	return state
end

return useIsMultiTouchActive
