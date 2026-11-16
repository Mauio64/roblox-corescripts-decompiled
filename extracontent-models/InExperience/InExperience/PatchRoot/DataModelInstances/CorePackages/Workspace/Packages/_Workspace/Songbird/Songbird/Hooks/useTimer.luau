local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)

local useEffect = React.useEffect

local function useTimer(duration: number, callback, options)
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
	end, Cryo.Dictionary.join({ duration, callback }, options or {}))
end

return useTimer
