local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

local gestureInput = require(script.Parent.gestureInput)

local function useSwipeSession(current, callback, data, flag: boolean)
	local ref = React.useRef(current)
	ref.current = current
	local v = React.useState(function()
		return callback(ref)
	end)

	React.useEffect(function()
		if not flag then
			return
		end

		local v2 = gestureInput.connectPointer({
			onBegan = function(p)
				return data.onInputBegan(v, p)
			end,
			onChanged = function(p)
				data.onInputChanged(v, p)
			end,
			onEnded = function(p)
				return data.onInputEnded(v, p)
			end
		})

		return function()
			v2()
			data.reset(v)
		end
	end, { flag })
end

return useSwipeSession
