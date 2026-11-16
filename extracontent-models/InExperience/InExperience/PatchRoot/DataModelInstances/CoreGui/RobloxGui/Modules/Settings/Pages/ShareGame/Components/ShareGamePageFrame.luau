local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RobloxGui = CoreGui:WaitForChild("RobloxGui", 1e999)

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Constants = CoreScriptsCommon.Constants
local Modules = CoreGui.RobloxGui.Modules
local ShareGame = Modules.Settings.Pages.ShareGame
local Promise = require(CorePackages.Packages.Promise)
local Utility = require(RobloxGui.Modules.Settings.Utility)

local GetFFlagEnableNewInviteMenu = require(Modules.Flags.GetFFlagEnableNewInviteMenu)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy

local httpRequest = require(Modules.Common.httpRequest)

local Header = require(ShareGame.Components.Header)
local ConversationList = require(ShareGame.Components.ConversationList)
local Constants2 = require(ShareGame.Constants)
local ShareInviteLink = require(ShareGame.Components.ShareInviteLink)
local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local BackButton = require(ShareGame.Components.BackButton)

local SetGameInfoCreated = require(ShareGame.Actions.SetGameInfoCreated)
local v, v2

if GetFFlagEnableNewInviteMenu() then
	v = 52
	v2 = 16
else
	v = 44
	v2 = 10
end

local extended = Roact.PureComponent:extend("ShareGamePageFrame")

local ErrorToaster = require(ShareGame.Components.ErrorToaster)

function extended:init()
	self.state = { serverType = nil }
end

function extended:shouldShowInviteLink(p): boolean
	if
		self.props.experienceInviteShareLinkEnabled
		and self.state.serverType == Constants.STANDARD_SERVER
		and Utility:IsExperienceOlderThanOneWeek(p)
	then
		return true
	end

	return false
end

function extended.didMount(object)
	object.props.fetchGameInfo()

	if object.state.serverType == nil then
		Promise.try(function()
			return RobloxReplicatedStorage:WaitForChild("GetServerType", 1e999):InvokeServer()
		end):andThen(function(serverType)
			object:setState({ serverType = serverType })
		end)
	end
end

function extended:render()
	local analytics = self.props.analytics
	local deviceLayout = self.props.deviceLayout
	local zIndex = self.props.zIndex
	local closePage = self.props.closePage
	local searchAreaActive = self.props.searchAreaActive
	local searchText = self.props.searchText

	local v3 = Constants2.LayoutSpecific[deviceLayout]
	local HEADER_HEIGHT = v3.HEADER_HEIGHT
	local v4 = deviceLayout == Constants2.DeviceLayout.DESKTOP
	local arrow = not v4 and BackButton.IconType.Arrow or BackButton.IconType.None

	local isVisible = self.props.isVisible
	local shouldShowInviteLink = self:shouldShowInviteLink(self.props.gameInfo)
	local v5 = 0
	local v6

	if shouldShowInviteLink then
		v5 -= v
		v6 = 10
	else
		v6 = 0
	end

	local createElement = Roact.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = zIndex,
		AutoLocalize = false
	}

	local v8 = {
		toasterPortal = Roact.createElement(Roact.Portal, { target = CoreGui }, {
			Toaster = Roact.createElement(ErrorToaster)
		}),
		Header = Roact.createElement(Header, {
			deviceLayout = deviceLayout,
			size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
			position = UDim2.new(0, 0, 0, -HEADER_HEIGHT),
			layoutOrder = 0,
			zIndex = zIndex,
			closePage = closePage,
			searchAreaActive = searchAreaActive,
			toggleSearchIcon = not v4,
			iconType = arrow,
			analytics = analytics
		}),
		ShareInviteLink = 0,
		ConversationList = 0
	}
	local shareInviteLink

	if shouldShowInviteLink then
		shareInviteLink = Roact.createElement(ShareInviteLink, {
			position = UDim2.new(0, 0, 0, v6),
			analytics = analytics,
			deviceLayout = deviceLayout,
			size = UDim2.new(1, 0, 0, v),
			layoutOrder = 1,
			zIndex = zIndex
		}) or nil
	end

	v8.ShareInviteLink = shareInviteLink

	v8.ConversationList = Roact.createElement(ConversationList, {
		analytics = analytics,
		size = UDim2.new(1, 0, 1, v3.EXTEND_BOTTOM_SIZE - v2 + v5),
		topPadding = shouldShowInviteLink and v2 + v + v6 or v2,
		layoutOrder = shouldShowInviteLink and 2 or 1,
		zIndex = zIndex,
		searchText = searchText,
		isVisible = isVisible,
		trigger = "GameMenu"
	})
	return createElement("Frame", v7, v8)
end

local v3 = RoactRodux.connect(function(p)
	return { gameInfo = p.GameInfo }
end, function(callback)
	return {
		fetchGameInfo = function()
			GetGameNameAndDescription(httpRequest(HttpRbxApiService), game.GameId):andThen(function(p)
				callback(SetGameInfoCreated(p.Created))
			end)
		end
	}
end)(extended)

return (RoactAppPolicy.connect(function(p)
	return {
		experienceInviteShareLinkEnabled = p.getExperienceInviteShareLinkEnabled()
	}
end)(v3))
