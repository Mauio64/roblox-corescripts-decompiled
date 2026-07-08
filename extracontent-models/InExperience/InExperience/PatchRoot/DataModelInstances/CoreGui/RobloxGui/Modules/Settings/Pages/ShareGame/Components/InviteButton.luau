local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local Constants = require(ShareGame.Constants)
local RectangleButton = require(ShareGame.Components.RectangleButton)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v9 = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
local v10 = Theme.textSize(19)
local InviteStatus = Constants.InviteStatus
local t1 = {
	[InviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[InviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[InviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}
local v13 = require(ShareGame.getTranslator)()
local v14 = Roact.PureComponent:extend("InviteButton")

function v14.render(p1) -- line: 30
	-- upvalues: InviteStatus (copy), Immutable (copy), Roact (copy), RectangleButton (copy), v9 (copy), v13 (copy), v10 (copy), Constants (copy), t1 (copy)
	local anchorPoint = p1.props.anchorPoint
	local position = p1.props.position
	local size = p1.props.size
	local layoutOrder = p1.props.layoutOrder
	local zIndex = p1.props.zIndex
	local onInvite = p1.props.onInvite
	local inviteStatus = p1.props.inviteStatus

	if not inviteStatus or inviteStatus == InviteStatus.Failed then
		local v23 = Immutable.Set(p1.props, "onClick", function() -- line: 41
			-- upvalues: onInvite (copy)
			onInvite()
		end)

		return Roact.createElement(RectangleButton, v23, {
			InviteText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Font = v9,
				Text = v13:FormatByKey("Feature.SettingsHub.Action.InviteFriend"),
				TextSize = v10,
				TextColor3 = Constants.Color.WHITE,
				ZIndex = zIndex
			})
		})
	end

	local v24 = t1[inviteStatus] or "Feature.SettingsHub.Label.Moderated"

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = size,
		Font = v9,
		Text = v13:FormatByKey(v24),
		TextSize = v10,
		TextColor3 = Constants.Color.WHITE,
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex
	})
end

return v14
