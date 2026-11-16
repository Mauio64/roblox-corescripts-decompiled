local module = require("@luauforge/deferred/egU")
local module2 = require("@luauforge/deferred/eUS")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module4 = require("@luauforge/deferred/eha")
require("@luauforge/deferred/eVX")

local v5 = {
	Verified = module2.Icon.CircleCheck,
	Pending = module2.Icon.Clock,
	Classmates = module2.Icon.ThreePeople
}

local function WaitlistTimelineStage(props)
	local v6 = useTokens()
	local stage = props.stage

	local v9 = if stage.usesCount then {
		stage.titleKey,
		count = props.remainingCount
	} else stage.titleKey
	local v10 = useLocalization({ title = v9, body = stage.bodyKey })

	local emphasis = v6.Color.Stroke.Emphasis

	local createElement = module.createElement
	local v12 = {
		LayoutOrder = props.LayoutOrder,
		tag = "row flex-y-fill gap-medium size-full-0 auto-y padding-x-medium",
		sizeConstraint = {
			MinSize = Vector2.new(0, v6.Size.Size_1500)
		}
	}

	local createElement2 = module.createElement
	local v14 = {
		LayoutOrder = 1,
		Size = UDim2.new(0, v6.Size.Size_600, 0, 0),
		tag = "col align-x-center gap-xsmall"
	}

	local createElement3 = module.createElement
	local v16 = {
		LayoutOrder = 1,
		Size = UDim2.new(0, v6.Size.Size_50, 0, 0),
		tag = "grow",
		backgroundStyle = 0
	}

	local v17 = if not props.isFirst then emphasis else nil
	v16.backgroundStyle = v17
	local children2 = {
		TopConnector = createElement3(view, v16),
		IconWrapper = module.createElement(icon, {
			LayoutOrder = 2,
			name = v5[stage.icon],
			size = iconSize.Medium,
			style = v6.Color.Content.Emphasis
		}),
		BottomConnector = 0
	}

	local createElement4 = module.createElement
	local v19 = {
		LayoutOrder = 3,
		Size = UDim2.new(0, v6.Size.Size_50, 0, 0),
		tag = "grow",
		backgroundStyle = 0
	}

	if props.isLast then
		emphasis = nil
	end

	v19.backgroundStyle = emphasis
	children2.BottomConnector = createElement4(view, v19)
	local children = {
		Indicator = createElement2(view, v14, children2),
		Content = 0
	}

	local createElement5 = module.createElement

	local v22 = {
		Title = module.createElement(text, {
			LayoutOrder = 1,
			Text = v10.title,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Body = 0
	}

	local v23 = if stage.bodyKey ~= nil then module.createElement(text, {
		LayoutOrder = 2,
		Text = v10.body,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
	}) else nil
	v22.Body = v23
	children.Content = createElement5(
		view,
		{
			LayoutOrder = 2,
			tag = "col align-x-left align-y-center grow gap-xxsmall size-0-0 auto-y padding-y-small"
		},
		v22
	)
	local element = createElement(view, v12, children)

	if stage.dimmed then
		return module.createElement("CanvasGroup", {
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			GroupTransparency = module4.Waitlist.DIMMED_GROUP_TRANSPARENCY
		}, { Row = element })
	end

	return element
end

return WaitlistTimelineStage
