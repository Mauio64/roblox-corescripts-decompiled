local Parent = script:FindFirstAncestor("FriendsMenu").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local IconSize = Foundation.Enums.IconSize
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local ReducerDependencies = require(Parent.NotificationsCommon).ReducerDependencies
local ShareLinksNetworking = ReducerDependencies.ShareLinksNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local DeviceInfo = require(Parent.NotificationsCommon).DeviceInfo
local Throttle = require(Parent.NotificationsCommon).Throttle
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useDispatch (copy), DeviceInfo (copy), React (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy), default (copy), useLocalization (copy), Foundation (copy), Throttle (copy), Popover (copy), IconSize (copy), PopoverAlign (copy)
	local v16 = useDispatch()
	local v17 = DeviceInfo.isDesktopDevice()
	local v18, v19 = React.useState(false)

	local function v20() -- line: 31
		-- upvalues: v17 (copy), v18 (copy), v16 (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy), default (copy)
		if v17 and v18 then
			return
		end

		v16(ShareLinksNetworking.GenerateLink.API({
			linkType = ShareLinksRodux.Enums.LinkType.ExperienceInvite.rawValue()
		})):andThen(function(p1) -- line: 40
			-- upvalues: default (copy)
			if p1 and (p1.responseBody and p1.responseBody.shortUrl and default) then
				default:shareUrl({
					context = "V1Menu",
					url = p1.responseBody.shortUrl
				})
			end
		end):catch(function(p2) -- line: 53
			warn(p2)
		end)
	end

	local v21 = useLocalization({
		copied = "Feature.SocialShare.Label.Copied",
		copyLink = v17 and "Feature.SocialShare.Label.CopyLinkToShareWithPeople" or "Feature.SocialShare.ShareWithPeopleYouKnow"
	})

	return React.createElement(Foundation.View, {
		tag = "row size-full-1400 padding-x-xxlarge gap-medium align-y-center",
		LayoutOrder = t1.layoutOrder,
		onActivated = Throttle(function() -- line: 66
			-- upvalues: v20 (copy), v17 (copy), v19 (copy)
			v20()

			if v17 then
				v19(true)
				task.delay(2, function() -- line: 70
					-- upvalues: v19 (copy)
					v19(false)
				end)
			end
		end)
	}, {
		PopoverRoot = React.createElement(Popover.Root, {
			isOpen = v18
		}, {
			ShareIconContainer = React.createElement(Foundation.View, {
				tag = "col radius-circle bg-surface-300 align-x-center align-y-center",
				Size = UDim2.fromOffset(56, 56)
			}, {
				ShareIcon = React.createElement(Foundation.Icon, {
					name = v17 and "icons/menu/link" or "icons/actions/share",
					size = IconSize.Medium
				})
			}),
			PopoverAnchor = React.createElement(Popover.Anchor, nil, {
				LabelText = React.createElement(Foundation.Text, {
					tag = "text-title-large size-full align-x-left text-align-x-left",
					Text = v21.copyLink
				})
			}),
			Content = React.createElement(Popover.Content, {
				tags = "size-full auto-y",
				hasArrow = false,
				align = PopoverAlign.End
			}, {
				CopiedPopoverText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-small text-align-x-center padding-medium",
					Text = v21.copied
				})
			})
		})
	})
end
