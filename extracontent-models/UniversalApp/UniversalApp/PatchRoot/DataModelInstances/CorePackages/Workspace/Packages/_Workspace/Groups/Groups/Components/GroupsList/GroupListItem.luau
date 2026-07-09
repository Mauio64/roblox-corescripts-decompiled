local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local Foundation = require(GroupsParent.Foundation)
local Localization = require(GroupsParent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local VerifiedBadges = require(GroupsParent.VerifiedBadges)
local UserLib = require(GroupsParent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize
local EmojiWrapper = VerifiedBadges.EmojiWrapper
local TextKeys = require(Groups.Common.TextKeys)

require(Groups.Common.Types)

local useMembersFollowersLabel = require(Groups.Hooks.useMembersFollowersLabel)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)

local function GroupListItem(t1: {[any]: any}) -- line: 38
	-- upvalues: useGroupsWrapperContext (copy), useAbbreviatedNumberLocalization (copy), useMembersFollowersLabel (copy), useLocalization (copy), TextKeys (copy), React (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Chip (copy), ChipSize (copy), View (copy), FoundationImage (copy), EmojiWrapper (copy), VerifiedBadges (copy), FoundationText (copy)
	local v23 = useGroupsWrapperContext()
	local group = t1.group

	if not group then
		return nil
	end

	local v25 = group.memberCount or 0
	local v26 = useAbbreviatedNumberLocalization(if not (v25 > 0) then nil else v25)
	local v27 = useMembersFollowersLabel({
		capitalize = false,
		hasSocialModules = group.hasSocialModules or false,
		count = v25,
		truncatedCount = v26
	})
	local v28 = useLocalization({
		owned = TextKeys.LabelOwned
	})
	local id = group.id
	local v30 = React.useMemo(function() -- line: 62
		-- upvalues: group (copy), getRbxthumbWithTypeSizeAndOptions (copy), id (copy), Constants (copy)
		if group.thumbnail and group.thumbnail ~= "" then
			return group.thumbnail
		end

		return getRbxthumbWithTypeSizeAndOptions(tostring(id), Constants.RbxthumbTypes.GroupIcon, 150)
	end, {
		id,
		group.thumbnail
	})
	local v31 = React.useCallback(function() -- line: 73
		-- upvalues: id (copy), v23 (copy)
		if id then
			v23.navigateTo.groupDetails(id)
		end
	end, {
		v23.navigateTo.groupDetails,
		id
	})
	local v32 = if not t1.showMemberCount or group.memberCount == nil then nil else v27
	local v33 = React.useMemo(function() -- line: 81
		-- upvalues: t1 (copy), group (copy), React (copy), Chip (copy), v28 (copy), ChipSize (copy)
		if not t1.showRank then
			return nil
		end

		if group.isOwner then
			return React.createElement(Chip, {
				LayoutOrder = 3,
				isChecked = true,
				text = v28.owned,
				size = ChipSize.Small,
				onActivated = function() -- line: 92
				end
			})
		end

		local v34 = if not group.role or (not group.role.name or group.role.name == "") then nil else group.role.name

		if v34 then
			return React.createElement(Chip, {
				LayoutOrder = 3,
				text = v34,
				size = ChipSize.Small,
				onActivated = function() -- line: 101
				end
			})
		end

		return nil
	end, {
		t1.showRank,
		group.isOwner,
		group.role,
		v28.owned
	})

	return React.createElement(View, {
		tag = "row size-full-0 auto-y gap-large align-y-center padding-small radius-medium",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		onActivated = v31
	}, {
		Thumbnail = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			tag = "radius-medium bg-surface-100",
			Image = v30,
			Size = UDim2.fromOffset(38, 38)
		}),
		Details = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y fill"
		}, {
			NameRow = React.createElement(View, {
				tag = "row auto-y size-full-0 align-y-center",
				LayoutOrder = 1
			}, {
				Name = if not group.groupHasVerifiedBadge then React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left content-default text-title-medium text-no-wrap text-truncate-end",
					LayoutOrder = 1,
					Text = group.name or ""
				}) else React.createElement(EmojiWrapper, {
					layoutOrder = 1,
					emoji = VerifiedBadges.emoji.verified
				}, {
					NameText = React.createElement(FoundationText, {
						tag = "auto-xy text-align-x-left content-default text-title-medium text-no-wrap text-truncate-end padding-right-small",
						Text = group.name or ""
					})
				})
			}),
			Meta = v32 and React.createElement(FoundationText, {
				tag = "auto-xy text-align-x-left content-muted text-no-wrap text-truncate-end text-body-medium",
				LayoutOrder = 2,
				Text = v32
			}) or nil
		}),
		RoleChip = v33
	})
end

return React.memo(GroupListItem)
