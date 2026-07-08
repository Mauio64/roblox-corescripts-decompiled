local getCacheStore = require(script.getCacheStore)
local CacheStoreTypes = require(script.CacheStoreTypes)

return {
	getCacheStore = getCacheStore,
	HomePageDataSourceType = CacheStoreTypes.HomePageDataSourceType
}
