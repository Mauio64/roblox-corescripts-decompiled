local parent = script.Parent.Parent
local React = require(parent.React)
local Otter = require(parent.Otter)

local function useMotor(value, p, p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	if not ref.current then
		local current

		if typeof(value) == "number" then
			current = Otter.createSingleMotor(value)
		else
			current = Otter.createGroupMotor(value)
		end

		function ref2.current(p3)
			current:setGoal(p3)
		end
		ref.current = current
	end

	React.useEffect(function()
		local v = nil
		local v2

		if ref.current then
			if p2 then
				v = ref.current:onComplete(p2)
			end

			v2 = ref.current:onStep(p)
		else
			v2 = nil
		end

		return function()
			if v then
				v()
			end

			if v2 then
				v2()
			end
		end
	end, { p, p2 })

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current:destroy()
				ref.current = nil
			end
		end
	end, { ref.current })

	return ref2.current
end

return useMotor
