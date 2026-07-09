local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FIntAXCarouselWidgetMaxItems = require(Modules.AvatarExperience.Flags.FIntAXCarouselWidgetMaxItems)
local GetFFlagAXDisableWidgetHydrationCacheForLooks = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableWidgetHydrationCacheForLooks)
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function getContentToHyderate(p1, p2, n1: number?) -- line: 11
	-- upvalues: Cryo (copy), FIntAXCarouselWidgetMaxItems (copy), GetFFlagAXDisableWidgetHydrationCacheForLooks (copy), Constants (copy)
	local t1 = {}

	if p1 and (p1.content and not Cryo.isEmpty(p1.content)) then
		for i = 1, n1 or math.min(#p1.content, FIntAXCarouselWidgetMaxItems) do
			local v13 = p1.content[i]

			if v13 and (GetFFlagAXDisableWidgetHydrationCacheForLooks() and v13.type == Constants.ItemType.Look or not p2[v13.type] or not p2[v13.type][tostring(v13.id)]) then
				table.insert(t1, v13)
			end
		end
	end

	return t1
end

return getContentToHyderate
