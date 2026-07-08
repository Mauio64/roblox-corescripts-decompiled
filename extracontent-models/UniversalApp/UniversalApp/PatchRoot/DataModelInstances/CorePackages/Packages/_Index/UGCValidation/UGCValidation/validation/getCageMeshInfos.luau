local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local t1 = {
	"InnerCage",
	"OuterCage"
}
local t2 = {
	"ReferenceMeshId",
	"CageMeshId"
}
local t3 = {
	Analytics.ErrorType.validateLayeredClothingAccessory_NoInnerCageId,
	Analytics.ErrorType.validateLayeredClothingAccessory_NoOuterCageId
}

local function getCageMeshInfos(p1, p2) -- line: 17
	-- upvalues: t2 (copy), t1 (copy), Analytics (copy), t3 (copy), getEditableMeshFromContext (copy)
	local WrapLayer = p1:FindFirstChild("Handle"):FindFirstChildOfClass("WrapLayer")
	local t4 = {}
	local t5 = {}

	if not WrapLayer then
		return false, { "Missing wraplayer" }, nil
	end

	local t6 = {
		WrapLayer.ReferenceMeshId,
		WrapLayer.CageMeshId
	}

	for v14, v15 in t2 do
		local t7 = {
			fullName = string.format("%s %s", WrapLayer:GetFullName(), t1[v14]),
			fieldName = v15,
			contentId = t6[v14],
			context = p1.Name
		}

		if (t7.contentId == "" or t7.contentId == nil) and not p2.allowEditableInstances then
			Analytics.reportFailure(t3[v14], nil, p2)
			table.insert(t5, string.format("Missing %s (i.e. invalid %s) on layered clothing accessory '%s'. Make sure you are using a valid meshId and try again.\n", t1[v14], v15, p1.Name))
		else
			local v17, v18 = getEditableMeshFromContext(WrapLayer, v15, p2)

			if not v17 then
				table.insert(t5, string.format("Failed to %s for layered clothing accessory '%s'. Make sure mesh exists and try again.", t1[v14], p1.Name))
			else
				t7.editableMesh = v18
				table.insert(t4, t7)
			end
		end
	end

	if #t5 > 0 then
		return false, t5, nil
	end

	return true, nil, t4
end

return getCageMeshInfos
