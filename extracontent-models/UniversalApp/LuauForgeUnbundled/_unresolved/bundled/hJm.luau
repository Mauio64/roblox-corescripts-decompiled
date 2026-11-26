local module = require("@luauforge/bundled/hHr")
local module2 = require("@luauforge/bundled/hHu")

local icon = module.Icon
local text = module.Text
local view = module.View
local avatarSize = module.Enums.AvatarSize
local iconName = module.Enums.IconName
local iconSize = module.Enums.IconSize
local iconVariant = module.Enums.IconVariant
local useTokens = module.Hooks.useTokens

local function VerifiedBadge(p2)
	local v5 = useTokens()
	return module2.createElement(view, { LayoutOrder = p2.LayoutOrder, tag = "auto-xy" }, {
		Backplate = module2.createElement(icon, {
			name = iconName.VerifiedBackplate,
			style = v5.Color.System.Emphasis,
			size = iconSize.Small,
			ZIndex = 1
		}),
		Check = module2.createElement(icon, {
			name = iconName.VerifiedCheck,
			size = iconSize.Small,
			variant = iconVariant.Filled,
			style = v5.Color.Extended.White.White_100,
			ZIndex = 2
		})
	})
end

local function SendRobuxUserRow(props)
	local v5 = useTokens()
	local userId = props.userId
	local onActivated = props.onActivated

	local v6 = module2.useCallback(function()
		onActivated(userId)
	end, { onActivated, userId })

	local createElement = module2.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = v6,
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-small padding-y-small radius-medium",
		testId = `send-robux-user-row-{userId}`
	}
	local v9 = {
		Avatar = module2.createElement(module.Avatar, {
			userId = tonumber(userId) or 0,
			size = avatarSize.Large,
			backgroundStyle = v5.Color.Shift.Shift_200,
			LayoutOrder = 1
		}),
		Names = 0
	}

	local createElement2 = module2.createElement

	local createElement3 = module2.createElement

	local v15 = {
		DisplayName = module2.createElement(text, {
			LayoutOrder = 1,
			Text = props.displayName,
			tag = "shrink auto-xy text-title-medium text-align-x-left text-truncate-end content-emphasis"
		}),
		Verified = 0,
		RobloxPlus = 0
	}

	local v16 = if props.hasVerifiedBadge then module2.createElement(VerifiedBadge, {
		LayoutOrder = 2
	}) else nil
	v15.Verified = v16

	local v17 = if props.isRobloxPlus then module2.createElement(icon, {
		LayoutOrder = 3,
		name = iconName.RobloxPlus,
		size = iconSize.Small,
		style = v5.Color.Content.Default,
		testId = `send-robux-user-row-plus-{userId}`
	}) else nil
	v15.RobloxPlus = v17
	local v12 = {
		NameRow = createElement3(
			view,
			{
				LayoutOrder = 1,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y"
			},
			v15
		),
		Username = 0
	}

	local v18 = if props.username then module2.createElement(text, {
		LayoutOrder = 2,
		Text = `@{props.username}`,
		tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default"
	}) else nil
	v12.Username = v18
	v9.Names = createElement2(view, { LayoutOrder = 2, tag = "col fill auto-y" }, v12)
	return createElement(view, v8, v9)
end

return module2.memo(SendRobuxUserRow)
