local function getToolAsset(p1, p2) -- line: 2
	return p1.loadAssetForEquip(p2):andThen(function(p3) -- line: 5
		if p3:IsA("Tool") then
			return p3
		end

		local children = p3:GetChildren()

		for _, v in ipairs(children) do
			if v:IsA("Tool") then
				return v
			end
		end
	end):catch(function(_) -- line: 17
		return nil
	end)
end

return getToolAsset
