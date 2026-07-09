local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)

local function useUniformItemHeight(b1: boolean) -- line: 21
	-- upvalues: React (copy)
	local v5 = React.useRef({})
	local v6 = React.useRef(false)
	local v7 = React.useRef(0)
	local v8, v9 = React.useState(nil)
	local v10, v11 = React.useBinding(nil)
	local v12 = React.useCallback(function(n1: number, p1) -- line: 29
		-- upvalues: b1 (copy), v7 (copy), v5 (copy), v9 (copy), v11 (copy), v6 (copy)
		if not b1 then
			return
		end

		local AbsoluteSizeX = p1.AbsoluteSize.X
		local AbsoluteSizeY = p1.AbsoluteSize.Y

		if v7.current > 0 and math.abs(AbsoluteSizeX - v7.current) > 1 then
			v7.current = AbsoluteSizeX
			v5.current = {}
			v9(nil)
			v11(nil)

			return
		end

		v7.current = AbsoluteSizeX

		if AbsoluteSizeY <= 0 or AbsoluteSizeY == v5.current[n1] then
			return
		end

		v5.current[n1] = AbsoluteSizeY

		if not v6.current then
			v6.current = true
			task.defer(function() -- line: 53
				-- upvalues: v6 (copy), v5 (copy), v11 (copy), v9 (copy)
				v6.current = false

				local n2 = 0

				for _, v19 in v5.current do
					n2 = math.max(n2, v19)
				end

				if n2 > 0 then
					v11(n2)
					v9(n2)
				end
			end)
		end
	end, { b1 })

	return {
		measuredMaxHeight = if not b1 then nil else v8,
		measuredMaxHeightBinding = if not b1 then nil else v10,
		onItemSizeChanged = if not b1 then nil else v12
	}
end

return useUniformItemHeight
