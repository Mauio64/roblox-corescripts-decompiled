local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")

local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local mapCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/mapCallCard")
local parseCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/parseCallCard")
local RingingIndicator = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/RingingIndicator")
local useCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/useCallCard")

local udim = UDim.new(0, 20)

local function CallCard(props)
	local v5 = useTokens()
	local v8 = mapCallCard((useCallCard((React.useMemo(function()
		return parseCallCard.parseMessageCard({
			call_id = props.call_id,
			duration_seconds = props.duration_seconds,
			enable_join = props.enable_join,
			is_initiator = props.is_initiator,
			status = props.status
		})
	end, {
		props.call_id,
		props.duration_seconds,
		props.enable_join,
		props.is_initiator,
		props.status
	})))))
	local createElement = React.createElement
	local v10 = {
		Size = UDim2.fromOffset(200, 0),
		cornerRadius = udim,
		onActivated = v8.onActivated,
		tag = "row align-y-center gap-small auto-y padding-x-medium padding-y-small bg-shift-400",
		testId = props.testId
	}
	local v11 = {
		Icon = React.createElement(icon, {
			LayoutOrder = 1,
			name = v8.icon,
			size = iconSize.Large,
			style = v5.Color.Content.Muted
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v14 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = v8.title,
			tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis"
		}),
		Status = 0
	}
	local v15

	if v8.description ~= nil then
		local createElement3 = React.createElement

		local v18 = {
			Description = React.createElement(text, {
				LayoutOrder = 1,
				Text = v8.description,
				tag = "shrink auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default"
			}),
			Ringing = 0
		}

		local v19 = if v8.isRinging then React.createElement(RingingIndicator, {
			LayoutOrder = 2
		}) else nil
		v18.Ringing = v19
		v15 = createElement3(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-y-center gap-xsmall size-full-0 auto-y"
			},
			v18
		)
	end

	v14.Status = v15
	v11.Content = createElement2(view, { LayoutOrder = 2, tag = "col fill auto-y" }, v14)
	return createElement(view, v10, v11)
end

return CallCard
