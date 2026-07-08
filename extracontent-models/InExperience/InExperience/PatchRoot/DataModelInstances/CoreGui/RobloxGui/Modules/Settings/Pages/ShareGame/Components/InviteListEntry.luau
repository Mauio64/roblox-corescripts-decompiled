local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ShareGame = Modules.Settings.Pages.ShareGame
local OpenTypeSupport = require(CorePackages.Packages.UIBlox).Utility.OpenTypeSupport
local Constants = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants
local Theme = require(Modules.Settings.Theme)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local GameInviteEvents = require(CorePackages.Workspace.Packages.GameInvite).GameInviteEvents
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
local GetFFlagLuaAppEnableOpenTypeSupport = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local rect = Rect.new(10, 10, 10, 10)

return function(t1: {[any]: any}) -- line: 64
	-- upvalues: React (copy), InviteStatus (copy), Players (copy), GetFFlagEnableNewInviteSendEndpoint (copy), GameInviteEvents (copy), GetFFlagAbuseReportAnalyticsHasLaunchData (copy), GetFFlagThrottleInviteSendEndpoint (copy), ThrottleFunctionCall (copy), GetFIntThrottleInviteSendEndpointDelay (copy), rect (copy), Theme (copy), ReactRoblox (copy), SingleUserThumbnail (copy), PresenceUtil (copy), Constants (copy), AppFonts (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), InviteButton (copy)
	local user = t1.user
	local v26 = React.useCallback(function() -- line: 66
		-- upvalues: t1 (copy), InviteStatus (copy), user (copy), Players (copy), GetFFlagEnableNewInviteSendEndpoint (copy), GameInviteEvents (copy), GetFFlagAbuseReportAnalyticsHasLaunchData (copy)
		local inviteUser = t1.inviteUser
		local inviteStatus = t1.inviteStatus
		local analytics = t1.analytics

		if inviteStatus and inviteStatus ~= InviteStatus.Failed then
			return
		end

		local function v30(p1) -- line: 74
			-- upvalues: user (copy), Players (copy), analytics (copy)
			if not p1 then
				return
			end

			local t2 = { user.id }

			if Players.LocalPlayer and p1 then
				local LocalPlayer = Players.LocalPlayer

				analytics:onActivatedInviteSent(LocalPlayer.UserId, p1.conversationId, t2)
			end
		end

		if GetFFlagEnableNewInviteSendEndpoint() then
			local v31 = t1.launchData ~= nil and t1.launchData ~= ""

			analytics:sendEvent(t1.trigger, GameInviteEvents.SendInvite, {
				recipient = user.id,
				isLaunchDataProvided = if not GetFFlagAbuseReportAnalyticsHasLaunchData() then nil else v31
			})
			inviteUser(user.id, analytics, t1.trigger, t1.inviteMessageId, t1.launchData):andThen(v30, function() -- line: 97
			end)

			return
		end

		inviteUser(user.id):andThen(v30, function() -- line: 100
		end)
	end, {
		t1.inviteUser,
		t1.inviteStatus,
		t1.analytics,
		user
	})

	if GetFFlagThrottleInviteSendEndpoint() then
		v26 = React.useCallback(ThrottleFunctionCall(GetFIntThrottleInviteSendEndpointDelay(), v26), { v26 })
	end

	if not t1.visible then
		return
	end

	return React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 0, 60),
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = rect,
		BackgroundColor3 = Theme.color("PlayerRowFrame"),
		BackgroundTransparency = Theme.transparency("PlayerRowFrame", 1),
		ImageTransparency = 0.85,
		LayoutOrder = t1.layoutOrder,
		[ReactRoblox.Event.Activated] = if not t1.isFullRowActivatable then nil else v26
	}, {
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
		UserInfo = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.new(0, 44, 0, 0),
			Size = UDim2.new(1, -118, 1, 0)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8)
			}),
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			DisplayNameWrapper = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 16)
			}, {
				PresenceIconLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				Icon = PresenceUtil.GetIcon(user.presence),
				DisplayName = React.createElement("TextLabel", {
					TextSize = 16,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(0, 0, 0, 16),
					Text = user.displayName,
					TextColor3 = Constants.COLORS.WHITE,
					Font = AppFonts.default:getMedium(),
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			Username = React.createElement("TextLabel", {
				TextSize = 16,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 0, 16),
				Text = "@" .. user.name,
				TextColor3 = Constants.COLORS.PUMICE,
				Font = AppFonts.default:getDefault(),
				TextXAlignment = Enum.TextXAlignment.Left,
				OpenTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
			})
		}),
		InviteButton = React.createElement(InviteButton, {
			size = UDim2.new(0, 66, 0, 36),
			position = UDim2.new(1, 0, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			onInvite = v26,
			inviteStatus = t1.inviteStatus
		})
	})
end
