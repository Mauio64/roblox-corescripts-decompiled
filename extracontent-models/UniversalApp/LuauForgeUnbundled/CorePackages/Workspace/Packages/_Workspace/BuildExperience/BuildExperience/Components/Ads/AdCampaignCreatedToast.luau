local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")

local text = Foundation.Text
local view = Foundation.View

local function AdCampaignCreatedToast(props)
	local v5 = Foundation.Hooks.useOverlay()
	local v6 = Foundation.Hooks.useTokens()

	React.useEffect(function()
		local thread = task.delay(5, props.onClose)
		return function()
			task.cancel(thread)
		end
	end, { props.onClose })

	if v5 == nil then
		return nil
	end

	local testId = props.testId or "AdCampaignCreatedToast"
	local v7 = not (props.actionText == nil) and props.onActionActivated ~= nil

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v9 = {
		Position = UDim2.new(0.5, 0, 1, -v6.Padding.XLarge),
		ZIndex = 999,
		tag = "row align-y-center gap-medium anchor-bottom-center auto-xy padding-x-large padding-y-xsmall radius-medium bg-system-contrast",
		testId = testId
	}

	local v10 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "auto-xy padding-y-small text-body-medium content-inverse-emphasis"
		}),
		Action = 0
	}

	local v11 = if v7 then React.createElement(
		view,
		{
			LayoutOrder = 2,
			onActivated = props.onActionActivated,
			tag = "auto-xy",
			testId = `{testId}.Action`
		},
		{
			Label = React.createElement(text, {
				RichText = true,
				Text = `<u>{props.actionText}</u>`,
				tag = "auto-xy text-body-medium content-inverse-emphasis"
			})
		}
	) else nil
	v10.Action = v11
	return createPortal(createElement(view, v9, v10), v5)
end

return AdCampaignCreatedToast
