local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Dropdown)

local function useScrollToSelectedRef(list, p: number)
	local ref = React.useRef(nil)
	local v = React.useCallback(function()
		if ref.current then
			for _, connection in ref.current do
				connection:Disconnect()
			end

			ref.current = nil
		end
	end, {})

	local v2 = React.useCallback(function(instance)
		v()

		if not instance then
			return
		end

		local function scrollToSelected(): boolean
			local count = #list
			local y = instance.AbsoluteCanvasSize.Y
			local y2 = instance.AbsoluteWindowSize.Y

			if count == 0 or y2 <= 0 or y <= y2 then
				return false
			end

			local v2 = y / count
			local v3 = 0

			for k, item in list do
				if item.id == p then
					v3 = k - 1
					break
				end
			end

			local v4 = v3 * v2 - y2 / 2 + v2 / 2
			instance.CanvasPosition = Vector2.new(0, (math.clamp(v4, 0, y - y2)))
			return true
		end

		if not scrollToSelected() then
			local function onSizeChanged()
				if scrollToSelected() then
					v()
				end
			end
			ref.current = {
				instance:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(onSizeChanged),
				instance:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(onSizeChanged)
			}
		end
	end, { list, p, v })

	React.useEffect(function()
		return v
	end, { v })

	return v2
end

return useScrollToSelectedRef
