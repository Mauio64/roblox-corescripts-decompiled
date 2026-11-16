require("@luauforge/bundled/dMc")

local function getTaxonomyName(list)
	if list and #list > 0 then
		local taxonomyName = list[1].taxonomyName

		if taxonomyName and taxonomyName ~= "" then
			return taxonomyName
		end
	end

	return nil
end

return getTaxonomyName
