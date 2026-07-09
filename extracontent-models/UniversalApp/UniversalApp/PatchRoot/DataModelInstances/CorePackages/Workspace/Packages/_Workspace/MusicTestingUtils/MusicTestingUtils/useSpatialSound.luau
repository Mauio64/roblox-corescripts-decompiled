local MusicTestingUtils = script:FindFirstAncestor("MusicTestingUtils")
local useEffect = require(MusicTestingUtils.Parent.React).useEffect

local function useSpatialSound(n1: number, t1: {[any]: any}) -- line: 7
	-- upvalues: useEffect (copy)
	useEffect(function() -- line: 8
		-- upvalues: t1 (copy), n1 (copy)
		local t2 = {}

		if t1 then
			local CurrentCamera = workspace.CurrentCamera

			assert(CurrentCamera, "No CurrentCamera")

			local Sound = Instance.new("Sound")

			Sound.Name = `Sound_{ n1 }`
			Sound.SoundId = `rbxassetid://{ n1 }`
			Sound.Looped = true
			table.insert(t2, Sound)

			local Part = Instance.new("Part")

			Part.Name = `PluginSoundEmitter_{ n1 }`
			Part.Position = CurrentCamera.CFrame.Position
			Part.Anchored = true
			table.insert(t2, Part)
			Sound.Parent = Part
			Part.Parent = t1.current
			Sound:Play()
		end

		return function() -- line: 33
			-- upvalues: t2 (copy)
			for _, v11 in t2 do
				v11:Destroy()
			end
		end
	end, {
		n1,
		t1
	})
end

return useSpatialSound
