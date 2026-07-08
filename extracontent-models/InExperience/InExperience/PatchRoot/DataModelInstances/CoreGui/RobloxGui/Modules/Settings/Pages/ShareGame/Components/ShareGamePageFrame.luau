local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RobloxGui = CoreGui:WaitForChild("RobloxGui", 1e999)
local Constants = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants
local Modules = CoreGui.RobloxGui.Modules
local ShareGame = Modules.Settings.Pages.ShareGame
local Promise = require(CorePackages.Packages.Promise)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local GetFFlagEnableNewInviteMenu = require(Modules.Flags.GetFFlagEnableNewInviteMenu)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local httpRequest = require(Modules.Common.httpRequest)
local Header = require(ShareGame.Components.Header)
local ConversationList = require(ShareGame.Components.ConversationList)
local Constants2 = require(ShareGame.Constants)
local ShareInviteLink = require(ShareGame.Components.ShareInviteLink)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local BackButton = require(ShareGame.Components.BackButton)
local SetGameInfoCreated = require(ShareGame.Actions.SetGameInfoCreated)
local n1 = 10
local n2 = 44

if GetFFlagEnableNewInviteMenu() then
	n1 = 16
	n2 = 52
end

local v25 = Roact.PureComponent:extend("ShareGamePageFrame")
local ErrorToaster = require(ShareGame.Components.ErrorToaster)

function v25.init(p1) -- line: 43
	p1.state = {
		serverType = nil
	}
end
function v25.shouldShowInviteLink(p2, p3) -- line: 49
	-- upvalues: Constants (copy), Utility (copy)
	if p2.props.experienceInviteShareLinkEnabled and (p2.state.serverType == Constants.STANDARD_SERVER and Utility:IsExperienceOlderThanOneWeek(p3)) then
		return true
	end

	return false
end
function v25.didMount(p4) -- line: 61
	-- upvalues: Promise (copy), RobloxReplicatedStorage (copy)
	p4.props.fetchGameInfo()

	if p4.state.serverType == nil then
		Promise.try(function() -- line: 64
			-- upvalues: RobloxReplicatedStorage (copy)
			return RobloxReplicatedStorage:WaitForChild("GetServerType", 1e999):InvokeServer()
		end):andThen(function(p5) -- line: 67
			-- upvalues: p4 (copy)
			p4:setState({
				serverType = p5
			})
		end)
	end
end
function v25.render(p6) -- line: 73
	-- upvalues: Constants2 (copy), BackButton (copy), n2 (ref), Roact (copy), CoreGui (copy), ErrorToaster (copy), Header (copy), ShareInviteLink (copy), ConversationList (copy), n1 (ref)
	local analytics = p6.props.analytics
	local deviceLayout = p6.props.deviceLayout
	local zIndex = p6.props.zIndex
	local closePage = p6.props.closePage
	local searchAreaActive = p6.props.searchAreaActive
	local searchText = p6.props.searchText
	local v39 = Constants2.LayoutSpecific[deviceLayout]
	local HEADER_HEIGHT = v39.HEADER_HEIGHT
	local v41 = deviceLayout == Constants2.DeviceLayout.DESKTOP
	local v42 = not v41 and BackButton.IconType.Arrow or BackButton.IconType.None
	local isVisible = p6.props.isVisible
	local v44 = p6:shouldShowInviteLink(p6.props.gameInfo)
	local n3 = 0
	local n4 = 0

	if v44 then
		n3 -= n2
		n4 = 10
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AutoLocalize = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = zIndex
	}, {
		toasterPortal = Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			Toaster = Roact.createElement(ErrorToaster)
		}),
		Header = Roact.createElement(Header, {
			layoutOrder = 0,
			deviceLayout = deviceLayout,
			size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
			position = UDim2.new(0, 0, 0, -HEADER_HEIGHT),
			zIndex = zIndex,
			closePage = closePage,
			searchAreaActive = searchAreaActive,
			toggleSearchIcon = not v41,
			iconType = v42,
			analytics = analytics
		}),
		ShareInviteLink = v44 and Roact.createElement(ShareInviteLink, {
			layoutOrder = 1,
			position = UDim2.new(0, 0, 0, n4),
			analytics = analytics,
			deviceLayout = deviceLayout,
			size = UDim2.new(1, 0, 0, n2),
			zIndex = zIndex
		}) or nil,
		ConversationList = Roact.createElement(ConversationList, {
			trigger = "GameMenu",
			analytics = analytics,
			size = UDim2.new(1, 0, 1, v39.EXTEND_BOTTOM_SIZE - n1 + n3),
			topPadding = v44 and n1 + n2 + n4 or n1,
			layoutOrder = not v44 and 1 or 2,
			zIndex = zIndex,
			searchText = searchText,
			isVisible = isVisible
		})
	})
end

local v27 = RoactRodux.connect(function(p7) -- line: 143
	return {
		gameInfo = p7.GameInfo
	}
end, function(p8) -- line: 147
	-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetGameNameAndDescription (copy), SetGameInfoCreated (copy)
	return {
		fetchGameInfo = function() -- line: 149
			-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetGameNameAndDescription (copy), p8 (copy), SetGameInfoCreated (copy)
			local v51 = httpRequest(HttpRbxApiService)

			GetGameNameAndDescription(v51, game.GameId):andThen(function(p9) -- line: 151
				-- upvalues: p8 (copy), SetGameInfoCreated (copy)
				p8(SetGameInfoCreated(p9.Created))
			end)
		end
	}
end)(v25)

return (RoactAppPolicy.connect(function(p10) -- line: 158
	return {
		experienceInviteShareLinkEnabled = p10.getExperienceInviteShareLinkEnabled()
	}
end)(v27))
