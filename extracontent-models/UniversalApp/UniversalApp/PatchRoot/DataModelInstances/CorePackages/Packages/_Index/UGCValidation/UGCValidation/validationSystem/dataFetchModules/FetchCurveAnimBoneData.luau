local ParentParent = script.Parent.Parent.Parent
local CurveAnimBoneHierarchyUtils = require(ParentParent.util.CurveAnimBoneHierarchyUtils)

return {
	getData = function(t1: {[any]: any}?) -- line: 6
		-- upvalues: CurveAnimBoneHierarchyUtils (copy)
		if not t1 then
			return nil
		end

		if typeof(t1) ~= "table" or #t1 == 0 then
			return nil
		end

		local v4 = false

		for _, v6 in t1 do
			for _, descendant in v6:GetDescendants() do
				if descendant:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(descendant.Name) then
					v4 = true

					break
				end
			end

			if v4 then
				break
			end
		end

		if not v4 then
			return nil
		end

		return {
			hasBones = true
		}
	end
}
