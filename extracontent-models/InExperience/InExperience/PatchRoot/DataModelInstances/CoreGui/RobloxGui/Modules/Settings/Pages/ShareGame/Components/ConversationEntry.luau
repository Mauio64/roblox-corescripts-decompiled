local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Theme = require(Modules.Settings.Theme)
local ShareGame = Modules.Settings.Pages.ShareGame
local ConversationDetails = require(ShareGame.Components.ConversationDetails)
local ConversationThumbnail = require(ShareGame.Components.ConversationThumbnail)
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local InviteButton = require(ShareGame.Components.InviteButton)
local InviteStatus = require(ShareGame.Constants).InviteStatus
local v13 = Roact.PureComponent:extend("ConversationEntry")

function v13.init(p1) -- line: 30
	-- upvalues: EventStream (copy), RbxAnalyticsService (copy), InviteStatus (copy), Players (copy)
	p1.eventStream = EventStream.new(RbxAnalyticsService)

	function p1.onInvite() -- line: 33
		-- upvalues: p1 (copy), InviteStatus (copy), Players (copy)
		local inviteStatus = p1.props.inviteStatus

		if inviteStatus and inviteStatus ~= InviteStatus.Failed then
			return
		end

		local analytics = p1.props.analytics
		local users = p1.props.users
		local inviteUser = p1.props.inviteUser

		if #users == 1 then
			inviteUser(users[1].id):andThen(function(p2) -- line: 45
				-- upvalues: users (copy), Players (copy), analytics (copy)
				if not p2 then
					return
				end

				local t1 = {}

				for _, v in pairs(users) do
					table.insert(t1, v.id)
				end

				local LocalPlayer = Players.LocalPlayer

				analytics:onActivatedInviteSent(LocalPlayer.UserId, p2.conversationId, t1)
			end, function() -- line: 60
			end)
		end
	end
end
function v13.render(p3) -- line: 66
	-- upvalues: Roact (copy), Theme (copy), ConversationThumbnail (copy), ConversationDetails (copy), InviteButton (copy)
	local visible = p3.props.visible
	local layoutOrder = p3.props.layoutOrder
	local zIndex = p3.props.zIndex
	local size = p3.props.size
	local subtitle = p3.props.subtitle
	local title = p3.props.title
	local users = p3.props.users
	local inviteStatus = p3.props.inviteStatus
	local presence = p3.props.presence

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
		[Roact.Event.Activated] = p3.onInvite
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
			layoutOrder = 0,
			users = users,
			size = UDim2.new(0, 32, 0, 32),
			zIndex = zIndex
		}),
		Details = Roact.createElement(ConversationDetails, {
			layoutOrder = 1,
			title = title,
			subtitle = subtitle,
			presence = presence,
			size = UDim2.new(1, -125, 1, 0),
			zIndex = zIndex
		}),
		InviteButton = Roact.createElement(InviteButton, {
			layoutOrder = 2,
			size = UDim2.new(0, 69, 1, 0),
			zIndex = zIndex,
			onInvite = p3.onInvite,
			inviteStatus = inviteStatus
		})
	})
end

return v13
