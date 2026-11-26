local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/ejY")

local userListHeader = require("@luauforge/deferred/eka").UserListHeader

local ampApiProvider = require("@luauforge/deferred/ejN").AmpApiProvider
local accessResponseEnum = require("@luauforge/deferred/ejN").AmpEnums.AccessResponseEnum

local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local module3 = require("@luauforge/deferred/eiz")
local fStringShowAddTrustedFriendsHeaderTextAmpFeature = module3.FStringShowAddTrustedFriendsHeaderTextAmpFeature
local fStringCanAccessTrustedContactsAmpNameSpace = module3.FStringCanAccessTrustedContactsAmpNameSpace
local fFlagAddFriendsUserListEnabled = module3.FFlagAddFriendsUserListEnabled

local function ConnectionChannelsHeader(p2)
	local layoutOrder = p2.layoutOrder or 1

	local state, setState = module.useState(false)
	module.useEffect(function()
		if ampApiProvider.upsellFeatureAccess(
			fStringShowAddTrustedFriendsHeaderTextAmpFeature,
			{},
			fStringCanAccessTrustedContactsAmpNameSpace
		).access == accessResponseEnum.Granted then
			setState(true)
		end
	end, {})

	local v6 = useLocalization({
		title = "Feature.Friends.TrustedFriend.Label.AddTrustedFriendsAltCapitalization"
	})

	if not state then
		return nil
	end

	if fFlagAddFriendsUserListEnabled then
		return module.createElement(userListHeader, {
			title = v6.title,
			layoutOrder = layoutOrder
		})
	end

	return module.createElement(module2, { title = v6.title, layoutOrder = layoutOrder })
end

return ConnectionChannelsHeader
