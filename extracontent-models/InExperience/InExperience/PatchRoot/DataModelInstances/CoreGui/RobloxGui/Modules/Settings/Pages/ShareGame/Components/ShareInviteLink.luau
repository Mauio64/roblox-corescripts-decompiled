local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local ReducerDependencies = require(CorePackages.Workspace.Packages.NotificationsCommon).ReducerDependencies
local Constants = require(ShareGame.Constants)
local ShareButton = require(ShareGame.Components.ShareButton)
local v11 = require(ShareGame.getTranslator)()
local ShareInviteLinkMapDispatchToProps = require(ShareGame.Components.ShareInviteLinkMapDispatchToProps)
local ShareInviteLinkMapStateToProps = require(ShareGame.Components.ShareInviteLinkMapStateToProps)
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local NetworkStatus = ReducerDependencies.RoduxNetworking.Enum.NetworkStatus
local Theme = require(RobloxGui.Modules.Settings.Theme)
local GetFFlagEnableNewInviteMenu = require(RobloxGui.Modules.Flags.GetFFlagEnableNewInviteMenu)
local v18 = Roact.PureComponent:extend("ShareInviteLink")
local n1 = 12
local n2 = 8
local n3 = 69

if GetFFlagEnableNewInviteMenu() then
	n1 = 16
	n2 = 12
	n3 = 66
end

local color3 = Color3.fromRGB(79, 84, 95)
local v23 = v11:FormatByKey("Feature.SocialShare.Action.Share")
local v24 = v11:FormatByKey("Feature.SocialShare.Label.Copied")
local Platform = UserInputService:GetPlatform()

v18.defaultProps = {
	externalContentSharingProtocol = default,
	isDesktopClient = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)
}

function v18.init(p1) -- line: 66
	p1.state = {
		showCopiedText = false
	}

	function p1.displayShareSheet(t1: {[any]: any}) -- line: 71
		-- upvalues: p1 (copy)
		local props = p1.props

		if props.externalContentSharingProtocol then
			props.externalContentSharingProtocol:shareUrl({
				context = "V1Menu",
				url = t1.shortUrl
			})

			if props.isDesktopClient then
				p1:setState({
					showCopiedText = true
				})
				task.delay(1, function() -- line: 82
					-- upvalues: p1 (copy)
					p1:setState({
						showCopiedText = false
					})
				end)
			end
		end
	end
end
function v18.didUpdate(p2, p3) -- line: 90
	-- upvalues: ShareLinksRodux (copy)
	local props = p2.props

	if p3.shareInviteLink == nil and p2.props.shareInviteLink ~= nil then
		local v30 = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		local linkId = p2.props.shareInviteLink.linkId

		p2.props.analytics:linkGenerated({
			linkType = v30,
			linkId = linkId
		})
		p2.displayShareSheet(props.shareInviteLink)
	end
end
function v18.render(p4) -- line: 103
	-- upvalues: Constants (copy), Roact (copy), Theme (copy), color3 (copy), n1 (ref), n2 (ref), v11 (copy), n3 (ref), ShareButton (copy), v24 (copy), v23 (copy), NetworkStatus (copy)
	local size = p4.props.size
	local layoutOrder = p4.props.layoutOrder
	local deviceLayout = p4.props.deviceLayout
	local zIndex = p4.props.zIndex
	local v37 = Constants.LayoutSpecific[deviceLayout]

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = size,
		Position = p4.props.position,
		LayoutOrder = layoutOrder,
		BackgroundColor3 = Theme.color("PlayerRowFrame", color3),
		BackgroundTransparency = Theme.transparency("PlayerRowFrame", 0),
		ZIndex = zIndex
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = Theme.MenuContainerCornerRadius
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, n1),
			PaddingRight = UDim.new(0, n1),
			PaddingTop = UDim.new(0, n2),
			PaddingBottom = UDim.new(0, n2)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = v11:FormatByKey("Feature.SocialShare.Label.ShareServerLink"),
			Size = UDim2.new(1, -n3, 1, 0),
			TextSize = Theme.textSize(v37.PAGE_TITLE_TEXT_SIZE, "ShareLinkTitle"),
			TextColor3 = Constants.Color.WHITE,
			Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		}),
		ShareButton = Roact.createElement(ShareButton, {
			layoutOrder = 1,
			size = UDim2.new(0, n3, 1, 0),
			onShare = function() -- line: 110
				-- upvalues: p4 (copy)
				local props = p4.props

				p4.props.analytics:onShareButtonClick()

				if p4.props.shareInviteLink == nil then
					p4.props.fetchShareInviteLink()

					return
				end

				p4.displayShareSheet(props.shareInviteLink)
			end,
			text = if not p4.state.showCopiedText then v23 else v24,
			isEnabled = p4.props.fetchShareInviteLinkNetworkStatus ~= NetworkStatus.Fetching and not p4.state.showCopiedText
		})
	})
end

return (RoactRodux.connect(ShareInviteLinkMapStateToProps, ShareInviteLinkMapDispatchToProps)(v18))
