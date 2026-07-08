local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local Otter = require(ParentParent.Otter)

local function useMotor(p1, p2, p3) -- line: 13
	-- upvalues: React (copy), Otter (copy)
	local v8 = React.useRef(nil)
	local v9 = React.useRef(nil)

	if not v8.current then
		local u10 = if typeof(p1) ~= "number" then Otter.createGroupMotor(p1) else Otter.createSingleMotor(p1)

		function v9.current(p4) -- line: 26
			-- upvalues: u10 (ref)
			u10:setGoal(p4)
		end

		v8.current = u10
	end

	React.useEffect(function() -- line: 34
		-- upvalues: v8 (copy), p3 (copy), p2 (copy)
		local u12 = nil
		local u13 = nil

		if v8.current then
			if p3 then
				u12 = v8.current:onComplete(p3)
			end

			u13 = v8.current:onStep(p2)
		end

		return function() -- line: 43
			-- upvalues: u12 (ref), u13 (ref)
			if u12 then
				u12()
			end

			if u13 then
				u13()
			end
		end
	end, {
		p2,
		p3
	})
	React.useEffect(function() -- line: 54
		-- upvalues: v8 (copy)
		return function() -- line: 55
			-- upvalues: v8 (copy)
			if v8.current then
				v8.current:destroy()
				v8.current = nil
			end
		end
	end, { v8.current })

	return v9.current
end

return useMotor
