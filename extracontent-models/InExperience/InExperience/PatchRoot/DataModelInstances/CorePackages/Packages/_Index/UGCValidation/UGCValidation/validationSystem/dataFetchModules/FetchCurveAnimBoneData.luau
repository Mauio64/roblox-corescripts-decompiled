local parent = script.Parent.Parent.Parent
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)

return {
	getData = function(list)
		if not list or (typeof(list) ~= "table" or #list == 0) then
			return nil
		end

		local flag = false

		for _, folder in list do
			for _, folder2 in folder:GetDescendants() do
				if folder2:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(folder2.Name) then
					flag = true
					break
				end
			end

			if flag then
				break
			end
		end

		if flag then
			return { hasBones = true }
		end

		return nil
	end
}
