local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local GetVngShopUrl = require(Modules.LuaApp.Http.Requests.VngPayments.GetVngShopUrl)

require(CorePackages.Workspace.Packages.Http)

local GetFStringVNGWebshopUrl = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringVNGWebshopUrl

return function(p1) -- line: 14
	-- upvalues: GetVngShopUrl (copy), GetFStringVNGWebshopUrl (copy), Promise (copy)
	return function(_) -- line: 15
		-- upvalues: GetVngShopUrl (copy), p1 (copy), GetFStringVNGWebshopUrl (copy), Promise (copy)
		return GetVngShopUrl(p1):andThen(function(p3) -- line: 16
			-- upvalues: GetFStringVNGWebshopUrl (copy), Promise (copy)
			if p3 == nil or p3[1] == nil then
				local t1 = {
					vngShopRedirectUrl = GetFStringVNGWebshopUrl()
				}

				return Promise.resolve(t1)
			end

			local t2 = {
				vngShopRedirectUrl = p3[1].vngShopRedirectUrl
			}

			return Promise.resolve(t2)
		end):catch(function(_) -- line: 30
			-- upvalues: GetFStringVNGWebshopUrl (copy), Promise (copy)
			local t3 = {
				vngShopRedirectUrl = GetFStringVNGWebshopUrl()
			}

			return Promise.resolve(t3)
		end)
	end
end
