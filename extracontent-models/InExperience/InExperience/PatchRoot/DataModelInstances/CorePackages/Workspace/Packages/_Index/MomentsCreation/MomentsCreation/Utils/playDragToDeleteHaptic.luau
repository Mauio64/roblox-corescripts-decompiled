local v = nil

local function playDragToDeleteHaptic()
	pcall(function()
		if v == nil then
			local hapticEffect = Instance.new("HapticEffect")
			hapticEffect.Type = Enum.HapticEffectType.UIClick
			hapticEffect.Position = Vector3.new(0, 0, 0)
			hapticEffect.Radius = 100
			hapticEffect.Parent = workspace
			v = hapticEffect
		end

		v:Play()
	end)
end

return playDragToDeleteHaptic
