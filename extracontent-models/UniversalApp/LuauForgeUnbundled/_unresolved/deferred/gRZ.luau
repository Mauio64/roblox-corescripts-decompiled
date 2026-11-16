local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
require("@luauforge/bundled/fuM")

local module = require("@luauforge/bundled/dPe")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/fwg")

require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")
local module3 = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/dMc")

local function fetchItems(data)
	return module2.GetRemoteUpranked(data.networkImpl, data.userId):andThen(function(p2)
		local responseBody = p2.responseBody
		local v5 = {
			networkImpl = data.networkImpl,
			uprankedItems = responseBody.outfitDetails,
			store = data.store,
			resolve = data.resolve
		}
		local uprankedItems = v5.uprankedItems
		local resolve = v5.resolve
		local store = v5.store

		if not uprankedItems or #uprankedItems == 0 then
			resolve()
			return
		end

		store:dispatch(module(uprankedItems))

		resolve()
	end):catch(function(p2)
		warn("GetRemoteUpranked failure: ", p2)
		return data.reject(p2)
	end)
end

return function(p2)
	return function(object)
		local state = object:getState()
		local userId = module3.getUserId(state)

		return Promise.new(function(p3, p4)
			fetchItems({
				networkImpl = p2,
				userId = userId,
				store = object,
				resolve = p3,
				reject = p4
			})
		end)
	end
end
