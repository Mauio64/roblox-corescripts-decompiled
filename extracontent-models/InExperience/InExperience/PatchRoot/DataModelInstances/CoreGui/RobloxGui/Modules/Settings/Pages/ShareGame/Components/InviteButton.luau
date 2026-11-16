local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local Constants = require(ShareGame.Constants)
local RectangleButton = require(ShareGame.Components.RectangleButton)
local Theme = require(RobloxGui.Modules.Settings.Theme)

local font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
local textSize = Theme.textSize(19)
local InviteStatus = Constants.InviteStatus

local v = {
	[InviteStatus.Success] = "Feature.SettingsHub.Label.Invited",
	[InviteStatus.Moderated] = "Feature.SettingsHub.Label.Moderated",
	[InviteStatus.Pending] = "Feature.SettingsHub.Label.Sending"
}

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local extended = Roact.PureComponent:extend("InviteButton")

function extended.render(p)
	local anchorPoint = p.props.anchorPoint
	local position = p.props.position
	local size = p.props.size
	local layoutOrder = p.props.layoutOrder
	local zIndex = p.props.zIndex
	local onInvite = p.props.onInvite

	local inviteStatus = p.props.inviteStatus

	if inviteStatus and inviteStatus ~= InviteStatus.Failed then
		local v2 = v[inviteStatus] or "Feature.SettingsHub.Label.Moderated"

		return Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = anchorPoint,
			Position = position,
			Size = size,
			Font = font,
			Text = translator:FormatByKey(v2),
			TextSize = textSize,
			TextColor3 = Constants.Color.WHITE,
			TextXAlignment = Enum.TextXAlignment.Center,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex
		})
	end

	local v2 = Immutable.Set(p.props, "onClick", function()
		onInvite()
	end)

	return Roact.createElement(RectangleButton, v2, {
		InviteText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Font = font,
			Text = translator:FormatByKey("Feature.SettingsHub.Action.InviteFriend"),
			TextSize = textSize,
			TextColor3 = Constants.Color.WHITE,
			ZIndex = zIndex
		})
	})
end

return extended
