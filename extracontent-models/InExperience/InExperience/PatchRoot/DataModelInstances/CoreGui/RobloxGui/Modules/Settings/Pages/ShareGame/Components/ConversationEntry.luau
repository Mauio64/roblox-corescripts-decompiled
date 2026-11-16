local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules

local Roact = require(CorePackages.Packages.Roact)

local Theme = require(Modules.Settings.Theme)

local ShareGame = Modules.Settings.Pages.ShareGame

local ConversationDetails = require(ShareGame.Components.ConversationDetails)
local ConversationThumbnail = require(ShareGame.Components.ConversationThumbnail)

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream

local InviteButton = require(ShareGame.Components.InviteButton)

local Constants = require(ShareGame.Constants)
local InviteStatus = Constants.InviteStatus

local extended = Roact.PureComponent:extend("ConversationEntry")

function extended:init()
	self.eventStream = EventStream.new(RbxAnalyticsService)

	function self.onInvite()
		local inviteStatus = self.props.inviteStatus

		if inviteStatus and inviteStatus ~= InviteStatus.Failed then
			return
		end

		local analytics = self.props.analytics
		local users = self.props.users
		local inviteUser = self.props.inviteUser

		if #users == 1 then
			local function fn(p)
				if not p then
					return
				end

				local ids = {}

				for _, user in pairs(users) do
					table.insert(ids, user.id)
				end

				analytics:onActivatedInviteSent(Players.LocalPlayer.UserId, p.conversationId, ids)
			end

			inviteUser(users[1].id):andThen(fn, function() end)
		end
	end
end

function extended.render(p)
	local visible = p.props.visible
	local layoutOrder = p.props.layoutOrder
	local zIndex = p.props.zIndex
	local size = p.props.size
	local subtitle = p.props.subtitle
	local title = p.props.title
	local users = p.props.users
	local inviteStatus = p.props.inviteStatus

	local presence = p.props.presence

	return Roact.createElement("ImageButton", {
		Visible = visible,
		Selectable = true,
		BackgroundColor3 = Theme.color("PlayerRowFrame"),
		BackgroundTransparency = Theme.transparency("PlayerRowFrame", 1),
		ImageTransparency = 0,
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = Rect.new(),
		Size = size,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		[Roact.Event.Activated] = p.onInvite
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = Theme.MenuContainerCornerRadius
		}) or nil,
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}),
		Thumbnail = Roact.createElement(ConversationThumbnail, {
			users = users,
			size = UDim2.new(0, 32, 0, 32),
			layoutOrder = 0,
			zIndex = zIndex
		}),
		Details = Roact.createElement(ConversationDetails, {
			title = title,
			subtitle = subtitle,
			presence = presence,
			size = UDim2.new(1, -125, 1, 0),
			layoutOrder = 1,
			zIndex = zIndex
		}),
		InviteButton = Roact.createElement(InviteButton, {
			size = UDim2.new(0, 69, 1, 0),
			layoutOrder = 2,
			zIndex = zIndex,
			onInvite = p.onInvite,
			inviteStatus = inviteStatus
		})
	})
end

return extended
