local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)

local UserInputService = game:GetService("UserInputService")

local useEffect = React.useEffect
local useState = React.useState

local function useIsMultiTouchActive(flag: boolean)
	local state, setState = useState(false)

	useEffect(function()
		if not flag then
			setState(false)
			return nil
		end

		local v = {}
		local function refreshFromActiveTouches() -- 2 equivalent calls inferred from this helper
			local count = 0

			for _ in v do
				count += 1
			end

			setState(count >= 2)
		end

		local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p)
			v[p] = true
			refreshFromActiveTouches() -- inferred equivalent call
		end)
		local touchEndedConnection = UserInputService.TouchEnded:Connect(function(otherPart)
			v[otherPart] = nil
			refreshFromActiveTouches() -- inferred equivalent call
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()
		end
	end, { flag })

	return state
end

return useIsMultiTouchActive
