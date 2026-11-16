local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UIBlox")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/RoactUtils")
local throttle = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").Throttle
local reducerDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").ReducerDependencies

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").LocalizationHelper
local GameInviteAnalyticsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalyticsManager")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local roduxNetworking = reducerDependencies.RoduxNetworking
local shareLinksNetworking = reducerDependencies.ShareLinksNetworking
local shareLinksRodux = reducerDependencies.ShareLinksRodux
local networkStatus = roduxNetworking.Enum.NetworkStatus
local getLocalizedStrings = localizationHelper.getLocalizedStrings

local linkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local images = UIBlox.App.ImageSet.Images

game:DefineFastFlag("generateGameInviteShareLinkOnClick", false)

local iconsactionsshare = images["icons/actions/share"]
local iconsmenulink = images["icons/menu/link"]

local v5 = {
	copied = "Feature.SocialShare.Label.Copied",
	copyLink = "Feature.SocialShare.Action.CopyLink"
}

return function(props)
	local state, setState = React.useState(false)

	local v6 = useSelector(function(p2)
		return p2
	end)

	local v7 = useStyle()
	local v8 = useDispatch()
	local localizedStrings = getLocalizedStrings(v5)

	local shareInviteLink = v6.ShareLinks.Invites.ShareInviteLink

	local function fn()
		v8(shareLinksNetworking.GenerateLink.API({
			linkType = shareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})):andThen(function(p2)
			local linkId = p2.responseBody.linkId
			GameInviteAnalyticsManager:linkGenerated({
				linkType = shareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue(),
				linkId = linkId
			})

			if
				game:GetFastFlag("generateGameInviteShareLinkOnClick")
				and p2
				and p2.responseBody
				and p2.responseBody.shortUrl
				and default
			then
				default:shareUrl({ url = p2.responseBody.shortUrl, context = "V1Menu" })
			end
		end)
	end

	React.useEffect(function()
		if not (game:GetFastFlag("generateGameInviteShareLinkOnClick") or shareInviteLink) then
			fn()
		end
	end, {})

	local status = shareLinksNetworking.GenerateLink.getStatus(v6, {
		linkType = shareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
	})

	local v9 = throttle(function()
		local v10 = if shareInviteLink then shareInviteLink.linkId else nil
		GameInviteAnalyticsManager:onShareButtonClick(v10)

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
					LinkButton = React.createElement(linkButton, {
						isDisabled = status == networkStatus.Fetching or state,
						isLoading = false,
						onActivated = v9,
						size = props.size,
						text = state and localizedStrings.copied or localizedStrings.copyLink
					})
				}
			)
		end

		return React.createElement(imageSetButton, {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			Size = props.size,
			[React.Event.Activated] = v9,
			Image = iconsmenulink,
			ImageColor3 = v7.Theme.IconEmphasis.Color,
			ImageTransparency = v7.Theme.IconEmphasis.Transparency,
			BorderSizePixel = 0
		})
	end

	return React.createElement(imageSetButton, {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		Size = props.size,
		[React.Event.Activated] = v9,
		Image = iconsactionsshare,
		ImageColor3 = v7.Theme.IconEmphasis.Color,
		ImageTransparency = v7.Theme.IconEmphasis.Transparency,
		BorderSizePixel = 0
	})
end
