local CollectionService = game:GetService("CollectionService")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/Constants")

return {
	AddTag = function(p2, tag, p3)
		local current = p2 and p2.current or nil

		if tag and current then
			if p3 then
				current:SetAttribute(Constants.ItemIndex, p3)

				if not CollectionService:HasTag(current, tag) then
					CollectionService:AddTag(current, tag)
				end
			else
				warn("addTag: impression instance not tagged, missing index")
			end
		end
	end,
	RemoveTag = function(p2, tag, p3)
		local current = p2 and p2.current or nil

		if tag and current then
			if p3 then
				current:SetAttribute(Constants.ItemIndex, nil)
			end

			CollectionService:RemoveTag(current, tag)
		end
	end
}
