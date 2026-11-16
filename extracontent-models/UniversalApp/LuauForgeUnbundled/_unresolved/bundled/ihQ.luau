local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)

local setNetworkingErrorToast = require("@luauforge/bundled/ecX").Thunks.SetNetworkingErrorToast
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local preloadUsersThumbnail = require("@luauforge/bundled/cgr").Thunks.PreloadUsersThumbnail
local avatarThumbnailRequests = require("@luauforge/bundled/cgr").Utils.AvatarThumbnailRequests
local module = require("@luauforge/bundled/cyO")

local omniFeedProps = require("@luauforge/bundled/dpZ").Modules.Personalization.OmniFeed.OmniFeedProps

local module2 = require("@luauforge/bundled/ftd")

local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCompositionAlways

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local extended = Roact.PureComponent:extend("UserInfoFeedItem")

extended.validateProps = t.strictInterface({
	[omniFeedProps.key] = omniFeedProps.interface,
	formFactor = t.string,
	localUserModel = t.optional(t.table),
	refresh = t.callback,
	networking = t.any
})

function extended:init()
	self.isMounted = false

	self.refreshSignalConnection = self.props[omniFeedProps.key].refreshSignal:connect(function()
		if self.isMounted then
			self.props.refresh(self.props.networking, self.props.localUserModel)
		end
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended.render(p2)
	local formFactor2 = p2.props.formFactor
	local v5

	if fFlagLuaAppCompositionAlways or p2.props[omniFeedProps.key].appCompositionEnabled then
		v5 = 0
	elseif formFactor2 == formFactor.COMPACT then
		v5 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
	else
		v5 = GAME_CAROUSEL_SIDE_WIDE_PADDING
	end

	return Roact.createElement(module2, { sideMargin = v5 })
end

function extended:willUnmount()
	self.isMounted = false

	if self.refreshSignalConnection then
		self.refreshSignalConnection:disconnect()
		self.refreshSignalConnection = nil
	end
end

local v5 = memoize(function(p2, p3)
	return p2[p3]
end)

local v6 = RoactRodux.connect(function(data, p2)
	return {
		formFactor = data.FormFactor,
		localUserModel = v5(data.Users, data.LocalUserId)
	}
end, function(callback)
	return {
		refresh = function(p2, p3)
			local v7 = { (callback(preloadUsersThumbnail(
					{ p3.id },
					avatarThumbnailRequests.HOME_HEADER_USER,
					nil
				))) }

			return Promise.all(v7):andThen(function(p4)
				return Promise.resolve(p4)
			end, function(p4)
				callback(setNetworkingErrorToast(p4))
				return Promise.reject(p4)
			end)
		end
	}
end)(extended)

return (roactServices.connect({ networking = roactNetworking })(v6))
