local SocialCards = script:FindFirstAncestor("SocialCards")
local parent = SocialCards.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local mapCallCard = require(SocialCards.Components.CallCard.mapCallCard)
local parseCallCard = require(SocialCards.Components.CallCard.parseCallCard)
local RingingIndicator = require(SocialCards.Components.CallCard.RingingIndicator)
local useCallCard = require(SocialCards.Components.CallCard.useCallCard)

local udim = UDim.new(0, 20)

local function CallCard(props)
	local v = useTokens()
	local v2 = mapCallCard((useCallCard((React.useMemo(function()
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
	local v3 = {
		Size = UDim2.fromOffset(200, 0),
		cornerRadius = udim,
		onActivated = v2.onActivated,
		tag = "row align-y-center gap-small auto-y padding-x-medium padding-y-small bg-shift-400",
		testId = props.testId
	}
	local v4 = {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = v2.icon,
			size = IconSize.Large,
			style = v.Color.Content.Muted
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v5 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v2.title,
			tag = "size-full-0 auto-y text-title-medium text-no-wrap text-align-x-left text-truncate-end content-emphasis"
		}),
		Status = 0
	}
	local status

	if v2.description ~= nil then
		local createElement3 = React.createElement

		local v6 = {
			Description = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v2.description,
				tag = "shrink auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-default"
			}),
			Ringing = 0
		}
		local ringing

		if v2.isRinging then
			ringing = React.createElement(RingingIndicator, { LayoutOrder = 2 })
		end

		v6.Ringing = ringing
		status = createElement3(View, {
			LayoutOrder = 2,
			tag = "row align-y-center gap-xsmall size-full-0 auto-y"
		}, v6)
	end

	v5.Status = status
	v4.Content = createElement2(View, { LayoutOrder = 2, tag = "col fill auto-y" }, v5)
	return createElement(View, v3, v4)
end

return CallCard
