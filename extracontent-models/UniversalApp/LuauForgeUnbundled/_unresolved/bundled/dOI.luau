local module = require("@luauforge/bundled/dOJ")
local module2 = require("@luauforge/bundled/dOK")

local headShape = require("@luauforge/bundled/dLc").Enums.HeadShape
local module3 = require("@luauforge/bundled/dOE")
local module4 = require("@luauforge/bundled/dLd")
local module5 = require("@luauforge/bundled/dOL")

local module6 = require("@luauforge/bundled/dOM")

local function fetchHelper(p2)
	local networkImpl = p2.networkImpl
	local userId = p2.userId
	local v5 = ""
	local v6 = {}

	while v5 ~= nil do
		local v7, v8 = module6(networkImpl, userId, v5):await()

		if not v7 then
			return module.reject(v8)
		end

		local responseBody = v8.responseBody

		for k, v9 in responseBody.data or {} do
			table.insert(v6, v9)
		end

		v5 = responseBody.nextPageCursor
	end

	return module.resolve({
		responseBody = { data = v6 }
	})
end

return function(p2, p3, callback)
	return module2.PerformFetch.Single("HeadRefinement_UserOwnedClassicHead_Request", function(object)
		if callback then
			callback(module5.OwnedClassicHeadsRequest.Start)
		end

		local v5, v6 = fetchHelper({ networkImpl = p2, userId = p3 }):await()

		if v5 then
			local responseBody = v6.responseBody or { data = {} }
			local names = { headShape.Default }

			for k, v7 in responseBody.data do
				local v8 = module3[tostring(v7.assetId)]

				if v8 then
					table.insert(names, v8.name)
				end
			end

			if callback then
				callback(module5.OwnedClassicHeadsRequest.Success, {
					headShapeCount = tostring(#names)
				})
			end

			object:dispatch(module4(names))

			return module.resolve(names)
		end

		if callback then
			callback(module5.OwnedClassicHeadsRequest.Failure)
		end

		object:dispatch(module4({ headShape.Default }))
		return module.reject(v6)
	end)
end
