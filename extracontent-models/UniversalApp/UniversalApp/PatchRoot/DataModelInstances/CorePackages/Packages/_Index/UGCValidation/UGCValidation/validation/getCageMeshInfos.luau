local parent = script.Parent.Parent

require(parent.util.Types)
local Analytics = require(parent.Analytics)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local v = { "InnerCage", "OuterCage" }
local v2 = { "ReferenceMeshId", "CageMeshId" }
local v3 = {
	Analytics.ErrorType.validateLayeredClothingAccessory_NoInnerCageId,
	Analytics.ErrorType.validateLayeredClothingAccessory_NoOuterCageId
}

local function getCageMeshInfos(instance, p)
	local wrapLayer = instance:FindFirstChild("Handle"):FindFirstChildOfClass("WrapLayer")
	local result = {}
	local result2 = {}

	if not wrapLayer then
		return false, { "Missing wraplayer" }, nil
	end

	local v4 = { wrapLayer.ReferenceMeshId, wrapLayer.CageMeshId }

	for k, fieldName in v2 do
		local v5 = {
			fullName = string.format("%s %s", wrapLayer:GetFullName(), v[k]),
			fieldName = fieldName,
			contentId = v4[k],
			context = instance.Name
		}

		if v5.contentId ~= "" and v5.contentId ~= nil or p.allowEditableInstances then
			local editableMeshFromContext, editableMesh = getEditableMeshFromContext(wrapLayer, fieldName, p)

			if editableMeshFromContext then
				v5.editableMesh = editableMesh

				table.insert(result, v5)
			else
				table.insert(
					result2,
					string.format(
						"Failed to %s for layered clothing accessory '%s'. Make sure mesh exists and try again.",
						v[k],
						instance.Name
					)
				)
			end
		else
			Analytics.reportFailure(v3[k], nil, p)
			table.insert(
				result2,
				string.format(
					"Missing %s (i.e. invalid %s) on layered clothing accessory '%s'. Make sure you are using a valid meshId and try again.\n",
					v[k],
					fieldName,
					instance.Name
				)
			)
		end
	end

	if #result2 > 0 then
		return false, result2, nil
	end

	return true, nil, result
end

return getCageMeshInfos
