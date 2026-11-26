local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Localization").Hooks.useLocalization
local iconSize = Foundation.Enums.IconSize
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/RoactUtils").Hooks.RoactRodux.useDispatch
local reducerDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").ReducerDependencies
local shareLinksNetworking = reducerDependencies.ShareLinksNetworking
local shareLinksRodux = reducerDependencies.ShareLinksRodux

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local deviceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").DeviceInfo
local throttle = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").Throttle
local popover = Foundation.Popover

local popoverAlign = Foundation.Enums.PopoverAlign

return function(p2)
	local v5 = useDispatch()
	local desktopDevice = deviceInfo.isDesktopDevice()
	local state, setState = React.useState(false)
	local function fn()
		if desktopDevice and state then
			return
		end

		v5(shareLinksNetworking.GenerateLink.API({
			linkType = shareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})):andThen(function(p3)
			if p3 and p3.responseBody and p3.responseBody.shortUrl and default then
				default:shareUrl({ url = p3.responseBody.shortUrl, context = "V1Menu" })
			end
		end):catch(function(p3)
			warn(p3)
		end)
	end
	local v6 = useLocalization({
		copyLink = desktopDevice and "Feature.SocialShare.Label.CopyLinkToShareWithPeople" or "Feature.SocialShare.ShareWithPeopleYouKnow",
		copied = "Feature.SocialShare.Label.Copied"
	})

	return React.createElement(Foundation.View, {
		tag = "row size-full-1400 padding-x-xxlarge gap-medium align-y-center",
		LayoutOrder = p2.layoutOrder,
		onActivated = throttle(function()
			fn()

			if desktopDevice then
				setState(true)
				task.delay(2, function()
					setState(false)
				end)
			end
		end)
	}, {
		PopoverRoot = React.createElement(popover.Root, { isOpen = state }, {
			ShareIconContainer = React.createElement(
				Foundation.View,
				{
					tag = "col radius-circle bg-surface-300 align-x-center align-y-center",
					Size = UDim2.fromOffset(56, 56)
				},
				{
					ShareIcon = React.createElement(Foundation.Icon, {
						name = desktopDevice and "icons/menu/link" or "icons/actions/share",
						size = iconSize.Medium
					})
				}
			),
			PopoverAnchor = React.createElement(popover.Anchor, nil, {
				LabelText = React.createElement(Foundation.Text, {
					tag = "text-title-large size-full align-x-left text-align-x-left",
					Text = v6.copyLink
				})
			}),
			Content = React.createElement(
				popover.Content,
				{
					tags = "size-full auto-y",
					hasArrow = false,
					align = popoverAlign.End
				},
				{
					CopiedPopoverText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-title-small text-align-x-center padding-medium",
						Text = v6.copied
					})
				}
			)
		})
	})
end
