require(script.Parent.Parent.Types)

local function createStaticModelSource(instance)
	return function(_)
		local clone = instance:Clone()
		local humanoid = clone:FindFirstChildOfClass("Humanoid")
		local animator

		if humanoid then
			animator = humanoid:FindFirstChildOfClass("Animator")
		end

		return { model = clone, humanoid = humanoid, animator = animator }
	end
end

return createStaticModelSource
