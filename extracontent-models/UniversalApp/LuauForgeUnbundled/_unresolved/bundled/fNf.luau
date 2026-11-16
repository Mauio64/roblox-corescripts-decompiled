local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/fNg")

local module2 = require("@luauforge/bundled/fNi")
local module3 = require("@luauforge/bundled/dxL")

local module4 = require("@luauforge/bundled/fNj")

local module5 = require("@luauforge/bundled/fNk")

local module6 = require("@luauforge/bundled/fNm")
local module7 = require("@luauforge/bundled/fNn")

local fFlagRemoveUnusedSignUpInfoRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedSignUpInfoRoduxSlice

local v5 = math.max(0, module6())
local v6 = math.max(0, module7())

local v7 = {}

local array = t.array(t.optional(t.interface({
	bundleId = t.number,
	userOutfitId = t.number
})))

function v7._fetchSignUpBundles(p2)
	return module4(p2):andThen(function(p3)
		local bundles = p3 and p3.responseBody and p3.responseBody.bundles

		if array(bundles) then
			return Promise.resolve(bundles)
		end

		return Promise.resolve()
	end)
end

function v7._fetchSignUpBundlesWithRetry(p2)
	local function fetchSignUpBundles()
		return v7._fetchSignUpBundles(p2)
	end
	return v7._fetchSignUpBundles(p2):andThen(function(p3)
		return module({
			retryCount = v5,
			retryTimeMultiplier = v6,
			retryCallback = fetchSignUpBundles,
			previousResult = p3,
			isResolveConditionMet = function(p4): boolean
				return p4 ~= nil
			end
		})
	end)
end

function v7.Fetch(p2)
	return performFetch.Single("signUpBundles", function(object)
		return v7._fetchSignUpBundlesWithRetry(p2):andThen(function(list)
			local v8 = {}

			if not array(list) then
				return Promise.reject()
			end

			for i, item in ipairs(list) do
				table.insert(v8, module2.fromData(item))
			end

			if not fFlagRemoveUnusedSignUpInfoRoduxSlice then
				object:dispatch(module3(v8))
			end

			return Promise.resolve(v8)
		end):andThen(function(items)
			local userOutfitIds = {}

			for k, item in pairs(items) do
				table.insert(userOutfitIds, item.userOutfitId)
			end

			return object:dispatch(module5.Fetch(p2, userOutfitIds))
		end)
	end)
end

function v7.GetFetchingStatus(p2)
	return performFetch.GetStatus(p2, "signUpBundles")
end

return v7
