require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")

local moments = {}

for k, v5 in require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentFixtures").buildMomentFeedItems(1, 10) do
	table.insert(moments, v5.moment)
end

return moments
