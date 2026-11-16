local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Localization")
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/VerifiedBadges")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local chip = Foundation.Chip
local chipSize = Foundation.Enums.ChipSize

local emojiWrapper = VerifiedBadges.EmojiWrapper
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/TextKeys")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")
local useMembersFollowersLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks/useMembersFollowersLabel")
local useGroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/useGroupsWrapperContext")

local function GroupListItem(props)
	local v5 = useGroupsWrapperContext()
	local group = props.group

	if not group then
		return nil
	end

	local memberCount = group.memberCount or 0
	local v7 = if memberCount > 0 then memberCount else nil
	local v8 = useAbbreviatedNumberLocalization(v7)

	local v9 = useMembersFollowersLabel({
		hasSocialModules = group.hasSocialModules or false,
		count = memberCount,
		truncatedCount = v8,
		capitalize = false
	})

	local v10 = useLocalization({ owned = TextKeys.LabelOwned })

	local id = group.id
	local v11 = React.useMemo(function()
		if group.thumbnail and group.thumbnail ~= "" then
			return group.thumbnail
		end

		return getRbxthumbWithTypeSizeAndOptions(tostring(id), constants.RbxthumbTypes.GroupIcon, 150)
	end, { id, group.thumbnail })

	local v12 = React.useCallback(function()
		if id then
			v5.navigateTo.groupDetails(id)
		end
	end, { v5.navigateTo.groupDetails, id })

	if not props.showMemberCount or group.memberCount == nil then
		v9 = nil
	end

	local v13 = React.useMemo(function()
		if not props.showRank then
			return nil
		end

		if group.isOwner then
			return React.createElement(chip, {
				text = v10.owned,
				size = chipSize.Small,
				LayoutOrder = 3,
				isChecked = true,
				onActivated = function() end
			})
		end

		local name = if group.role and group.role.name and group.role.name ~= "" then group.role.name else nil

		if name then
			return React.createElement(chip, {
				text = name,
				size = chipSize.Small,
				LayoutOrder = 3,
				onActivated = function() end
			})
		end

		return nil
	end, { props.showRank, group.isOwner, group.role, v10.owned })

	local createElement = React.createElement
	local v15 = {
		tag = "row size-full-0 auto-y gap-large align-y-center padding-small radius-medium",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
		onActivated = v12
	}

	local v16 = {
		Thumbnail = React.createElement(image, {
			LayoutOrder = 1,
			Image = v11,
			Size = UDim2.fromOffset(38, 38),
			tag = "radius-medium bg-surface-100"
		}),
		Details = 0,
		RoleChip = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v23 = if group.groupHasVerifiedBadge then React.createElement(
		emojiWrapper,
		{ emoji = VerifiedBadges.emoji.verified, layoutOrder = 1 },
		{
			NameText = React.createElement(text, {
				Text = group.name or "",
				tag = "auto-xy text-align-x-left content-default text-title-medium text-no-wrap text-truncate-end padding-right-small"
			})
		}
	) else React.createElement(text, {
		Text = group.name or "",
		tag = "auto-xy text-align-x-left content-default text-title-medium text-no-wrap text-truncate-end",
		LayoutOrder = 1
	})
	v16.Details = createElement2(view, {
		LayoutOrder = 2,
		tag = "col size-full-0 auto-y fill"
	}, {
		NameRow = createElement3(view, {
			tag = "row auto-y size-full-0 align-y-center",
			LayoutOrder = 1
		}, {
			Name = v23
		}),
		Meta = v9 and React.createElement(text, {
			Text = v9,
			tag = "auto-xy text-align-x-left content-muted text-no-wrap text-truncate-end text-body-medium",
			LayoutOrder = 2
		}) or nil
	})

	v16.RoleChip = v13
	return createElement(view, v15, v16)
end

return React.memo(GroupListItem)
