local DataHydration = script:FindFirstAncestor("DataHydration")
local Profile = DataHydration.Profile
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local UrlBuilder = require(DataHydrationParent.UrlBuilder).UrlBuilder
local myHttpRequest = require(Profile.Networking.myHttpRequest)
local v7 = UrlBuilder.new({
	path = "profile-platform-api/v1/profiles/batch/get",
	base = Url.APIS_URL
})()

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: myHttpRequest (copy), v7 (copy)
	local t2 = {
		profileType = "User",
		excludeContextualActions = true,
		profileIds = t1,
		components = {{
			component = "Actions"
		}}
	}

	return myHttpRequest(v7, "POST", {
		postBody = t2
	}):catch(function(p1) -- line: 26
		error(p1)
	end)
end
