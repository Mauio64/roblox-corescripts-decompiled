local CollectionService = game:GetService("CollectionService")
local Constants = require(script.Parent.Constants)

return {
	AddTag = function(p1, p2, p3) -- line: 4
		-- upvalues: Constants (copy), CollectionService (copy)
		local v6 = p1 and p1.current or nil

		if p2 and v6 then
			if p3 then
				v6:SetAttribute(Constants.ItemIndex, p3)

				if not CollectionService:HasTag(v6, p2) then
					CollectionService:AddTag(v6, p2)

					return
				end
			else
				warn("addTag: impression instance not tagged, missing index")
			end
		end
	end,
	RemoveTag = function(p4, p5, p6) -- line: 18
		-- upvalues: Constants (copy), CollectionService (copy)
		local v10 = p4 and p4.current or nil

		if p5 and v10 then
			if p6 then
				v10:SetAttribute(Constants.ItemIndex, nil)
			end

			CollectionService:RemoveTag(v10, p5)
		end
	end
}
