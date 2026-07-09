local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local SetNetworkingErrorToast = require(CorePackages.Workspace.Packages.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local PreloadUsersThumbnail = require(CorePackages.Workspace.Packages.UserLib).Thunks.PreloadUsersThumbnail
local AvatarThumbnailRequests = require(CorePackages.Workspace.Packages.UserLib).Utils.AvatarThumbnailRequests
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local OmniFeedProps = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedProps
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HomeUserInfoWidget = require(Modules.LuaApp.Components.Home.HomeUserInfoWidget)
local FFlagLuaAppCompositionAlways = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppCompositionAlways
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING
local v20 = Roact.PureComponent:extend("UserInfoFeedItem")

v20.validateProps = t.strictInterface({
	[OmniFeedProps.key] = OmniFeedProps.interface,
	formFactor = t.string,
	localUserModel = t.optional(t.table),
	refresh = t.callback,
	networking = t.any
})

function v20.init(p1) -- line: 45
	-- upvalues: OmniFeedProps (copy)
	p1.isMounted = false
	p1.refreshSignalConnection = p1.props[OmniFeedProps.key].refreshSignal:connect(function() -- line: 48
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1.props.refresh(p1.props.networking, p1.props.localUserModel)
		end
	end)
end
function v20.didMount(p2) -- line: 55
	p2.isMounted = true
end
function v20.render(p3) -- line: 59
	-- upvalues: FFlagLuaAppCompositionAlways (copy), OmniFeedProps (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), Roact (copy), HomeUserInfoWidget (copy)
	local formFactor = p3.props.formFactor
	local v27 = if not (not not FFlagLuaAppCompositionAlways or p3.props[OmniFeedProps.key].appCompositionEnabled) then if formFactor ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING else 0

	return Roact.createElement(HomeUserInfoWidget, {
		sideMargin = v27
	})
end
function v20.willUnmount(p4) -- line: 80
	p4.isMounted = false

	if p4.refreshSignalConnection then
		p4.refreshSignalConnection:disconnect()
		p4.refreshSignalConnection = nil
	end
end

local v21 = memoize(function(p5, p6) -- line: 89
	return p5[p6]
end)
local v22 = RoactRodux.connect(function(p7, _) -- line: 113
	-- upvalues: v21 (copy)
	return {
		formFactor = p7.FormFactor,
		localUserModel = v21(p7.Users, p7.LocalUserId)
	}
end, function(p9) -- line: 93
	-- upvalues: PreloadUsersThumbnail (copy), AvatarThumbnailRequests (copy), Promise (copy), SetNetworkingErrorToast (copy)
	return {
		refresh = function(_, p11) -- line: 94
			-- upvalues: p9 (copy), PreloadUsersThumbnail (copy), AvatarThumbnailRequests (copy), Promise (copy), SetNetworkingErrorToast (copy)
			local t1 = { (p9(PreloadUsersThumbnail({ p11.id }, AvatarThumbnailRequests.HOME_HEADER_USER, nil))) }

			return Promise.all(t1):andThen(function(p12) -- line: 101
				-- upvalues: Promise (copy)
				return Promise.resolve(p12)
			end, function(p13) -- line: 103
				-- upvalues: p9 (copy), SetNetworkingErrorToast (copy), Promise (copy)
				p9((SetNetworkingErrorToast(p13)))

				return Promise.reject(p13)
			end)
		end
	}
end)(v20)

return (RoactServices.connect({
	networking = RoactNetworking
})(v22))
