local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

require(SceneUnderstanding.wiring.types)

local function getOutputWires(object)
	local outputPins = object:GetOutputPins()
	local outputWires = {}

	for _, outputPin in outputPins do
		for _, v in object:GetConnectedWires(outputPin) do
			table.insert(outputWires, v)
		end
	end

	return outputWires
end

return getOutputWires
