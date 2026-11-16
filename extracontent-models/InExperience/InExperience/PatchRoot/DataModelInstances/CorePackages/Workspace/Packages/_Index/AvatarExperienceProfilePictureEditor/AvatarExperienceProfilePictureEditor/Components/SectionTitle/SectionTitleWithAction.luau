local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

require(script.Parent.SectionTitle)
local SectionTitleLabel = require(script.Parent.SectionTitleLabel)

local function SectionTitleWithAction(props)
	local v = props.variant == "back"

	local createElement = React.createElement
	local v2 = { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v3 = {
		tag = "row align-y-center gap-xsmall auto-xy padding-y-xsmall",
		onActivated = props.onActivated
	}
	local v4 = {
		Label = React.createElement(SectionTitleLabel, {
			title = props.title,
			leadingIconName = props.leadingIconName,
			layoutOrder = v and 2 or 1
		}),
		Chevron = 0
	}

	local createElement3 = React.createElement
	local name

	if v then
		name = IconName.ChevronLargeLeft
	else
		name = IconName.ChevronLargeRight
	end

	v4.Chevron = createElement3(Icon, {
		name = name,
		size = IconSize.Medium,
		variant = IconVariant.Filled,
		LayoutOrder = v and 1 or 2
	})
	return createElement(View, v2, { TitleRow = createElement2(View, v3, v4) })
end

return SectionTitleWithAction
