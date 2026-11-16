local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)

local function useUniformItemHeight(flag: boolean)
	local ref = React.useRef({})
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(0)

	local state, setState = React.useState(nil)
	local measuredMaxHeightBinding, v = React.useBinding(nil)

	local onItemSizeChanged = React.useCallback(function(p: number, p2)
		if not flag then
			return
		end

		local x = p2.AbsoluteSize.X
		local y = p2.AbsoluteSize.Y

		if ref3.current > 0 and math.abs(x - ref3.current) > 1 then
			ref3.current = x
			ref.current = {}
			setState(nil)
			v(nil)
		else
			ref3.current = x

			if y <= 0 or ref.current[p] == y then
				return
			end

			ref.current[p] = y

			if not ref2.current then
				ref2.current = true
				task.defer(function()
					ref2.current = false
					local maxValue = 0

					for _, v2 in ref.current do
						maxValue = math.max(maxValue, v2)
					end

					if maxValue > 0 then
						v(maxValue)
						setState(maxValue)
					end
				end)
			end
		end
	end, { flag })

	if not flag then
		state = nil
	end

	if not flag then
		measuredMaxHeightBinding = nil
	end

	if not flag then
		onItemSizeChanged = nil
	end

	return {
		measuredMaxHeight = state,
		measuredMaxHeightBinding = measuredMaxHeightBinding,
		onItemSizeChanged = onItemSizeChanged
	}
end

return useUniformItemHeight
