local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local function useRestoreYPositionOnDefocusEffect(s1: string, p1, p2: ((...any) -> ...any), t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy)
	local v8 = React.useRef(s1)

	React.useEffect(function() -- line: 17
		-- upvalues: p2 (copy), s1 (copy), v8 (copy), p1 (copy), t1 (copy)
		local v9 = p2()

		if not v9 then
			return
		end

		assert(v9, "")

		local current = v9.current

		if not current then
			return
		end

		if s1 ~= v8.current then
			v8.current = s1
			current.CanvasPosition = Vector2.new(0, 0)

			return
		end

		if p1 and current then
			current.CanvasPosition = Vector2.new(0, 0)

			return
		end

		if not p1 then
			current.CanvasPosition = Vector2.new(0, t1.current or 0)
		end
	end, {
		s1,
		p1,
		p2,
		t1
	})
end

return useRestoreYPositionOnDefocusEffect
