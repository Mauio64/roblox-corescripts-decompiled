local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local ShareGame = Modules.Settings.Pages.ShareGame

local UIBlox = require(CorePackages.Packages.UIBlox)
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Constants = CoreScriptsCommon.Constants
local Theme = require(Modules.Settings.Theme)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteEvents = GameInvite.GameInviteEvents
local Constants2 = require(ShareGame.Constants)
local PresenceUtil = require(ShareGame.PresenceUtil)
local SingleUserThumbnail = require(ShareGame.Components.SingleUserThumbnail)
local InviteButton = require(ShareGame.Components.InviteButton)
local InviteStatus = Constants2.InviteStatus
local ThrottleFunctionCall = require(ShareGame.ThrottleFunctionCall)

local GetFFlagAbuseReportAnalyticsHasLaunchData = require(Modules.Settings.Flags.GetFFlagAbuseReportAnalyticsHasLaunchData)
local GetFFlagEnableNewInviteSendEndpoint = require(Modules.Flags.GetFFlagEnableNewInviteSendEndpoint)
local GetFFlagThrottleInviteSendEndpoint = require(Modules.Flags.GetFFlagThrottleInviteSendEndpoint)
local GetFIntThrottleInviteSendEndpointDelay = require(Modules.Flags.GetFIntThrottleInviteSendEndpointDelay)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport

local rect = Rect.new(10, 10, 10, 10)

return function(props)
	local user = props.user
	local onInvite = React.useCallback(function()
		local inviteUser = props.inviteUser
		local inviteStatus = props.inviteStatus
		local analytics = props.analytics

		if inviteStatus and inviteStatus ~= InviteStatus.Failed then
			return
		end

		local function fn(p)
			if not p then
				return
			end

			local v = { user.id }

			if Players.LocalPlayer and p then
				analytics:onActivatedInviteSent(Players.LocalPlayer.UserId, p.conversationId, v)
			end
		end

		if not GetFFlagEnableNewInviteSendEndpoint() then
			inviteUser(user.id):andThen(fn, function() end)

			return
		end

		local isLaunchDataProvided

		if props.launchData == nil then
			isLaunchDataProvided = false
		else
			isLaunchDataProvided = props.launchData ~= ""
		end

		local trigger = props.trigger
		local sendInvite = GameInviteEvents.SendInvite
		local v = { recipient = user.id, isLaunchDataProvided = 0 }

		if not GetFFlagAbuseReportAnalyticsHasLaunchData() then
			isLaunchDataProvided = nil
		end

		v.isLaunchDataProvided = isLaunchDataProvided
		analytics:sendEvent(trigger, sendInvite, v)

		inviteUser(user.id, analytics, props.trigger, props.inviteMessageId, props.launchData):andThen(
			fn,
			function() end
		)
	end, { props.inviteUser, props.inviteStatus, props.analytics, user })

	if GetFFlagThrottleInviteSendEndpoint() then
		onInvite = React.useCallback(ThrottleFunctionCall(GetFIntThrottleInviteSendEndpointDelay(), onInvite), {
			onInvite
		})
	end

	if not props.visible then
		return
	end

	local createElement = React.createElement
	local v = {
		["Size"] = UDim2.new(1, 0, 0, 60),
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = rect,
		BackgroundColor3 = Theme.color("PlayerRowFrame"),
		BackgroundTransparency = Theme.transparency("PlayerRowFrame", 1),
		ImageTransparency = 0.85,
		LayoutOrder = props.layoutOrder
	}
	local activated = ReactRoblox.Event.Activated
	local v2

	if props.isFullRowActivatable then
		v2 = onInvite
	end

	v[activated] = v2
	local children = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = Theme.MenuContainerCornerRadius
		}),
		Padding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 8)
		}),
		Thumbnail = React.createElement(SingleUserThumbnail, {
			user = user,
			size = UDim2.new(0, 44, 0, 44),
			position = UDim2.new(0, 0, 0.5, 0),
			anchorPoint = Vector2.new(0, 0.5)
		}),
		UserInfo = 0,
		InviteButton = 0
	}

	local createElement2 = React.createElement
	local v3 = {
		Position = UDim2.new(0, 44, 0, 0),
		Size = UDim2.new(1, -118, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local v4 = {
		Padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) }),
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		DisplayNameWrapper = React.createElement(
			"Frame",
			{ Size = UDim2.new(0, 0, 0, 16), BackgroundTransparency = 1 },
			{
				PresenceIconLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				Icon = PresenceUtil.GetIcon(user.presence),
				DisplayName = React.createElement("TextLabel", {
					Size = UDim2.new(0, 0, 0, 16),
					Text = user.displayName,
					TextSize = 16,
					TextColor3 = Constants.COLORS.WHITE,
					Font = AppFonts.default:getMedium(),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 2
				})
			}
		),
		Username = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		Size = UDim2.new(0, 0, 0, 16),
		Text = "@" .. user.name,
		TextSize = 16,
		TextColor3 = Constants.COLORS.PUMICE,
		Font = AppFonts.default:getDefault(),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		OpenTypeFeatures = 0
	}
	local openTypeFeatures

	if GetFFlagLuaAppEnableOpenTypeSupport() then
		openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
	end

	v5.OpenTypeFeatures = openTypeFeatures
	v4.Username = createElement3("TextLabel", v5)
	children.UserInfo = createElement2("Frame", v3, v4)

	children.InviteButton = React.createElement(InviteButton, {
		size = UDim2.new(0, 66, 0, 36),
		position = UDim2.new(1, 0, 0.5, 0),
		anchorPoint = Vector2.new(1, 0.5),
		onInvite = onInvite,
		inviteStatus = props.inviteStatus
	})
	return createElement("ImageButton", v, children)
end
