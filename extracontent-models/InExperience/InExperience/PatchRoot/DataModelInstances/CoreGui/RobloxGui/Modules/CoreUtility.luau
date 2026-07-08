local t1 = {}
local v2 = game:DefineFastInt("WaitForChildOfClassTimeout", 0)

if v2 > 0 then
	function t1.waitForChildOfClass(p1, p2) -- line: 5
		-- upvalues: v2 (copy)
		local p2_2 = p1:FindFirstChildOfClass(p2)
		local v6 = tick() + v2

		while not p2_2 and v6 > tick() do
			task.wait()
			p2_2 = p1:FindFirstChildOfClass(p2)
		end

		return p2_2
	end
else
	function t1.waitForChildOfClass(p3, p4) -- line: 15
		local p4_2 = p3:FindFirstChildOfClass(p4)

		while not p4_2 or p4 ~= p4_2.ClassName do
			p4_2 = p3.ChildAdded:Wait()
		end

		return p4_2
	end
end

function t1.waitForChildWhichIsA(p5, p6) -- line: 24
	local p6_2 = p5:FindFirstChildWhichIsA(p6)

	while not p6_2 or not p6_2:IsA(p6) do
		p6_2 = p5.ChildAdded:Wait()
	end

	return p6_2
end

return t1
