local function getToolAsset(p2, p3)
	return p2.loadAssetForEquip(p3):andThen(function(tool)
		if tool:IsA("Tool") then
			return tool
		end

		local children = tool:GetChildren()

		for i, tool2 in ipairs(children) do
			if tool2:IsA("Tool") then
				return tool2
			end
		end
	end):catch(function(p4): nil
		return nil
	end)
end

return getToolAsset
