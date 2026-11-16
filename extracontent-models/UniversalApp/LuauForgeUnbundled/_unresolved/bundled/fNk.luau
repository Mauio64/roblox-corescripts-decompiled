local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/ecV")
local promiseUtilities = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.PromiseUtilities
local module2 = require("@luauforge/bundled/fNg")
local module3 = require("@luauforge/bundled/fwg")

local module4 = require("@luauforge/bundled/fNl")

local module5 = require("@luauforge/bundled/fNm")
local module6 = require("@luauforge/bundled/fNn")

local v5 = math.max(0, module5())
local v6 = math.max(0, module6())

local module7 = require("@luauforge/bundled/dxS")

local fFlagRemoveUnusedSignUpInfoRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedSignUpInfoRoduxSlice

return {
	Fetch = function(p2, p3)
		return function(object)
			local joined = Cryo.List.join(p3)

			local function fetchOutfitDetails()
				local v7 = {}

				for k, v8 in pairs(joined) do
					v7[v8] = module3.GetOutfit(p2, v8)
				end

				return promiseUtilities.Batch(v7):andThen(function(items)
					local v8 = {}
					local v9 = {}

					for k, item in pairs(items) do
						local unwrapped, v10 = item:unwrap()
						local responseBody = v10 and v10.responseBody

						if unwrapped and responseBody then
							v8[tostring(k)] = module4.fromOutfitDetailsWebApi(responseBody)
						else
							table.insert(v9, k)
						end
					end

					if not fFlagRemoveUnusedSignUpInfoRoduxSlice then
						object:dispatch(module7(v8))
					end

					return module.resolve(v9)
				end)
			end

			return fetchOutfitDetails():andThen(function(p4)
				return module2({
					retryCount = v5,
					retryTimeMultiplier = v6,
					retryCallback = fetchOutfitDetails,
					previousResult = p4,
					isResolveConditionMet = function(list): boolean
						if #list == 0 then
							return true
						end

						joined = Cryo.List.join(list)
						return false
					end
				})
			end)
		end
	end
}
