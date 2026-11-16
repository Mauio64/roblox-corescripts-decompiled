local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local abbreviateCount = Localization.abbreviateCount
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Enums = require(ProfilePlatform.Common.Enums)

local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View

local SocialCountsItem = require(ProfilePlatform.Components.UserProfileHeader.SocialCountsItem)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local FFlagEnablePressingCommunityOwnerInPeekView = require(ProfilePlatform.Flags.FFlagEnablePressingCommunityOwnerInPeekView)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function CommunityProfileHeader(props)
	local v = useDispatch()

	local v2 = useLocalization({
		byOwner = {
			TextKeys.ByOwner,
			ownerName = props.ownerName
		},
		members = TextKeys.Members,
		followers = TextKeys.Followers,
		follower = TextKeys.Follower
	})

	local text = React.useMemo(function()
		if props.hasSocialModules then
			return v2.members
		end

		if props.membersCount == 1 then
			return v2.follower
		end

		return v2.followers
	end, { v2, props.membersCount, props.hasSocialModules })

	local fn = FFlagEnablePressingCommunityOwnerInPeekView and function()
		if props.ownerUserId then
			local v3 = {
				name = AppPage.ProfilePlatform,
				detail = props.ownerUserId,
				extraProps = { profileType = Enums.ProfileTypes.User }
			}

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v3))
			else
				v(NavigateDown(v3))
			end
		end
	end or nil

	local createElement = React.createElement
	local v3 = {
		layoutOrder = props.layoutOrder,
		backgroundTransparency = 1,
		size = UDim2.new(1, 0, 0, 0),
		useAutomaticSizing = true
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v4 = {
		CommunityThumbnail = React.createElement(Image, {
			LayoutOrder = 1,
			tag = "radius-medium self-center",
			Image = props.thumbnail,
			Size = UDim2.new(0, 80, 0, 80)
		}),
		Names = 0
	}

	local createElement4 = React.createElement
	local v5 = {
		LayoutOrder = 2,
		tag = "fill col size-full-0 auto-y align-y-center gap-small",
		Size = UDim2.new(1, 0, 0, 80)
	}
	local communityName

	if props.name then
		communityName = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "content-emphasis auto-xy text-heading-small text-wrap text-align-x-left",
			Text = props.name
		})
	end

	local ownerName

	if props.ownerName then
		local createElement5 = React.createElement
		local v6 = {
			LayoutOrder = 2,
			tag = "content-default auto-xy text-body-medium text-wrap text-align-x-left",
			Text = v2.byOwner,
			onActivated = 0
		}

		if not FFlagEnablePressingCommunityOwnerInPeekView then
			fn = nil
		end

		v6.onActivated = fn
		ownerName = createElement5(Text, v6)
	end

	v4.Names = createElement4(View, v5, { CommunityName = communityName, OwnerName = ownerName })
	return createElement(HorizontalPageMargin, v3, {
		Container = createElement2(View, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-xy gap-xsmall"
		}, {
			HeaderInformation = createElement3(
				View,
				{ LayoutOrder = 1, tag = "row gap-medium size-full-0 auto-xy" },
				v4
			),
			Counts = React.createElement(View, { LayoutOrder = 2, tag = "size-full-0 auto-xy" }, {
				MembersCount = React.createElement(SocialCountsItem, {
					layoutOrder = 1,
					text = text,
					count = abbreviateCount(props.membersCount),
					onActivated = function() end
				})
			})
		})
	})
end

return CommunityProfileHeader
