local CollectionService = game:GetService("CollectionService")
local Constants = require(script.Parent.Constants)
local ImpressionsTagUtility = {}

function ImpressionsTagUtility:AddTag(tag, p)
	local current = self and self.current or nil

	if tag and current then
		if p then
			current:SetAttribute(Constants.ItemIndex, p)

			if not CollectionService:HasTag(current, tag) then
				CollectionService:AddTag(current, tag)
			end
		else
			warn("addTag: impression instance not tagged, missing index")
		end
	end
end

function ImpressionsTagUtility:RemoveTag(tag, p)
	local current = self and self.current or nil

	if tag and current then
		if p then
			current:SetAttribute(Constants.ItemIndex, nil)
		end

		CollectionService:RemoveTag(current, tag)
	end
end

return ImpressionsTagUtility
