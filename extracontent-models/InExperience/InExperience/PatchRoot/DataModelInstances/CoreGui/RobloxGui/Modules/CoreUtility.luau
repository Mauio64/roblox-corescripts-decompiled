local CoreUtility = {}
local defineFastInt = game:DefineFastInt("WaitForChildOfClassTimeout", 0)

if defineFastInt > 0 then
	function CoreUtility.waitForChildOfClass(instance, className)
		local v = instance:FindFirstChildOfClass(className)
		local v2 = tick() + defineFastInt

		while not v and tick() < v2 do
			task.wait()
			v = instance:FindFirstChildOfClass(className)
		end

		return v
	end
else
	function CoreUtility.waitForChildOfClass(instance, className)
		local v = instance:FindFirstChildOfClass(className)

		while not v or v.ClassName ~= className do
			v = instance.ChildAdded:Wait()
		end

		return v
	end
end

function CoreUtility.waitForChildWhichIsA(instance, className)
	local v = instance:FindFirstChildWhichIsA(className)

	while not (v and v:IsA(className)) do
		v = instance.ChildAdded:Wait()
	end

	return v
end

return CoreUtility
