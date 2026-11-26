local v5 = nil

local function playReactionHoverHaptic()
	pcall(function()
		if v5 == nil then
			local hapticEffect = Instance.new("HapticEffect")
			hapticEffect.Type = Enum.HapticEffectType.UIHover
			hapticEffect.Position = Vector3.new(0, 0, 0)
			hapticEffect.Radius = 100
			hapticEffect.Parent = workspace
			v5 = hapticEffect
		end

		v5:Play()
	end)
end

return playReactionHoverHaptic
