local module = require("@luauforge/bundled/efJ")
local module2 = require("@luauforge/bundled/efK")
local Rodux = require("@game/CorePackages/Workspace/Packages/Rodux")

local constants = require("@luauforge/bundled/efm").Constants

local module4 = require("@luauforge/bundled/efG")

local friendRequestCreated = require("@luauforge/bundled/efx").Actions.FriendRequestCreated

local module5 = require("@luauforge/bundled/efL")

local function fn(p2, ids)
	return {
		seenContactImporterFriendRequest = p2.seenContactImporterFriendRequest,
		contactImporterFriendRequests = module2.Dictionary.filter(
			p2.contactImporterFriendRequests,
			function(p3, p4): boolean
				return not module.includes(ids, p4)
			end
		)
	}
end

return Rodux.createReducer(
	{ contactImporterFriendRequests = {}, seenContactImporterFriendRequest = false },
	{
		[module4.AcceptFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			return fn(p2, p3.ids)
		end,
		[module4.DeclineFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			return fn(p2, p3.ids)
		end,
		[friendRequestCreated.name] = function(p2, p3)
			local id = p3.id

			if p3.originSourceType ~= constants.PHONE_CONTACT_IMPORTER then
				return p2
			end

			return module2.Dictionary.join(p2, {
				contactImporterFriendRequests = module2.Dictionary.join(p2.contactImporterFriendRequests, {
					[tostring(id)] = true
				})
			})
		end,
		[module4.GetFriendRequests.Succeeded.name] = function(p2, p3)
			local data = p3.responseBody.data

			local idSet = {}

			for k, v6 in pairs(data) do
				if v6.friendRequest.originSourceType == constants.PHONE_CONTACT_IMPORTER then
					idSet[tostring(v6.id)] = true
				end
			end

			return module2.Dictionary.join(p2, {
				contactImporterFriendRequests = module2.Dictionary.join(
					p2.contactImporterFriendRequests,
					idSet
				)
			})
		end,
		[module5.name] = function(p2, p3)
			if module2.isEmpty(p2.contactImporterFriendRequests) then
				return p2
			end

			return module2.Dictionary.join(p2, {
				seenContactImporterFriendRequest = true
			})
		end
	}
)
