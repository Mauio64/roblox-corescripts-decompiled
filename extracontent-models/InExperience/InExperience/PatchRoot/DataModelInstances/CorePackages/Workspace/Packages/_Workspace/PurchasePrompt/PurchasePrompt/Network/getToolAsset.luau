local function getToolAsset(p, p2)
	return p.loadAssetForEquip(p2):andThen(function(tool)
		if tool:IsA("Tool") then
			return tool
		end

		local children = tool:GetChildren()

		for _, tool2 in ipairs(children) do
			if tool2:IsA("Tool") then
				return tool2
			end
		end
	end):catch(function(_): nil
		return nil
	end)
end

return getToolAsset
