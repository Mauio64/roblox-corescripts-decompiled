local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Players = game:GetService("Players")

local Modules = CoreGui.RobloxGui.Modules
local ShareGame = Modules.Settings.Pages.ShareGame

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local httpRequest = require(Modules.Common.httpRequest)

local ShareGamePageFrame = require(ShareGame.Components.ShareGamePageFrame)
local Constants = require(ShareGame.Constants)
local FetchUserFriends = require(ShareGame.Thunks.FetchUserFriends)

local ClosePage = require(ShareGame.Actions.ClosePage)

local extended = Roact.PureComponent:extend("ShareGameContainer")
extended.defaultProps = { skeletonComponent = ShareGamePageFrame }

function extended.init(p)
	p.props.reFetch(p.props.requestImpl)
end

function extended.render(p)
	return Roact.createElement(p.props.skeletonComponent, p.props)
end

return (RoactRodux.UNSTABLE_connect2(function(p, _)
	return {
		deviceLayout = p.DeviceInfo.DeviceLayout,
		searchAreaActive = p.ConversationsSearch.SearchAreaActive,
		searchText = p.ConversationsSearch.SearchText
	}
end, function(callback)
	return {
		closePage = function()
			callback(ClosePage(Constants.PageRoute.SHARE_GAME))
		end,
		reFetch = function(p)
			local userId = tostring(Players.LocalPlayer.UserId)
			callback(FetchUserFriends(p or httpRequest(HttpRbxApiService), userId))
		end
	}
end)(extended))
