local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteParent = GameInvite.Parent
local React = require(GameInviteParent.React)
local UIBlox = require(GameInviteParent.UIBlox)
local RoactUtils = require(GameInviteParent.RoactUtils)
local Throttle = require(GameInviteParent.NotificationsCommon).Throttle
local ReducerDependencies = require(GameInviteParent.NotificationsCommon).ReducerDependencies
local default = require(GameInviteParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local LocalizationHelper = require(GameInviteParent.NotificationsCommon).LocalizationHelper
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

local v22 = Images["icons/actions/share"]
local v23 = Images["icons/menu/link"]
local t1 = {
	copied = "Feature.SocialShare.Label.Copied",
	copyLink = "Feature.SocialShare.Action.CopyLink"
}

return function(t2: {[any]: any}) -- line: 46
	-- upvalues: React (copy), useSelector (copy), useStyle (copy), useDispatch (copy), getLocalizedStrings (copy), t1 (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy), GameInviteAnalyticsManager (copy), default (copy), Throttle (copy), LinkButton (copy), NetworkStatus (copy), ImageSetButton (copy), v23 (copy), v22 (copy)
	local v26, v27 = React.useState(false)
	local v28 = useSelector(function(p1) -- line: 49
		return p1
	end)
	local v29 = useStyle()
	local v30 = useDispatch()
	local v31 = getLocalizedStrings(t1)
	local ShareInviteLink = v28.ShareLinks.Invites.ShareInviteLink

	local function v33() -- line: 61
		-- upvalues: v30 (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy), GameInviteAnalyticsManager (copy), default (copy)
		v30(ShareLinksNetworking.GenerateLink.API({
			linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})):andThen(function(p2) -- line: 64
			-- upvalues: GameInviteAnalyticsManager (copy), ShareLinksRodux (copy), default (copy)
			local linkId = p2.responseBody.linkId

			GameInviteAnalyticsManager:linkGenerated({
				linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue(),
				linkId = linkId
			})

			if game:GetFastFlag("generateGameInviteShareLinkOnClick") and (p2 and p2.responseBody and p2.responseBody.shortUrl and default) then
				default:shareUrl({
					context = "V1Menu",
					url = p2.responseBody.shortUrl
				})
			end
		end)
	end

	React.useEffect(function() -- line: 86
		-- upvalues: ShareInviteLink (copy), v33 (copy)
		if not game:GetFastFlag("generateGameInviteShareLinkOnClick") and not ShareInviteLink then
			v33()
		end
	end, {})

	local v34 = ShareLinksNetworking.GenerateLink.getStatus(v28, {
		linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
	})
	local v35 = Throttle(function() -- line: 100
		-- upvalues: ShareInviteLink (copy), GameInviteAnalyticsManager (copy), default (copy), v33 (copy), t2 (copy), v27 (copy)
		local v37 = if not ShareInviteLink then nil else ShareInviteLink.linkId

		GameInviteAnalyticsManager:onShareButtonClick(v37)

		if ShareInviteLink then
			if default then
				default:shareUrl({
					context = "V1Menu",
					url = ShareInviteLink.shortUrl
				})
			end
		else
			v33()
		end

		if t2.isDesktop then
			v27(true)
			task.delay(1, function() -- line: 116
				-- upvalues: v27 (copy)
				v27(false)
			end)
		end
	end)

	if t2.isDesktop then
		if t2.isFullSize then
			return React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = t2.size,
				LayoutOrder = t2.layoutOrder
			}, {
				LinkButton = React.createElement(LinkButton, {
					isLoading = false,
					isDisabled = v34 == NetworkStatus.Fetching or v26,
					onActivated = v35,
					size = t2.size,
					text = v26 and v31.copied or v31.copyLink
				})
			})
		end

		return React.createElement(ImageSetButton, {
			LayoutOrder = t2.layoutOrder,
			BackgroundTransparency = 1,
			Size = t2.size,
			[React.Event.Activated] = v35,
			Image = v23,
			ImageColor3 = v29.Theme.IconEmphasis.Color,
			ImageTransparency = v29.Theme.IconEmphasis.Transparency,
			BorderSizePixel = 0
		})
	end

	return React.createElement(ImageSetButton, {
		LayoutOrder = t2.layoutOrder,
		BackgroundTransparency = 1,
		Size = t2.size,
		[React.Event.Activated] = v35,
		Image = v22,
		ImageColor3 = v29.Theme.IconEmphasis.Color,
		ImageTransparency = v29.Theme.IconEmphasis.Transparency,
		BorderSizePixel = 0
	})
end
