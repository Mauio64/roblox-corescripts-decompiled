local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)
local MomentFixtures = require(script.Parent.MomentFixtures)

local MockTrendingMoments = {}

for _, v in MomentFixtures.buildMomentFeedItems(1, 10) do
	table.insert(MockTrendingMoments, v.moment)
end

return MockTrendingMoments
