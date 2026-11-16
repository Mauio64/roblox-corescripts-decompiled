local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local RoactUtils = require(parent.RoactUtils)
local NotificationsCommon = require(parent.NotificationsCommon)
local Throttle = NotificationsCommon.Throttle
local NotificationsCommon2 = require(parent.NotificationsCommon)
local ReducerDependencies = NotificationsCommon2.ReducerDependencies

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local NotificationsCommon3 = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon3.LocalizationHelper
local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoduxNetworking = ReducerDependencies.RoduxNetworking
local ShareLinksNetworking = ReducerDependencies.ShareLinksNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local NetworkStatus = RoduxNetworking.Enum.NetworkStatus
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings

local LinkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images

game:DefineFastFlag("generateGameInviteShareLinkOnClick", false)

local iconsactionsshare = Images["icons/actions/share"]
local iconsmenulink = Images["icons/menu/link"]

local v = {
	copied = "Feature.SocialShare.Label.Copied",
	copyLink = "Feature.SocialShare.Action.CopyLink"
}

return function(props)
	local state, setState = React.useState(false)

	local v2 = useSelector(function(p)
		return p
	end)

	local v3 = useStyle()
	local v4 = useDispatch()
	local localizedStrings = getLocalizedStrings(v)

	local shareInviteLink = v2.ShareLinks.Invites.ShareInviteLink

	local function fn()
		v4(ShareLinksNetworking.GenerateLink.API({
			linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})):andThen(function(p)
			local linkId = p.responseBody.linkId
			GameInviteAnalyticsManager:linkGenerated({
				linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue(),
				linkId = linkId
			})

			if
				game:GetFastFlag("generateGameInviteShareLinkOnClick")
				and p
				and p.responseBody
				and p.responseBody.shortUrl
				and default
			then
				default:shareUrl({ url = p.responseBody.shortUrl, context = "V1Menu" })
			end
		end)
	end

	React.useEffect(function()
		if not (game:GetFastFlag("generateGameInviteShareLinkOnClick") or shareInviteLink) then
			fn()
		end
	end, {})

	local status = ShareLinksNetworking.GenerateLink.getStatus(v2, {
		linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
	})

	local onActivated = Throttle(function()
		local v5

		if shareInviteLink then
			v5 = shareInviteLink.linkId
		end

		GameInviteAnalyticsManager:onShareButtonClick(v5)

		if shareInviteLink then
			if default then
				default:shareUrl({ url = shareInviteLink.shortUrl, context = "V1Menu" })
			end
		else
			fn()
		end

		if props.isDesktop then
			setState(true)
			task.delay(1, function()
				setState(false)
			end)
		end
	end)

	if props.isDesktop then
		if props.isFullSize then
			return React.createElement(
				"Frame",
				{
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = props.size,
					LayoutOrder = props.layoutOrder
				},
				{
					LinkButton = React.createElement(LinkButton, {
						isDisabled = status == NetworkStatus.Fetching or state,
						isLoading = false,
						onActivated = onActivated,
						size = props.size,
						text = state and localizedStrings.copied or localizedStrings.copyLink
					})
				}
			)
		end

		return React.createElement(ImageSetButton, {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			Size = props.size,
			[React.Event.Activated] = onActivated,
			Image = iconsmenulink,
			ImageColor3 = v3.Theme.IconEmphasis.Color,
			ImageTransparency = v3.Theme.IconEmphasis.Transparency,
			BorderSizePixel = 0
		})
	end

	return React.createElement(ImageSetButton, {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		Size = props.size,
		[React.Event.Activated] = onActivated,
		Image = iconsactionsshare,
		ImageColor3 = v3.Theme.IconEmphasis.Color,
		ImageTransparency = v3.Theme.IconEmphasis.Transparency,
		BorderSizePixel = 0
	})
end
