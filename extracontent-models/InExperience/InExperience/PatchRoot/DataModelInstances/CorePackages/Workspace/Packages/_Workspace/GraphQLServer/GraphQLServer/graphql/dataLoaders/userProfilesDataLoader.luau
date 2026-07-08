local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local DataLoader = require(Parent.DataLoader).DataLoader
local Cryo = require(Parent.Cryo)
local fetchProfilesByIds = require(script.Parent.Parent.connectors.UserProfileConnector).fetchProfilesByIds
local t1 = {}

t1.__index = t1

local v6 = game:DefineFastInt("UserProfilesDataLoaderClearTime_v1", 15)
local getFFlagRemoveDataLoaderTimer = require(Parent.SharedFlags).getFFlagRemoveDataLoaderTimer

function t1.new() -- line: 22
	-- upvalues: t1 (copy)
	local t2 = {
		loader = nil,
		lastTime = 0,
		fieldsSet = {},
		dataLoaderOptions = {
			batchSize = 50,
			batchDelay = 0
		}
	}

	setmetatable(t2, t1)

	return t2
end
function convertToSet(p1) -- line: 37
	local t3 = {}

	for _, v12 in p1 do
		t3[v12] = true
	end

	return t3
end
function t1.getFields(p2) -- line: 45
	local t4 = {}

	for v15, _ in p2.fieldsSet do
		table.insert(t4, v15)
	end

	return t4
end
function t1.makeDataLoader(t5: {[any]: any}, p3, t6: {[any]: any}, t7: {[any]: any}) -- line: 53
	-- upvalues: Cryo (copy), DataLoader (copy), fetchProfilesByIds (copy)
	t5.fieldsSet = Cryo.Dictionary.join(t5.fieldsSet, convertToSet(t6))

	local v21 = t7 or t5.dataLoaderOptions

	return DataLoader.new(function(p4) -- line: 56
		-- upvalues: fetchProfilesByIds (copy), t5 (copy), p3 (copy)
		return fetchProfilesByIds(p4, t5:getFields(), p3)
	end, {
		cache = true,
		maxBatchSize = v21.batchSize,
		batchScheduleFn = function(p5) -- line: 61
			-- upvalues: v21 (copy)
			task.delay(v21.batchDelay, p5)
		end
	})
end
function t1.getLoader(t8: {[any]: any}, p6, t9: {[any]: any}, t10: {[any]: any}) -- line: 68
	-- upvalues: Cryo (copy), getFFlagRemoveDataLoaderTimer (copy), v6 (copy)
	t8.fieldsSet = Cryo.Dictionary.join(t8.fieldsSet, convertToSet(t9))

	local elapsed = os.clock()
	local v27 = not getFFlagRemoveDataLoaderTimer() and elapsed - t8.lastTime > v6

	if not t8.loader or v27 then
		t8.lastTime = elapsed
		t8.loader = t8:makeDataLoader(p6, t9, t10)
	end

	return t8.loader
end

return t1
