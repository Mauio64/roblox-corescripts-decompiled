local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local function useRestoreYPositionOnDefocusEffect(current, p2, callback, p3)
	local ref = React.useRef(current)
	React.useEffect(function()
		local v5 = callback()

		if not v5 then
			return
		end

		assert(v5, "")

		local current2 = v5.current

		if not current2 then
			return
		end

		if current == ref.current then
			if p2 and current2 then
				current2.CanvasPosition = Vector2.new(0, 0)
			elseif not p2 then
				current2.CanvasPosition = Vector2.new(0, p3.current or 0)
			end
		else
			ref.current = current
			current2.CanvasPosition = Vector2.new(0, 0)
		end
	end, { current, p2, callback, p3 })
end

return useRestoreYPositionOnDefocusEffect
