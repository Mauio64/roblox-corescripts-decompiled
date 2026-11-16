local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Foundation")

local view = Foundation.View
local divider = Foundation.Divider
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local orientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens

local isSplitPaneEducationalTourGuiObjectVisible = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/isSplitPaneEducationalTourGuiObjectVisible")
local useTrackedRect = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/useTrackedRect")
local getSplitPaneEducationalTourStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/getSplitPaneEducationalTourStore")

local function isVisibleAndLaidOut(p2)
	if not isSplitPaneEducationalTourGuiObjectVisible(p2) then
		return false
	end

	local parent = p2.Parent
	local v5

	if parent == nil then
		v5 = false
	else
		v5 = parent:IsA("GuiObject")

		if v5 then
			v5 = parent.AbsoluteSize.X > 0 and parent.AbsoluteSize.Y > 0
		end
	end

	return v5
end

local function SplitPaneEducationalTourCollapsedControl()
	local state, setState = React.useState(nil)
	local v5 = useTrackedRect(state)
	local v6 = getSplitPaneEducationalTourStore(false)

	React.useLayoutEffect(function()
		if state == nil then
			return
		end

		return function()
			if v6.getCollapsedExpandButtonInstance(false) == state then
				v6.setCollapsedExpandButtonRect(nil)
				v6.setCollapsedExpandButtonInstance(nil)
			end
		end
	end, { state, v6 })

	React.useLayoutEffect(function()
		if state == nil then
			return
		end

		local v7 = state
		local v8

		if isSplitPaneEducationalTourGuiObjectVisible(v7) then
			local parent = v7.Parent

			if parent == nil then
				v8 = false
			else
				v8 = parent:IsA("GuiObject")

				if v8 then
					v8 = parent.AbsoluteSize.X > 0 and parent.AbsoluteSize.Y > 0
				end
			end
		else
			v8 = false
		end

		if v8 and v5 ~= nil then
			v6.setCollapsedExpandButtonInstance(state)
			v6.setCollapsedExpandButtonRect(v5)
		elseif v6.getCollapsedExpandButtonInstance(false) == state then
			v6.setCollapsedExpandButtonRect(nil)
		end
	end, { state, v5, v6 })

	local v7 = useTokens()
	local actionUtility = v7.Color.ActionUtility

	return React.createElement(
		view,
		{ tag = "row align-y-center size-0-full auto-x padding-left-xsmall" },
		{
			DividerContainer = React.createElement(view, {
				tag = "size-0-600 auto-x",
				LayoutOrder = 1
			}, {
				Divider = React.createElement(divider, {
					orientation = orientation.Vertical
				})
			}),
			ButtonSlot = React.createElement(
				view,
				{ tag = "size-1000-1000 padding-left-xsmall", LayoutOrder = 2 },
				{
					Button = React.createElement(view, {
						ref = setState,
						tag = "row align-x-center align-y-center",
						Size = UDim2.fromOffset(v7.Size.Size_1000, v7.Size.Size_1000),
						padding = UDim.new(0, v7.Size.Size_250),
						cornerRadius = UDim.new(0, v7.Radius.Medium),
						backgroundStyle = actionUtility.Background,
						stroke = actionUtility.Border ~= nil and {
							Color = actionUtility.Border.Color3,
							Transparency = actionUtility.Border.Transparency
						} or nil,
						testId = "split-pane-educational-tour--expand"
					}, {
						Icon = React.createElement(icon, {
							name = iconName.RectangleRightPaneChevronLeft,
							size = v7.Size.Size_600,
							style = actionUtility.Foreground,
							LayoutOrder = 1
						})
					})
				}
			)
		}
	)
end

return SplitPaneEducationalTourCollapsedControl
