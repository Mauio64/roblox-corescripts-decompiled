local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

local function useUniformItemHeight(p2)
	local ref = React.useRef({})
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(0)

	local state, setState = React.useState(nil)
	local v5, v6 = React.useBinding(nil)

	local v7 = React.useCallback(function(p3, p4)
		if not p2 then
			return
		end

		local x = p4.AbsoluteSize.X
		local y = p4.AbsoluteSize.Y

		if ref3.current > 0 and math.abs(x - ref3.current) > 1 then
			ref3.current = x
			ref.current = {}
			setState(nil)
			v6(nil)
		else
			ref3.current = x

			if y <= 0 or ref.current[p3] == y then
				return
			end

			ref.current[p3] = y

			if not ref2.current then
				ref2.current = true
				task.defer(function()
					ref2.current = false
					local maxValue = 0

					for k, v8 in ref.current do
						maxValue = math.max(maxValue, v8)
					end

					if maxValue > 0 then
						v6(maxValue)
						setState(maxValue)
					end
				end)
			end
		end
	end, { p2 })

	if not p2 then
		state = nil
	end

	if not p2 then
		v5 = nil
	end

	if not p2 then
		v7 = nil
	end

	return {
		measuredMaxHeight = state,
		measuredMaxHeightBinding = v5,
		onItemSizeChanged = v7
	}
end

return useUniformItemHeight
