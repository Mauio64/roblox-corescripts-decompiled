local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local function getTaxonomyName(t1: {[any]: any}?) -- line: 9
	if t1 and #t1 > 0 then
		local taxonomyName = t1[1].taxonomyName

		if taxonomyName and taxonomyName ~= "" then
			return taxonomyName
		end
	end

	return nil
end

return getTaxonomyName
