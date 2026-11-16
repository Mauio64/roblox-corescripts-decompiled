local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local text = Foundation.Text
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function BuildTabStrip(props)
	local v5 = useTokens()
	local testId = props.testId or "BuildTabStrip"
	local onActivated = props.onActivated

	local count = #props.tabs

	local children = {}
	local v6 = nil

	for k, tab in props.tabs do
		if tab.id == props.activeTabId then
			v6 = k - 1
		end

		local id = tab.id
		children[tostring(id)] = React.createElement(view, {
			LayoutOrder = k,
			tag = "fill size-0-1000 auto-y",
			selection = {
				Selectable = tab.isDisabled ~= true
			},
			isDisabled = tab.isDisabled,
			onActivated = function()
				if onActivated ~= nil then
					onActivated(id)
				end
			end,
			testId = `{testId}.Tab.{id}`
		}, {
			Text = React.createElement(
				view,
				{ tag = "size-full-full padding-x-medium padding-y-small" },
				{
					Label = React.createElement(text, {
						Text = tab.text,
						tag = "position-center-center anchor-center-center auto-xy text-label-medium content-emphasis"
					})
				}
			)
		})
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = "size-full-0 auto-y",
		testId = testId
	}

	local v9 = {
		Divider = React.createElement(view, {
			Size = UDim2.new(1, 0, 0, v5.Stroke.Thick),
			tag = "position-bottom-left anchor-bottom-left",
			backgroundStyle = v5.Color.Stroke.Default,
			testId = `{testId}.Divider`
		}),
		Tabs = React.createElement(view, {
			ZIndex = 2,
			tag = "row size-full-0 auto-y"
		}, children),
		Underline = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		Visible = v6 ~= nil and count > 0,
		Size = UDim2.new(1 / math.max(count, 1), 0, 0, v5.Stroke.Thick),
		Position = 0,
		ZIndex = 3,
		tag = "anchor-bottom-left bg-system-contrast",
		testId = 0
	}
	local v13

	if props.activeOffset then
		v13 = props.activeOffset:map(function(p2)
			return UDim2.fromScale(p2 / math.max(count, 1), 1)
		end)
	else
		v13 = UDim2.fromScale((v6 or 0) / math.max(count, 1), 1)
	end

	v11.Position = v13

	v11.testId = `{testId}.Underline`
	v9.Underline = createElement2(view, v11)
	return createElement(view, v8, v9)
end

return BuildTabStrip
