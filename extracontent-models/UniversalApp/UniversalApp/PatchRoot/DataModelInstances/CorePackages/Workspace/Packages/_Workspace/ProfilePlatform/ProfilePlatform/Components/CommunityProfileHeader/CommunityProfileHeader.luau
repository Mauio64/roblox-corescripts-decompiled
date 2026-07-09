local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local Foundation = require(ProfilePlatformParent.Foundation)
local React = require(ProfilePlatformParent.React)
local abbreviateCount = require(ProfilePlatformParent.Localization).abbreviateCount
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local Enums = require(ProfilePlatform.Common.Enums)
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local View = Foundation.View
local SocialCountsItem = require(ProfilePlatform.Components.UserProfileHeader.SocialCountsItem)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local FFlagEnablePressingCommunityOwnerInPeekView = require(ProfilePlatform.Flags.FFlagEnablePressingCommunityOwnerInPeekView)
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v20 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

local function CommunityProfileHeader(t1: {[any]: any}) -- line: 43
	-- upvalues: useDispatch (copy), useLocalization (copy), TextKeys (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), React (copy), FFlagEnablePressingCommunityOwnerInPeekView (copy), AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), HorizontalPageMargin (copy), View (copy), FoundationImage (copy), FoundationText (copy), SocialCountsItem (copy), abbreviateCount (copy)
	local v23 = useDispatch()
	local v24 = useLocalization({
		byOwner = {
			TextKeys.ByOwner,
			ownerName = t1.ownerName
		},
		members = TextKeys.Members,
		followers = TextKeys.Followers,
		follower = TextKeys.Follower
	})
	local v25 = nil

	if FFlagProfilePlatformUpdateUXForNonSocialCommunities then
		v25 = React.useMemo(function() -- line: 55
			-- upvalues: t1 (copy), v24 (copy)
			if t1.hasSocialModules then
				return v24.members
			end

			if t1.membersCount == 1 then
				return v24.follower
			end

			return v24.followers
		end, {
			v24,
			t1.membersCount,
			t1.hasSocialModules
		})
	end

	local v26 = if not FFlagEnablePressingCommunityOwnerInPeekView then nil else function() -- line: 68
		-- upvalues: t1 (copy), AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), v23 (copy), NavigateDown (copy)
		if t1.ownerUserId then
			local t2 = {
				name = AppPage.ProfilePlatform,
				detail = t1.ownerUserId,
				extraProps = {
					profileType = Enums.ProfileTypes.User
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v20.down(v20.fromLegacyPage(t2))

				return
			end

			v23(NavigateDown(t2))
		end
	end

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		layoutOrder = t1.layoutOrder,
		size = UDim2.new(1, 0, 0, 0)
	}, {
		Container = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-xy gap-xsmall"
		}, {
			HeaderInformation = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row gap-medium size-full-0 auto-xy"
			}, {
				CommunityThumbnail = React.createElement(FoundationImage, {
					LayoutOrder = 1,
					tag = "radius-medium self-center",
					Image = t1.thumbnail,
					Size = UDim2.new(0, 80, 0, 80)
				}),
				Names = React.createElement(View, {
					LayoutOrder = 2,
					tag = "fill col size-full-0 auto-y align-y-center gap-small",
					Size = UDim2.new(1, 0, 0, 80)
				}, {
					CommunityName = if not t1.name then nil else React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = "content-emphasis auto-xy text-heading-small text-wrap text-align-x-left",
						Text = t1.name
					}),
					OwnerName = if not t1.ownerName then nil else React.createElement(FoundationText, {
						LayoutOrder = 2,
						tag = "content-default auto-xy text-body-medium text-wrap text-align-x-left",
						Text = v24.byOwner,
						onActivated = if not FFlagEnablePressingCommunityOwnerInPeekView then nil else v26
					})
				})
			}),
			Counts = React.createElement(View, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-xy"
			}, {
				MembersCount = React.createElement(SocialCountsItem, {
					layoutOrder = 1,
					text = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then v24.members else v25,
					count = abbreviateCount(t1.membersCount),
					onActivated = function() -- line: 140
					end
				})
			})
		})
	})
end

return CommunityProfileHeader
