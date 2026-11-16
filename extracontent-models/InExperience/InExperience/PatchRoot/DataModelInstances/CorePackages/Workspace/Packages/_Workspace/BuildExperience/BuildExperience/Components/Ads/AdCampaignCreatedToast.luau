local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local Text = Foundation.Text
local View = Foundation.View

local function AdCampaignCreatedToast(props)
	local v = Foundation.Hooks.useOverlay()
	local v2 = Foundation.Hooks.useTokens()

	React.useEffect(function()
		local thread = task.delay(5, props.onClose)
		return function()
			task.cancel(thread)
		end
	end, { props.onClose })

	if v == nil then
		return nil
	end

	local testId = props.testId or "AdCampaignCreatedToast"
	local v3

	if props.actionText == nil then
		v3 = false
	else
		v3 = props.onActionActivated ~= nil
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v4 = {
		Position = UDim2.new(0.5, 0, 1, -v2.Padding.XLarge),
		ZIndex = 999,
		tag = "row align-y-center gap-medium anchor-bottom-center auto-xy padding-x-large padding-y-xsmall radius-medium bg-system-contrast",
		testId = testId
	}

	local v5 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "auto-xy padding-y-small text-body-medium content-inverse-emphasis"
		}),
		Action = 0
	}
	local action

	if v3 then
		action = React.createElement(
			View,
			{
				LayoutOrder = 2,
				onActivated = props.onActionActivated,
				tag = "auto-xy",
				testId = `{testId}.Action`
			},
			{
				Label = React.createElement(Text, {
					RichText = true,
					Text = `<u>{props.actionText}</u>`,
					tag = "auto-xy text-body-medium content-inverse-emphasis"
				})
			}
		)
	end

	v5.Action = action
	return createPortal(createElement(View, v4, v5), v)
end

return AdCampaignCreatedToast
