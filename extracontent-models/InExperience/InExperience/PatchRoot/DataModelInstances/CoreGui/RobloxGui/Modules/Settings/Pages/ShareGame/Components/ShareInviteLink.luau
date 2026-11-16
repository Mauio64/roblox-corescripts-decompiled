local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")

local ExternalContentSharingProtocol = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local NotificationsCommon = require(CorePackages.Workspace.Packages.NotificationsCommon)
local ReducerDependencies = NotificationsCommon.ReducerDependencies
local Constants = require(ShareGame.Constants)
local ShareButton = require(ShareGame.Components.ShareButton)
local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()
local ShareInviteLinkMapDispatchToProps = require(ShareGame.Components.ShareInviteLinkMapDispatchToProps)
local ShareInviteLinkMapStateToProps = require(ShareGame.Components.ShareInviteLinkMapStateToProps)
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local NetworkStatus = ReducerDependencies.RoduxNetworking.Enum.NetworkStatus
local Theme = require(RobloxGui.Modules.Settings.Theme)

local GetFFlagEnableNewInviteMenu = require(RobloxGui.Modules.Flags.GetFFlagEnableNewInviteMenu)

local extended = Roact.PureComponent:extend("ShareInviteLink")
local v, v2, v3

if GetFFlagEnableNewInviteMenu() then
	v = 16
	v2 = 12
	v3 = 66
else
	v = 12
	v2 = 8
	v3 = 69
end

local color = Color3.fromRGB(79, 84, 95)
local formatByKey = translator:FormatByKey("Feature.SocialShare.Action.Share")
local formatByKey2 = translator:FormatByKey("Feature.SocialShare.Label.Copied")

local platform = UserInputService:GetPlatform()

extended.defaultProps = {
	externalContentSharingProtocol = default,
	isDesktopClient = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.UWP
}

function extended:init()
	self.state = { showCopiedText = false }

	function self.displayShareSheet(p)
		local props = self.props

		if props.externalContentSharingProtocol then
			props.externalContentSharingProtocol:shareUrl({ url = p.shortUrl, context = "V1Menu" })

			if props.isDesktopClient then
				self:setState({ showCopiedText = true })

				task.delay(1, function()
					self:setState({ showCopiedText = false })
				end)
			end
		end
	end
end

function extended.didUpdate(p, p2)
	local props = p.props

	if p2.shareInviteLink == nil and p.props.shareInviteLink ~= nil then
		local rawValue = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		local linkId = p.props.shareInviteLink.linkId

		p.props.analytics:linkGenerated({ linkType = rawValue, linkId = linkId })

		p.displayShareSheet(props.shareInviteLink)
	end
end

function extended.render(props)
	local size = props.props.size
	local layoutOrder = props.props.layoutOrder
	local deviceLayout = props.props.deviceLayout
	local zIndex = props.props.zIndex
	local v4 = Constants.LayoutSpecific[deviceLayout]

	local createElement = Roact.createElement
	local v5 = {
		Size = size,
		Position = props.props.position,
		LayoutOrder = layoutOrder,
		BackgroundColor3 = Theme.color("PlayerRowFrame", color),
		BackgroundTransparency = Theme.transparency("PlayerRowFrame", 0),
		ZIndex = zIndex,
		BorderSizePixel = 0
	}

	local v6 = {
		Corner = Roact.createElement("UICorner", { CornerRadius = Theme.MenuContainerCornerRadius }),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v),
			PaddingRight = UDim.new(0, v),
			PaddingTop = UDim.new(0, v2),
			PaddingBottom = UDim.new(0, v2)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 0,
			Text = translator:FormatByKey("Feature.SocialShare.Label.ShareServerLink"),
			Size = UDim2.new(1, -v3, 1, 0),
			TextSize = Theme.textSize(v4.PAGE_TITLE_TEXT_SIZE, "ShareLinkTitle"),
			TextColor3 = Constants.Color.WHITE,
			Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		}),
		ShareButton = 0
	}

	local createElement2 = Roact.createElement
	local v7 = {
		size = UDim2.new(0, v3, 1, 0),
		layoutOrder = 1,
		onShare = function()
			local props2 = props.props

			props.props.analytics:onShareButtonClick()

			if props.props.shareInviteLink == nil then
				props.props.fetchShareInviteLink()
			else
				props.displayShareSheet(props2.shareInviteLink)
			end
		end,
		text = 0,
		isEnabled = 0
	}
	local text

	if props.state.showCopiedText then
		text = formatByKey2
	else
		text = formatByKey
	end

	v7.text = text
	v7.isEnabled = props.props.fetchShareInviteLinkNetworkStatus ~= NetworkStatus.Fetching
		and not props.state.showCopiedText
	v6.ShareButton = createElement2(ShareButton, v7)
	return createElement("Frame", v5, v6)
end

return (RoactRodux.connect(ShareInviteLinkMapStateToProps, ShareInviteLinkMapDispatchToProps)(extended))
