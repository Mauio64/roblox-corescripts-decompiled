local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local function applyWidgetTileLookTypeOverride(options, p2)
	if p2 == nil then
		return options
	end

	if options == nil or options.lookType ~= p2 then
		return Cryo.Dictionary.join(options or {}, { lookType = p2 })
	end

	return options
end

return applyWidgetTileLookTypeOverride
