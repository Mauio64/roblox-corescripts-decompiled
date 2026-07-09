local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.MomentsTypes)

local t1 = {}

for _, v4 in require(script.Parent.MomentFixtures).buildMomentFeedItems(1, 10) do
	table.insert(t1, v4.moment)
end

return t1
