local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local DeveloperProductGetStatuses = require(Modules.LuaApp.Http.Requests.DeveloperProductApi.DeveloperProductGetStatuses)
local SetDeveloperProductStatuses = require(Modules.LuaApp.Actions.DeveloperProduct.SetDeveloperProductStatuses)

return function(p1, s1: string, s2: string, s3: string) -- line: 9
	-- upvalues: PerformFetch (copy), DeveloperProductGetStatuses (copy), SetDeveloperProductStatuses (copy), Promise (copy)
	return PerformFetch.Single("ApiFetchDeveloperProductsStatus" .. s1 .. s3, function(p2) -- line: 10
		-- upvalues: DeveloperProductGetStatuses (copy), p1 (copy), s1 (copy), s3 (copy), SetDeveloperProductStatuses (copy), s2 (copy), Promise (copy)
		return DeveloperProductGetStatuses(p1, s1, s3):andThen(function(p3) -- line: 11
			-- upvalues: p2 (copy), SetDeveloperProductStatuses (copy), s2 (copy)
			local t1 = {}

			if p3 and p3.responseBody then
				for _, v in ipairs(p3.responseBody) do
					if v.actionArgs and v.receipt then
						for _, v2 in ipairs(v.actionArgs) do
							if v2.Key == "productId" and v2.Value then
								if t1[v2.Value] == nil then
									t1[v2.Value] = {}
								end

								table.insert(t1[v2.Value], v.receipt)
							end
						end
					end
				end
			end

			return p2:dispatch(SetDeveloperProductStatuses(s2, t1))
		end, function(_) -- line: 28
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end
