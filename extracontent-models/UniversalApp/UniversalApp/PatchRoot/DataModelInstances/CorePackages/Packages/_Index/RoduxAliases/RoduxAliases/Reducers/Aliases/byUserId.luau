local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

local actions = parent.Actions
local AliasUpdated = require(actions.AliasUpdated)
local AliasRemoved = require(actions.AliasRemoved)
local ReceivedCanShowUserAlias = require(actions.ReceivedCanShowUserAlias)

require(parent.RoduxAliasesTypes)

local function addUserIdsToState(p, p2) -- 1 equivalent call inferred from this helper
	return llama.Dictionary.join(p, p2)
end

local function addUsersIdsToInternalState(p, p2)
	local v = addUserIdsToState(p._INTERNAL_HIDDEN_DATA, p2) -- inferred equivalent call

	return llama.Dictionary.join(p, { _INTERNAL_HIDDEN_DATA = v })
end

local v = { ShowUserAlias = true }

return function(p)
	local aliasNetworking = p.aliasNetworking

	return Rodux.createReducer(v, {
		[AliasUpdated.name] = function(p2, p3)
			assert(type(p3.payload.userId) == "string", "Expected userId to be a string")
			assert(type(p3.payload.newAlias) == "string", "Expected newAlias to be a string")

			local newAliasByUserId = {}
			newAliasByUserId[p3.payload.userId] = p3.payload.newAlias

			if p2.ShowUserAlias or p2.ShowUserAlias == nil then
				return addUserIdsToState(p2, newAliasByUserId)
			end

			return addUsersIdsToInternalState(p2, newAliasByUserId)
		end,
		[AliasRemoved.name] = function(p2, p3)
			assert(type(p3.payload.userId) == "string", "Expected userId to be a string")

			local nonesByUserId = {}
			nonesByUserId[p3.payload.userId] = llama.None

			if p2.ShowUserAlias or p2.ShowUserAlias == nil then
				return addUserIdsToState(p2, nonesByUserId)
			end

			return addUsersIdsToInternalState(p2, nonesByUserId)
		end,
		[ReceivedCanShowUserAlias.name] = function(p2, p3)
			assert(type(p3.payload.showUserAlias) == "boolean", "Expected showUserAlias to be a boolean")

			if p3.payload.showUserAlias == p2.ShowUserAlias then
				return p2
			end

			if p3.payload.showUserAlias then
				return llama.Dictionary.join(p2._INTERNAL_HIDDEN_DATA or {}, {
					["ShowUserAlias"] = p3.payload.showUserAlias,
					_INTERNAL_HIDDEN_DATA = llama.None
				})
			end

			return {
				["ShowUserAlias"] = p3.payload.showUserAlias,
				_INTERNAL_HIDDEN_DATA = llama.Dictionary.join(p2, {
					["ShowUserAlias"] = llama.None,
					_INTERNAL_HIDDEN_DATA = llama.None
				})
			}
		end,
		[aliasNetworking.GetTagsFromUserIds.Succeeded.name] = function(p2, p3)
			local targetUserTagsByTargetUserId = {}

			for _, v2 in ipairs(p3.responseBody) do
				targetUserTagsByTargetUserId[tostring(v2.targetUserId)] = v2.targetUserTag
			end

			if p2.ShowUserAlias or p2.ShowUserAlias == nil then
				return addUserIdsToState(p2, targetUserTagsByTargetUserId)
			end

			return addUsersIdsToInternalState(p2, targetUserTagsByTargetUserId)
		end,
		[aliasNetworking.SetUserTag.Succeeded.name] = function(p2, p3)
			local userTag = p3.postBody.userTag
			local targetUserId = p3.postBody.targetUserId

			return llama.Dictionary.join(p2, { [tostring(targetUserId)] = userTag })
		end
	})
end
