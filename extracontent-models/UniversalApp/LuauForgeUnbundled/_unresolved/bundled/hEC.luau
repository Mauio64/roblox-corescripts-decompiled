local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")
local module3 = require("@luauforge/bundled/edM")
local module4 = require("@luauforge/bundled/frt")

local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/cgr").Utils.getRbxthumbWithTypeSizeAndOptions
local constants = require("@luauforge/bundled/cgr").Utils.Constants

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagProfileFrameThumbnailEnabled = SharedFlags.GetFFlagProfileFrameThumbnailEnabled
local v5 = game:DefineFastFlag("GridHomeUserInfoUseProfileFrameThumbnail", false)
	and getFFlagProfileFrameThumbnailEnabled()
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module6 = require("@luauforge/bundled/hED")

local v6 = RoactRodux.connect(function(p2)
	local user = p2.Users[p2.LocalUserId]

	if not user then
		return {}
	end

	local v7 = if v5 then getRbxthumbWithTypeSizeAndOptions(
		p2.LocalUserId,
		constants.RbxthumbTypes.AvatarHeadShot,
		150,
		nil,
		nil,
		true
	) else getRbxthumbWithTypeSizeAndOptions(p2.LocalUserId, constants.RbxthumbTypes.AvatarHeadShot, 150)

	return {
		displayName = user.displayName or user.name,
		thumbnail = v7,
		isPremium = user.membership == Enum.MembershipType.Premium,
		isVerified = user.hasVerifiedBadge,
		isRobloxSubscriber = fFlagEnableBlackbirdCheck and user.hasRobloxSubscription == true and true or false,
		localUserId = p2.LocalUserId
	}
end, function(callback)
	return {
		openProfile = function()
			local v7 = {
				name = module.ViewProfile,
				detail = urlBuilder.static.profile()
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v7))
			else
				callback(module2(v7))
			end
		end,
		openLuaProfile = function(p2, p3)
			callback(module3(p2, p3))
		end
	}
end)(module6)

return (module4(function(p2, p3)
	if p3.isSearching then
		return nil
	end

	return Roact.createElement(p2, p3)
end)(v6))
