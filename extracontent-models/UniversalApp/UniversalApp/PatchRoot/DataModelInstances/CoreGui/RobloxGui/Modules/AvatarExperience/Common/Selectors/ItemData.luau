local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, p3) -- line: 10
	-- upvalues: Constants (copy)
	if p3 == Constants.ItemType.Asset then
		return p1.AssetInfos[p2]
	end

	if p3 == Constants.ItemType.Bundle then
		return p1.BundleInfos[p2]
	end

	return nil
end
