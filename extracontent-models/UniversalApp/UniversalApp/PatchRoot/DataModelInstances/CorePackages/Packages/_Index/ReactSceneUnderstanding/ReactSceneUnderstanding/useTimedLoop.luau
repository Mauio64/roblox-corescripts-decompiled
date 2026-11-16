local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local React = require(ReactSceneUnderstanding.Parent.React)

local useEffect = React.useEffect

local function useTimedLoop(duration: number, callback)
	useEffect(function()
		local flag = true

		task.spawn(function()
			while flag do
				task.wait(duration)

				if not flag then
					break
				end

				callback()
			end
		end)

		return function()
			flag = false
		end
	end, { duration, callback })
end

return useTimedLoop
