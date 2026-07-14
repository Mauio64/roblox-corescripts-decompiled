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
local v14 = Roact.PureComponent:extend("ShareGameContainer")

v14.defaultProps = {
	skeletonComponent = ShareGamePageFrame
}

function v14.init(p1) -- line: 30
	p1.props.reFetch(p1.props.requestImpl)
end
function v14.render(p2) -- line: 34
	-- upvalues: Roact (copy)
	return Roact.createElement(p2.props.skeletonComponent, p2.props)
end

return (RoactRodux.UNSTABLE_connect2(function(p3, _) -- line: 38
	return {
		deviceLayout = p3.DeviceInfo.DeviceLayout,
		searchAreaActive = p3.ConversationsSearch.SearchAreaActive,
		searchText = p3.ConversationsSearch.SearchText
	}
end, function(p5) -- line: 44
	-- upvalues: ClosePage (copy), Constants (copy), Players (copy), httpRequest (copy), HttpRbxApiService (copy), FetchUserFriends (copy)
	return {
		closePage = function() -- line: 46
			-- upvalues: p5 (copy), ClosePage (copy), Constants (copy)
			p5(ClosePage(Constants.PageRoute.SHARE_GAME))
		end,
		reFetch = function(p6) -- line: 50
			-- upvalues: Players (copy), httpRequest (copy), HttpRbxApiService (copy), p5 (copy), FetchUserFriends (copy)
			local str = tostring(Players.LocalPlayer.UserId)
			local v22 = p6 or httpRequest(HttpRbxApiService)

			p5(FetchUserFriends(v22, str))
		end
	}
end)(v14))
