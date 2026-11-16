local createFaeFeatureAccessStore = require(script.createFaeFeatureAccessStore)
local useFaeFeatureAccess = require(script.useFaeFeatureAccess)

local faeFeatureAccessStore = createFaeFeatureAccessStore()
local GetFaeFeatureAccessStore = {}

function GetFaeFeatureAccessStore.getFaeFeatureAccessStore()
	return faeFeatureAccessStore
end

function GetFaeFeatureAccessStore.useFaeFeatureAccess()
	return useFaeFeatureAccess(faeFeatureAccessStore)
end

return GetFaeFeatureAccessStore
