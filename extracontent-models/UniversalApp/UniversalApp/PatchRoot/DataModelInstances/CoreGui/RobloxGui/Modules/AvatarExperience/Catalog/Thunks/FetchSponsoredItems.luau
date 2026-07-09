local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Dash = require(CorePackages.Packages.Dash)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local SetAssetInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromSortResults)
local SetBundleInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromSortResults)
local SetSponsoredItems = require(Modules.AvatarExperience.Catalog.Actions.SetSponsoredItems)
local sendAXStat = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXStat
local Constants2 = require(Modules.AvatarExperience.Common.Constants)

return function(p1, p2, n1: number?) -- line: 25
	-- upvalues: CatalogUtils (copy), PerformFetch (copy), WebApi (copy), SetSponsoredItems (copy), Dash (copy), Constants (copy), SetAssetInfoFromSortResults (copy), SetBundleInfoFromSortResults (copy), sendAXStat (copy), Constants2 (copy), Promise (copy)
	local v17 = CatalogUtils.GetSponsoredItemsKey(p2, n1)
	local elapsed = os.clock()

	return PerformFetch.Single(v17, function(p3) -- line: 28
		-- upvalues: WebApi (copy), p1 (copy), p2 (copy), n1 (copy), SetSponsoredItems (copy), Dash (copy), Constants (copy), SetAssetInfoFromSortResults (copy), SetBundleInfoFromSortResults (copy), elapsed (copy), sendAXStat (copy), Constants2 (copy), Promise (copy)
		return WebApi.FetchSponsoredItems(p1, p2, n1):andThen(function(p4) -- line: 30
			-- upvalues: p3 (copy), SetSponsoredItems (copy), p2 (copy), Dash (copy), WebApi (copy), p1 (copy)
			local v21 = p4.responseBody.data or {}

			p3:dispatch(SetSponsoredItems(p2, v21))

			local v22 = Dash.map(v21, function(p5) -- line: 39
				return {
					id = p5.id,
					itemType = p5.itemType
				}
			end)

			return (WebApi.FetchItemDetails(p1, v22))
		end):andThen(function(p6) -- line: 47
			-- upvalues: Constants (copy), p3 (copy), SetAssetInfoFromSortResults (copy), SetBundleInfoFromSortResults (copy), elapsed (copy), sendAXStat (copy), Constants2 (copy), Promise (copy)
			local responseBody = p6.responseBody

			responseBody.data = responseBody.data or {}

			local t1 = {}
			local t2 = {}

			for _, v28 in responseBody.data do
				if v28.itemType == Constants.ItemType.Asset then
					table.insert(t1, v28)
				elseif v28.itemType == Constants.ItemType.Bundle then
					table.insert(t2, v28)
				end
			end

			if #t1 > 0 then
				p3:dispatch(SetAssetInfoFromSortResults(t1))
			end

			if #t2 > 0 then
				p3:dispatch(SetBundleInfoFromSortResults(t2))
			end

			local v29 = (os.clock() - elapsed) * 1000

			sendAXStat({
				statName = Constants2.Counter.Latency.Network.FetchSponsoredItems,
				deltaMs = v29
			})

			return Promise.resolve()
		end)
	end)
end
