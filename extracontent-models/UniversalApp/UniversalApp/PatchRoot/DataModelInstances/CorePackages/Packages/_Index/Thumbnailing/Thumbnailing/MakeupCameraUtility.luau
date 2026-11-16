local function makeCameraCFrame(vector3: Vector3, vector3_2: Vector3)
	return CFrame.lookAt(vector3, vector3 + vector3_2)
end
local cframe = CFrame.lookAt(Vector3.new(0, 0.0936213, -15.755899), Vector3.new(0, 0.0936213, -14.755899))
local v = {
	[76] = CFrame.lookAt(Vector3.new(4.5928926, 0.37917417, -7.374273), Vector3.new(4.0461125, 0.35952252, -6.537227)),
	[77] = CFrame.lookAt(Vector3.new(4.593966, 0.2791934, -7.375918), Vector3.new(4.047186, 0.25954175, -6.5388722)),
	[88] = cframe,
	[89] = CFrame.lookAt(Vector3.new(0, -0.2991416, -6.4134803), Vector3.new(0, -0.2991416, -5.4134803)),
	[90] = CFrame.lookAt(Vector3.new(0, 0.10852961, -9.357428), Vector3.new(0, 0.10852961, -8.357428))
}
return {
	SetupCamera = function(self, focus: CFrame, p: number?)
		local v2

		if p then
			v2 = v[p]
		end

		self.CFrame = focus * (v2 or cframe)
		self.Focus = focus
		self.FieldOfView = 5
	end
}
