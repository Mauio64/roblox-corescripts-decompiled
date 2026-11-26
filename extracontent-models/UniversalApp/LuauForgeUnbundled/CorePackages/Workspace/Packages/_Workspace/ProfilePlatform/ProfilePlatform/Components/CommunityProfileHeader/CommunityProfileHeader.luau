local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local abbreviateCount = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").abbreviateCount
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

local SocialCountsItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialCountsItem")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local FFlagEnablePressingCommunityOwnerInPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnablePressingCommunityOwnerInPeekView")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local function CommunityProfileHeader(props)
	local v5 = useDispatch()

	local v6 = useLocalization({
		byOwner = {
			TextKeys.ByOwner,
			ownerName = props.ownerName
		},
		members = TextKeys.Members,
		followers = TextKeys.Followers,
		follower = TextKeys.Follower
	})

	local v7 = React.useMemo(function()
		if props.hasSocialModules then
			return v6.members
		end

		if props.membersCount == 1 then
			return v6.follower
		end

		return v6.followers
	end, { v6, props.membersCount, props.hasSocialModules })

	local fn = FFlagEnablePressingCommunityOwnerInPeekView and function()
		if props.ownerUserId then
			local v8 = {
				name = appPage.ProfilePlatform,
				detail = props.ownerUserId,
				extraProps = { profileType = Enums.ProfileTypes.User }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v8))
			else
				v5(navigateDown(v8))
			end
		end
	end or nil

	local createElement = React.createElement
	local v9 = {
		layoutOrder = props.layoutOrder,
		backgroundTransparency = 1,
		size = UDim2.new(1, 0, 0, 0),
		useAutomaticSizing = true
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v15 = {
		CommunityThumbnail = React.createElement(image, {
			LayoutOrder = 1,
			tag = "radius-medium self-center",
			Image = props.thumbnail,
			Size = UDim2.new(0, 80, 0, 80)
		}),
		Names = 0
	}

	local createElement4 = React.createElement
	local v17 = {
		LayoutOrder = 2,
		tag = "fill col size-full-0 auto-y align-y-center gap-small",
		Size = UDim2.new(1, 0, 0, 80)
	}

	local v19 = if props.name then React.createElement(text, {
		LayoutOrder = 1,
		tag = "content-emphasis auto-xy text-heading-small text-wrap text-align-x-left",
		Text = props.name
	}) else nil
	local v20

	if props.ownerName then
		local createElement5 = React.createElement
		local v22 = {
			LayoutOrder = 2,
			tag = "content-default auto-xy text-body-medium text-wrap text-align-x-left",
			Text = v6.byOwner,
			onActivated = 0
		}

		if not FFlagEnablePressingCommunityOwnerInPeekView then
			fn = nil
		end

		v22.onActivated = fn
		v20 = createElement5(text, v22)
	end

	v15.Names = createElement4(view, v17, { CommunityName = v19, OwnerName = v20 })
	return createElement(horizontalPageMargin, v9, {
		Container = createElement2(view, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-xy gap-xsmall"
		}, {
			HeaderInformation = createElement3(
				view,
				{ LayoutOrder = 1, tag = "row gap-medium size-full-0 auto-xy" },
				v15
			),
			Counts = React.createElement(view, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-xy"
			}, {
				MembersCount = React.createElement(SocialCountsItem, {
					layoutOrder = 1,
					text = v7,
					count = abbreviateCount(props.membersCount),
					onActivated = function() end
				})
			})
		})
	})
end

return CommunityProfileHeader
