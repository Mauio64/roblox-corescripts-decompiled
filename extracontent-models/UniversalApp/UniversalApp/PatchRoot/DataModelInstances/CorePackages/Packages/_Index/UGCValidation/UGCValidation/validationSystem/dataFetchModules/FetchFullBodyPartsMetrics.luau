local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local BoundsCalculator = require(parent.util.BoundsCalculator)

return {
	getData = function(data)
		local rootInstance = data.rootInstance
		local renderMeshesData = data.renderMeshesData

		if not renderMeshesData then
			return {}
		end

		local partsByName = {}

		for _, part in rootInstance:GetChildren() do
			if part:IsA("MeshPart") then
				partsByName[part.Name] = part
			end
		end

		local editableMeshes = {}

		for childName, v in renderMeshesData do
			local child = rootInstance:FindFirstChild(childName, true)

			if child and v.editable then
				editableMeshes[child] = {
					MeshId = { instance = v.editable, created = false }
				}
			end
		end

		local v = {
			isServer = data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend,
			editableMeshes = editableMeshes
		}

		local individualFullBodyPartsData, _, v2 = BoundsCalculator.calculateIndividualFullBodyPartsData(
			partsByName,
			v,
			nil,
			false
		)

		if individualFullBodyPartsData then
			return v2
		end

		return {}
	end
}
