local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

require(SceneUnderstanding.wiring.types)

local function getOutputWires(p1) -- line: 7
	local t1 = {}

	for _, v6 in (p1:GetOutputPins()) do
		for _, v8 in p1:GetConnectedWires(v6) do
			table.insert(t1, v8)
		end
	end

	return t1
end

return getOutputWires
