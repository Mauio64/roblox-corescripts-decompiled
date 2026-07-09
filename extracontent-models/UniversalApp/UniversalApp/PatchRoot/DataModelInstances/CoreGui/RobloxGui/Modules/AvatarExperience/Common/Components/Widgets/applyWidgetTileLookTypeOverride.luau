local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local function applyWidgetTileLookTypeOverride(p1, p2) -- line: 19
	-- upvalues: Cryo (copy)
	if p2 == nil then
		return p1
	end

	if p1 ~= nil and p2 == p1.lookType then
		return p1
	end

	return (Cryo.Dictionary.join(p1 or {}, {
		lookType = p2
	}))
end

return applyWidgetTileLookTypeOverride
