local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local Dash = require(AddFriendsStateParent.Dash)
local llama = require(AddFriendsStateParent.llama)
local Rodux = require(AddFriendsStateParent.Rodux)
local Constants = require(AddFriendsStateParent.ContactImporter).Constants
local FriendsNetworking = require(AddFriendsState.Networking.FriendsNetworking)
local FriendRequestCreated = require(AddFriendsState.RoduxFriends).Actions.FriendRequestCreated
local ContactImporterWarningSeen = require(AddFriendsState.Actions.ContactImporterWarningSeen)
local t1 = {
	seenContactImporterFriendRequest = false,
	contactImporterFriendRequests = {}
}

local function v11(t2: {[any]: any}, t3: {[any]: any}) -- line: 28
	-- upvalues: llama (copy), Dash (copy)
	return {
		seenContactImporterFriendRequest = t2.seenContactImporterFriendRequest,
		contactImporterFriendRequests = llama.Dictionary.filter(t2.contactImporterFriendRequests, function(_, p2) -- line: 31
			-- upvalues: Dash (copy), t3 (copy)
			return not Dash.includes(t3, p2)
		end)
	}
end

return Rodux.createReducer(t1, {
	[FriendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 38
		-- upvalues: v11 (copy)
		return (v11(t4, t5.ids))
	end,
	[FriendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(t6: {[any]: any}, t7: {[any]: any}) -- line: 44
		-- upvalues: v11 (copy)
		return (v11(t6, t7.ids))
	end,
	[FriendRequestCreated.name] = function(t8: {[any]: any}, p3) -- line: 50
		-- upvalues: Constants (copy), llama (copy)
		local id = p3.id

		if p3.originSourceType == Constants.PHONE_CONTACT_IMPORTER then
			return llama.Dictionary.join(t8, {
				contactImporterFriendRequests = llama.Dictionary.join(t8.contactImporterFriendRequests, {
					[tostring(id)] = true
				})
			})
		end

		return t8
	end,
	[FriendsNetworking.GetFriendRequests.Succeeded.name] = function(t9: {[any]: any}, p4) -- line: 64
		-- upvalues: Constants (copy), llama (copy)
		local data = p4.responseBody.data
		local t10 = {}

		for _, v in pairs(data) do
			if v.friendRequest.originSourceType == Constants.PHONE_CONTACT_IMPORTER then
				t10[tostring(v.id)] = true
			end
		end

		return llama.Dictionary.join(t9, {
			contactImporterFriendRequests = llama.Dictionary.join(t9.contactImporterFriendRequests, t10)
		})
	end,
	[ContactImporterWarningSeen.name] = function(t11: {[any]: any}, _) -- line: 80
		-- upvalues: llama (copy)
		if not llama.isEmpty(t11.contactImporterFriendRequests) then
			return llama.Dictionary.join(t11, {
				seenContactImporterFriendRequest = true
			})
		end

		return t11
	end
})
