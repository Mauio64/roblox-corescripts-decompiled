local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)
local Actions = ParentParent.Actions
local AliasUpdated = require(Actions.AliasUpdated)
local AliasRemoved = require(Actions.AliasRemoved)
local ReceivedCanShowUserAlias = require(Actions.ReceivedCanShowUserAlias)

require(ParentParent.RoduxAliasesTypes)

local function addUserIdsToState(p1, p2) -- line: 17
	-- upvalues: llama (copy)
	return llama.Dictionary.join(p1, p2)
end
local function addUsersIdsToInternalState(p3, p4) -- line: 21
	-- upvalues: llama (copy)
	local _INTERNAL_HIDDEN_DATA = p3._INTERNAL_HIDDEN_DATA
	local v17 = llama.Dictionary.join(_INTERNAL_HIDDEN_DATA, p4)

	return llama.Dictionary.join(p3, {
		_INTERNAL_HIDDEN_DATA = v17
	})
end

local t1 = {
	ShowUserAlias = true
}

return function(p5) -- line: 33
	-- upvalues: Rodux (copy), t1 (copy), AliasUpdated (copy), addUserIdsToState (copy), addUsersIdsToInternalState (copy), AliasRemoved (copy), llama (copy), ReceivedCanShowUserAlias (copy)
	local aliasNetworking = p5.aliasNetworking

	return Rodux.createReducer(t1, {
		[AliasUpdated.name] = function(p6, p7) -- line: 37
			-- upvalues: addUserIdsToState (copy), addUsersIdsToInternalState (copy)
			assert(type(p7.payload.userId) == "string", "Expected userId to be a string")
			assert(type(p7.payload.newAlias) == "string", "Expected newAlias to be a string")

			local t2 = {
				[p7.payload.userId] = p7.payload.newAlias
			}

			if p6.ShowUserAlias or p6.ShowUserAlias == nil then
				return addUserIdsToState(p6, t2)
			end

			return addUsersIdsToInternalState(p6, t2)
		end,
		[AliasRemoved.name] = function(p8, p9) -- line: 51
			-- upvalues: llama (copy), addUserIdsToState (copy), addUsersIdsToInternalState (copy)
			assert(type(p9.payload.userId) == "string", "Expected userId to be a string")

			local t3 = {
				[p9.payload.userId] = llama.None
			}

			if p8.ShowUserAlias or p8.ShowUserAlias == nil then
				return addUserIdsToState(p8, t3)
			end

			return addUsersIdsToInternalState(p8, t3)
		end,
		[ReceivedCanShowUserAlias.name] = function(p10, p11) -- line: 64
			-- upvalues: llama (copy)
			assert(type(p11.payload.showUserAlias) == "boolean", "Expected showUserAlias to be a boolean")

			if p11.payload.showUserAlias == p10.ShowUserAlias then
				return p10
			end

			if p11.payload.showUserAlias then
				return llama.Dictionary.join(p10._INTERNAL_HIDDEN_DATA or {}, {
					ShowUserAlias = p11.payload.showUserAlias,
					_INTERNAL_HIDDEN_DATA = llama.None
				})
			end

			return {
				ShowUserAlias = p11.payload.showUserAlias,
				_INTERNAL_HIDDEN_DATA = llama.Dictionary.join(p10, {
					ShowUserAlias = llama.None,
					_INTERNAL_HIDDEN_DATA = llama.None
				})
			}
		end,
		[aliasNetworking.GetTagsFromUserIds.Succeeded.name] = function(p12, p13) -- line: 88
			-- upvalues: addUserIdsToState (copy), addUsersIdsToInternalState (copy)
			local t4 = {}

			for _, v in ipairs(p13.responseBody) do
				t4[tostring(v.targetUserId)] = v.targetUserTag
			end

			if p12.ShowUserAlias or p12.ShowUserAlias == nil then
				return addUserIdsToState(p12, t4)
			end

			return addUsersIdsToInternalState(p12, t4)
		end,
		[aliasNetworking.SetUserTag.Succeeded.name] = function(p14, p15) -- line: 102
			-- upvalues: llama (copy)
			local userTag = p15.postBody.userTag
			local targetUserId = p15.postBody.targetUserId

			return llama.Dictionary.join(p14, {
				[tostring(targetUserId)] = userTag
			})
		end
	})
end
