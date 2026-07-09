local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)

require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)

local SetRemoteUprankedItems = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRemoteUprankedItems)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Utils = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Types)

local function fetchItems(t1: {[any]: any}) -- line: 49
	-- upvalues: WebApi (copy), SetRemoteUprankedItems (copy)
	return WebApi.GetRemoteUpranked(t1.networkImpl, t1.userId):andThen(function(p1) -- line: 57
		-- upvalues: t1 (copy), SetRemoteUprankedItems (copy)
		local responseBody = p1.responseBody
		local t2 = {
			networkImpl = t1.networkImpl,
			uprankedItems = responseBody.outfitDetails,
			store = t1.store,
			resolve = t1.resolve
		}
		local uprankedItems = t2.uprankedItems
		local resolve = t2.resolve
		local store = t2.store

		if not uprankedItems or #uprankedItems == 0 then
			resolve()

			return
		end

		store:dispatch(SetRemoteUprankedItems(uprankedItems))
		resolve()
	end):catch(function(p2) -- line: 66
		-- upvalues: t1 (copy)
		warn("GetRemoteUpranked failure: ", p2)

		return t1.reject(p2)
	end)
end

return function(p3) -- line: 72
	-- upvalues: Utils (copy), Promise (copy), fetchItems (copy)
	return function(p4) -- line: 73
		-- upvalues: Utils (copy), Promise (copy), fetchItems (copy), p3 (copy)
		local v23 = p4:getState()
		local v24 = Utils.getUserId(v23)

		return Promise.new(function(resolve, reject) -- line: 77
			-- upvalues: fetchItems (copy), p3 (copy), v24 (copy), p4 (copy)
			fetchItems({
				networkImpl = p3,
				userId = v24,
				store = p4,
				resolve = resolve,
				reject = reject
			})
		end)
	end
end
