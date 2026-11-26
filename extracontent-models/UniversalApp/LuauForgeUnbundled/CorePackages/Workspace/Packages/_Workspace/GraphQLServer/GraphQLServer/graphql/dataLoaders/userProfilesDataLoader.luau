local dataLoader = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/DataLoader").DataLoader
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Cryo")
local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").FFlagUserProfilePlatformProfile

local fetchProfilesByIds = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/connectors/UserProfileConnector").fetchProfilesByIds

local class = {}
class.__index = class

local defineFastInt = game:DefineFastInt("UserProfilesDataLoaderClearTime_v1", 15)
local getFFlagRemoveDataLoaderTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").getFFlagRemoveDataLoaderTimer

function class.new()
	local v5 = {
		["loader"] = nil,
		lastTime = 0,
		fieldsSet = {},
		loadersByFields = {},
		dataLoaderOptions = { batchSize = 50, batchDelay = 0 }
	}

	setmetatable(v5, class)
	return v5
end

function LUAUFORGE_MODULE_GLOBALS_cmJ_convertToSet(items)
	local result = {}

	for k, item in items do
		result[item] = true
	end

	return result
end

function class:getFields()
	local fields = {}

	for k, v5 in self.fieldsSet do
		table.insert(fields, k)
	end

	return fields
end

function class:makeDataLoader(p2, p3, p4)
	self.fieldsSet = Cryo.Dictionary.join(self.fieldsSet, LUAUFORGE_MODULE_GLOBALS_cmJ_convertToSet(p3))
	local v5 = p4 or self.dataLoaderOptions
	return dataLoader.new(function(p5)
		local v7 = if fFlagUserProfilePlatformProfile then p3 else self:getFields()
		return fetchProfilesByIds(p5, v7, p2)
	end, {
		cache = true,
		maxBatchSize = v5.batchSize,
		batchScheduleFn = function(callback)
			task.delay(v5.batchDelay, callback)
		end
	})
end

function class:getLoader(p2, p3, p4)
	if fFlagUserProfilePlatformProfile then
		local clone = table.clone(p3)
		table.sort(clone)
		local joined = table.concat(clone, ",")
		local now = os.clock()
		local loadersByField = self.loadersByFields[joined]
		local v5

		if loadersByField then
			if getFFlagRemoveDataLoaderTimer() then
				return loadersByField.loader
			end

			if defineFastInt < now - loadersByField.lastTime then
				v5 = self:makeDataLoader(p2, clone, p4)
				self.loadersByFields[joined] = { loader = v5, lastTime = now }
				return v5
			end

			return loadersByField.loader
		end

		v5 = self:makeDataLoader(p2, clone, p4)
		self.loadersByFields[joined] = { loader = v5, lastTime = now }
		return v5
	else
		self.fieldsSet = Cryo.Dictionary.join(
			self.fieldsSet,
			LUAUFORGE_MODULE_GLOBALS_cmJ_convertToSet(p3)
		)
		local now = os.clock()
		local v5 = not getFFlagRemoveDataLoaderTimer() and defineFastInt < now - self.lastTime

		if not self.loader or v5 then
			self.lastTime = now
			self.loader = self:makeDataLoader(p2, p3, p4)
		end

		return self.loader
	end
end

return class
