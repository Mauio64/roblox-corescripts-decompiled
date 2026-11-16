local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local VerifiedBadges = require(parent.VerifiedBadges)
local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize

local EmojiWrapper = VerifiedBadges.EmojiWrapper
local TextKeys = require(Groups.Common.TextKeys)
require(Groups.Common.Types)
local useMembersFollowersLabel = require(Groups.Hooks.useMembersFollowersLabel)
local useGroupsWrapperContext = require(Groups.Contexts.useGroupsWrapperContext)

local function GroupListItem(props)
	local v = useGroupsWrapperContext()
	local group = props.group

	if not group then
		return nil
	end

	local memberCount = group.memberCount or 0
	local v2

	if memberCount > 0 then
		v2 = memberCount
	end

	local truncatedCount = useAbbreviatedNumberLocalization(v2)

	local text = useMembersFollowersLabel({
		hasSocialModules = group.hasSocialModules or false,
		count = memberCount,
		truncatedCount = truncatedCount,
		capitalize = false
	})

	local v3 = useLocalization({ owned = TextKeys.LabelOwned })

	local id = group.id
	local image = React.useMemo(function()
		if group.thumbnail and group.thumbnail ~= "" then
			return group.thumbnail
		end

		return getRbxthumbWithTypeSizeAndOptions(tostring(id), Constants.RbxthumbTypes.GroupIcon, 150)
	end, { id, group.thumbnail })

	local onActivated = React.useCallback(function()
		if id then
			v.navigateTo.groupDetails(id)
		end
	end, { v.navigateTo.groupDetails, id })

	if not props.showMemberCount or group.memberCount == nil then
		text = nil
	end

	local roleChip = React.useMemo(function()
		if not props.showRank then
			return nil
		end

		if group.isOwner then
			return React.createElement(Chip, {
				text = v3.owned,
				size = ChipSize.Small,
				LayoutOrder = 3,
				isChecked = true,
				onActivated = function() end
			})
		end

		local name

		if group.role and group.role.name and group.role.name ~= "" then
			name = group.role.name
		end

		if name then
			return React.createElement(Chip, {
				text = name,
				size = ChipSize.Small,
				LayoutOrder = 3,
				onActivated = function() end
			})
		end

		return nil
	end, { props.showRank, group.isOwner, group.role, v3.owned })

	local createElement = React.createElement
	local v4 = {
		tag = "row size-full-0 auto-y gap-large align-y-center padding-small radius-medium",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
		onActivated = onActivated
	}

	local v5 = {
		Thumbnail = React.createElement(Image, {
			LayoutOrder = 1,
			Image = image,
			Size = UDim2.fromOffset(38, 38),
			tag = "radius-medium bg-surface-100"
		}),
		Details = 0,
		RoleChip = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local name

	if group.groupHasVerifiedBadge then
		name = React.createElement(EmojiWrapper, {
			emoji = VerifiedBadges.emoji.verified,
			layoutOrder = 1
		}, {
			NameText = React.createElement(Text, {
				Text = group.name or "",
				tag = "auto-xy text-align-x-left content-default text-title-medium text-no-wrap text-truncate-end padding-right-small"
			})
		})
	else
		name = React.createElement(Text, {
			Text = group.name or "",
			tag = "auto-xy text-align-x-left content-default text-title-medium text-no-wrap text-truncate-end",
			LayoutOrder = 1
		})
	end

	v5.Details = createElement2(View, { LayoutOrder = 2, tag = "col size-full-0 auto-y fill" }, {
		NameRow = createElement3(View, {
			tag = "row auto-y size-full-0 align-y-center",
			LayoutOrder = 1
		}, {
			Name = name
		}),
		Meta = text and React.createElement(Text, {
			Text = text,
			tag = "auto-xy text-align-x-left content-muted text-no-wrap text-truncate-end text-body-medium",
			LayoutOrder = 2
		}) or nil
	})

	v5.RoleChip = roleChip
	return createElement(View, v4, v5)
end

return React.memo(GroupListItem)
