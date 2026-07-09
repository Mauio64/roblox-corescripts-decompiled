local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Actions = Modules.LuaApp.Actions
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GameGetDeveloperProducts = require(Modules.LuaApp.Http.Requests.DeveloperProductApi.GameGetDeveloperProducts)
local GameGetExperienceStoreDeveloperProducts = require(Modules.LuaApp.Http.Requests.DeveloperProductApi.GameGetExperienceStoreDeveloperProducts)
local SetGameDeveloperProducts = require(Actions.DeveloperProduct.SetGameDeveloperProducts)
local ApiFetchDeveloperProductsThumbnails = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchDeveloperProductsThumbnails)
local ApiFetchDeveloperProductsStatus = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchDeveloperProductsStatus)
local GetFIntExperienceStoreApiPageCount = require(Modules.LuaApp.Flags.GetFIntExperienceStoreApiPageCount)
local FFlagUseExperienceStoreApiForEdp = require(Modules.LuaApp.Flags.FFlagUseExperienceStoreApiForEdp)

require(Modules.LuaApp.Models.DeveloperProductApi.StorePageTypes)

local sortDeveloperProductsComparator = require(Modules.LuaApp.Thunks.DeveloperProduct.util.sortDeveloperProductsComparator)

return function(p1, p2, p3, p4) -- line: 23
	-- upvalues: PerformFetch (copy), FFlagUseExperienceStoreApiForEdp (copy), GetFIntExperienceStoreApiPageCount (copy), Promise (copy), GameGetExperienceStoreDeveloperProducts (copy), Cryo (copy), GameGetDeveloperProducts (copy), sortDeveloperProductsComparator (copy), SetGameDeveloperProducts (copy), ApiFetchDeveloperProductsThumbnails (copy), ApiFetchDeveloperProductsStatus (copy)
	return PerformFetch.Single("ApiFetchGameDeveloperProducts" .. tostring(p2) .. p4, function(p5) -- line: 24
		-- upvalues: FFlagUseExperienceStoreApiForEdp (copy), GetFIntExperienceStoreApiPageCount (copy), Promise (copy), GameGetExperienceStoreDeveloperProducts (copy), p1 (copy), p2 (copy), Cryo (copy), GameGetDeveloperProducts (copy), sortDeveloperProductsComparator (copy), SetGameDeveloperProducts (copy), ApiFetchDeveloperProductsThumbnails (copy), ApiFetchDeveloperProductsStatus (copy), p4 (copy), p3 (copy)
		local v25

		if FFlagUseExperienceStoreApiForEdp then
			local v20 = GetFIntExperienceStoreApiPageCount()
			local s1 = ""
			local t1 = {}

			local function createProductsFromResponseData(p6) -- line: 32
				local t2 = {}

				if p6.developerProducts then
					for _, v29 in p6.developerProducts do
						table.insert(t2, {
							iconImageAssetId = v29.IconImageAssetId,
							id = v29.DeveloperProductId,
							name = v29.Name,
							priceInRobux = v29.PriceInRobux,
							productId = v29.ProductId
						})
					end
				end

				return t2
			end
			local function fetchPage(p7) -- line: 51
				-- upvalues: v20 (copy), Promise (copy), t1 (ref), GameGetExperienceStoreDeveloperProducts (copy), p1 (copy), p2 (copy), s1 (ref), createProductsFromResponseData (copy), Cryo (copy), fetchPage (copy)
				if p7 > v20 then
					return Promise.resolve({
						responseBody = t1
					})
				end

				return GameGetExperienceStoreDeveloperProducts(p1, p2, s1):andThen(function(p8) -- line: 57
					-- upvalues: createProductsFromResponseData (copy), t1 (ref), Cryo (copy), s1 (ref), fetchPage (copy), p7 (copy), Promise (copy)
					local responseBody = p8.responseBody
					local v39 = createProductsFromResponseData(responseBody)

					t1 = Cryo.List.join(t1, v39)

					if responseBody.nextPageCursor and responseBody.nextPageCursor ~= "" then
						s1 = responseBody.nextPageCursor

						return fetchPage(p7 + 1)
					end

					return Promise.resolve({
						responseBody = t1
					})
				end):catch(function(_) -- line: 68
					-- upvalues: Promise (copy), t1 (ref)
					return Promise.resolve({
						responseBody = t1
					})
				end)
			end

			v25 = fetchPage(1)
		else
			v25 = GameGetDeveloperProducts(p1, p2)
		end

		return v25:andThen(function(t3: {[any]: any}) -- line: 78
			-- upvalues: FFlagUseExperienceStoreApiForEdp (copy), sortDeveloperProductsComparator (copy), p5 (copy), SetGameDeveloperProducts (copy), p2 (copy), ApiFetchDeveloperProductsThumbnails (copy), p1 (copy), ApiFetchDeveloperProductsStatus (copy), p4 (copy), p3 (copy), Promise (copy)
			local responseBody = t3.responseBody

			if FFlagUseExperienceStoreApiForEdp then
				table.sort(responseBody, sortDeveloperProductsComparator)
			end

			p5:dispatch(SetGameDeveloperProducts(p2, responseBody))

			if responseBody and type(responseBody) == "table" and #responseBody > 0 then
				local t4 = {}

				for _, v in ipairs(responseBody) do
					if v.iconImageAssetId then
						table.insert(t4, v.iconImageAssetId)
					end
				end

				p5:dispatch(ApiFetchDeveloperProductsThumbnails(p1, t4))
			end

			p5:dispatch(ApiFetchDeveloperProductsStatus(p1, p4, p2, p3))

			return Promise.resolve(t3)
		end, function(_) -- line: 100
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end
