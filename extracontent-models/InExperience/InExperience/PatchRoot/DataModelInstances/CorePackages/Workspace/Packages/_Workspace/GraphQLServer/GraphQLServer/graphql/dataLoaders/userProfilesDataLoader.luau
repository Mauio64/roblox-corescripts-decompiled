local parent = script:FindFirstAncestor("GraphQLServer").Parent
local DataLoader = require(parent.DataLoader)
local dataLoader = DataLoader.DataLoader
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile

local UserProfileConnector = require(script.Parent.Parent.connectors.UserProfileConnector)
local fetchProfilesByIds = UserProfileConnector.fetchProfilesByIds

local UserProfilesDataLoader = {}
UserProfilesDataLoader.__index = UserProfilesDataLoader

local defineFastInt = game:DefineFastInt("UserProfilesDataLoaderClearTime_v1", 15)
local SharedFlags2 = require(parent.SharedFlags)
local getFFlagRemoveDataLoaderTimer = SharedFlags2.getFFlagRemoveDataLoaderTimer

function UserProfilesDataLoader.new()
	local v = {
		["loader"] = nil,
		lastTime = 0,
		fieldsSet = {},
		loadersByFields = {},
		dataLoaderOptions = { batchSize = 50, batchDelay = 0 }
	}

	setmetatable(v, UserProfilesDataLoader)
	return v
end

function convertToSet(items)
	local result = {}

	for _, item in items do
		result[item] = true
	end

	return result
end

function UserProfilesDataLoader:getFields()
	local fields = {}

	for k, _ in self.fieldsSet do
		table.insert(fields, k)
	end

	return fields
end

function UserProfilesDataLoader:makeDataLoader(p, p2, p3)
	self.fieldsSet = Cryo.Dictionary.join(self.fieldsSet, convertToSet(p2))
	local v = p3 or self.dataLoaderOptions
	return dataLoader.new(function(p4)
		local v2

		if FFlagUserProfilePlatformProfile then
			v2 = p2
		else
			v2 = self:getFields()
		end

		return fetchProfilesByIds(p4, v2, p)
	end, {
		cache = true,
		maxBatchSize = v.batchSize,
		batchScheduleFn = function(callback)
			task.delay(v.batchDelay, callback)
		end
	})
end

function UserProfilesDataLoader:getLoader(p, p2, p3)
	if FFlagUserProfilePlatformProfile then
		local clone = table.clone(p2)
		table.sort(clone)
		local joined = table.concat(clone, ",")
		local now = os.clock()
		local loadersByField = self.loadersByFields[joined]
		local loader

		if loadersByField then
			if getFFlagRemoveDataLoaderTimer() then
				return loadersByField.loader
			end

			if defineFastInt < now - loadersByField.lastTime then
				loader = self:makeDataLoader(p, clone, p3)
				self.loadersByFields[joined] = { loader = loader, lastTime = now }
				return loader
			end

			return loadersByField.loader
		end

		loader = self:makeDataLoader(p, clone, p3)
		self.loadersByFields[joined] = { loader = loader, lastTime = now }
		return loader
	else
		self.fieldsSet = Cryo.Dictionary.join(self.fieldsSet, convertToSet(p2))
		local now = os.clock()
		local v

		if getFFlagRemoveDataLoaderTimer() then
			v = false
		else
			v = defineFastInt < now - self.lastTime
		end

		if not self.loader or v then
			self.lastTime = now
			self.loader = self:makeDataLoader(p, p2, p3)
		end

		return self.loader
	end
end

return UserProfilesDataLoader
