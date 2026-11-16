local module = require("@luauforge/deferred/eeO")

local module2 = require("@luauforge/deferred/egD")

local userListHeader = require("@luauforge/deferred/egF").UserListHeader

local ampApiProvider = require("@luauforge/deferred/egs").AmpApiProvider
local accessResponseEnum = require("@luauforge/deferred/egs").AmpEnums.AccessResponseEnum

local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization

local module3 = require("@luauforge/deferred/efc")
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
