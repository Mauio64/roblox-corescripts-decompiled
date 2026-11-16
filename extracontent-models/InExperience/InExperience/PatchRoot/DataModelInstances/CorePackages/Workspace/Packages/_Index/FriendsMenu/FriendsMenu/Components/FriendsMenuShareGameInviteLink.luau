local parent = script:FindFirstAncestor("FriendsMenu").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local IconSize = Foundation.Enums.IconSize
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NotificationsCommon = require(parent.NotificationsCommon)
local ReducerDependencies = NotificationsCommon.ReducerDependencies
local ShareLinksNetworking = ReducerDependencies.ShareLinksNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local NotificationsCommon2 = require(parent.NotificationsCommon)
local DeviceInfo = NotificationsCommon2.DeviceInfo
local NotificationsCommon3 = require(parent.NotificationsCommon)
local Throttle = NotificationsCommon3.Throttle
local Popover = Foundation.Popover

local PopoverAlign = Foundation.Enums.PopoverAlign

return function(p)
	local v = useDispatch()
	local desktopDevice = DeviceInfo.isDesktopDevice()
	local state, setState = React.useState(false)
	local function fn()
		if desktopDevice and state then
			return
		end

		v(ShareLinksNetworking.GenerateLink.API({
			linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})):andThen(function(p2)
			if p2 and p2.responseBody and p2.responseBody.shortUrl and default then
				default:shareUrl({ url = p2.responseBody.shortUrl, context = "V1Menu" })
			end
		end):catch(function(p2)
			warn(p2)
		end)
	end
	local v2 = useLocalization({
		copyLink = desktopDevice and "Feature.SocialShare.Label.CopyLinkToShareWithPeople" or "Feature.SocialShare.ShareWithPeopleYouKnow",
		copied = "Feature.SocialShare.Label.Copied"
	})

	return React.createElement(Foundation.View, {
		tag = "row size-full-1400 padding-x-xxlarge gap-medium align-y-center",
		LayoutOrder = p.layoutOrder,
		onActivated = Throttle(function()
			fn()

			if desktopDevice then
				setState(true)
				task.delay(2, function()
					setState(false)
				end)
			end
		end)
	}, {
		PopoverRoot = React.createElement(Popover.Root, { isOpen = state }, {
			ShareIconContainer = React.createElement(
				Foundation.View,
				{
					tag = "col radius-circle bg-surface-300 align-x-center align-y-center",
					Size = UDim2.fromOffset(56, 56)
				},
				{
					ShareIcon = React.createElement(Foundation.Icon, {
						name = desktopDevice and "icons/menu/link" or "icons/actions/share",
						size = IconSize.Medium
					})
				}
			),
			PopoverAnchor = React.createElement(Popover.Anchor, nil, {
				LabelText = React.createElement(Foundation.Text, {
					tag = "text-title-large size-full align-x-left text-align-x-left",
					Text = v2.copyLink
				})
			}),
			Content = React.createElement(
				Popover.Content,
				{ tags = "size-full auto-y", hasArrow = false, align = PopoverAlign.End },
				{
					CopiedPopoverText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-title-small text-align-x-center padding-medium",
						Text = v2.copied
					})
				}
			)
		})
	})
end
