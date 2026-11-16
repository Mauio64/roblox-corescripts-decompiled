local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function BuildTabStrip(props)
	local v = useTokens()
	local testId = props.testId or "BuildTabStrip"
	local onActivated = props.onActivated

	local count = #props.tabs

	local children = {}
	local v2 = nil

	for k, tab in props.tabs do
		if tab.id == props.activeTabId then
			v2 = k - 1
		end

		local id = tab.id
		children[tostring(id)] = React.createElement(View, {
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
			Text = React.createElement(View, {
				tag = "size-full-full padding-x-medium padding-y-small"
			}, {
				Label = React.createElement(Text, {
					Text = tab.text,
					tag = "position-center-center anchor-center-center auto-xy text-label-medium content-emphasis"
				})
			})
		})
	end

	local createElement = React.createElement
	local v3 = { LayoutOrder = props.LayoutOrder, tag = "size-full-0 auto-y", testId = testId }

	local v4 = {
		Divider = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, v.Stroke.Thick),
			tag = "position-bottom-left anchor-bottom-left",
			backgroundStyle = v.Color.Stroke.Default,
			testId = `{testId}.Divider`
		}),
		Tabs = React.createElement(View, { ZIndex = 2, tag = "row size-full-0 auto-y" }, children),
		Underline = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		Visible = v2 ~= nil and count > 0,
		Size = UDim2.new(1 / math.max(count, 1), 0, 0, v.Stroke.Thick),
		Position = 0,
		ZIndex = 3,
		tag = "anchor-bottom-left bg-system-contrast",
		testId = 0
	}
	local position

	if props.activeOffset then
		position = props.activeOffset:map(function(p: number)
			return UDim2.fromScale(p / math.max(count, 1), 1)
		end)
	else
		position = UDim2.fromScale((v2 or 0) / math.max(count, 1), 1)
	end

	v5.Position = position

	v5.testId = `{testId}.Underline`
	v4.Underline = createElement2(View, v5)
	return createElement(View, v3, v4)
end

return BuildTabStrip
