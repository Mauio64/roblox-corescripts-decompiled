local module = require("@luauforge/deferred/eil")

local useSignalProfileInsightsByUserId = require("@luauforge/deferred/elJ").useSignalProfileInsightsByUserId
local useGetPresenceByUserId = require("@luauforge/deferred/elK").Hooks.useGetPresenceByUserId

local module2 = require("@luauforge/deferred/elL")

local module3 = require("@luauforge/deferred/ema")

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@luauforge/deferred/eiz").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local module4 = require("@luauforge/deferred/elR")
local contextInfoType = module4.ContextInfoType
local ctaAction = module4.CtaAction

local v5 = { forceFetch = true }

local function TrustedFriendRequestRow(props)
	local entity = props.entity

	local v6, v7 = useSignalProfileInsightsByUserId({
		userId = entity.id,
		rankingStrategy = "tc_info_boost",
		skipFetch = false
	})

	local mutualFriends = v6 and v6.mutualFriends
	local v8 = mutualFriends and #mutualFriends or 0

	local v9 = if module3 then useGetPresenceByUserId(entity.id, v5) else nil

	local v10 = module.useMemo(function()
		if v7 then
			return { type = contextInfoType.Loading }
		end

		if v8 > 0 then
			return { type = contextInfoType.MutualFriends, mutualFriendsCount = v8 }
		end

		return nil
	end, { v7, v8 })

	local v11 = module.useMemo(function()
		return {
			{ actionEnum = ctaAction.IgnoreTrustedFriendRequest },
			{ actionEnum = ctaAction.AcceptTrustedFriendRequest }
		}
	end, {})

	local createElement = module.createElement
	local v13 = {
		isTrustedFriendRequest = true,
		user = entity,
		createRow = props.createRow,
		position = props.position,
		selected = props.selected,
		impressionsTag = props.impressionsTag,
		isContact = false,
		friendStatus = nil,
		presence = v9,
		isUnseen = 0,
		contextInfo = 0,
		ctaActions = 0
	}

	local v14 = if fFlagAddFriendsPageHighlightUnseenTrustedRequests then entity.isUnseen else nil
	v13.isUnseen = v14
	v13.contextInfo = v10
	v13.ctaActions = v11
	return createElement(module2, v13)
end

return TrustedFriendRequestRow
