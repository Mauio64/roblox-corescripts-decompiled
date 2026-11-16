local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local Orientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens

local isSplitPaneEducationalTourGuiObjectVisible = require(script.Parent.isSplitPaneEducationalTourGuiObjectVisible)
local useTrackedRect = require(script.Parent.useTrackedRect)
local getSplitPaneEducationalTourStore = require(script.Parent.Parent.Stores.getSplitPaneEducationalTourStore)

local function isVisibleAndLaidOut(p)
	if not isSplitPaneEducationalTourGuiObjectVisible(p) then
		return false
	end

	local parent2 = p.Parent
	local v

	if parent2 == nil then
		return false
	end

	v = parent2:IsA("GuiObject")

	if v then
		if parent2.AbsoluteSize.X > 0 then
			return parent2.AbsoluteSize.Y > 0
		end

		return false
	end

	return v
end

local function SplitPaneEducationalTourCollapsedControl()
	local state, setState = React.useState(nil)
	local v = useTrackedRect(state)
	local splitPaneEducationalTourStore = getSplitPaneEducationalTourStore(false)

	React.useLayoutEffect(function()
		if state == nil then
			return
		end

		return function()
			if splitPaneEducationalTourStore.getCollapsedExpandButtonInstance(false) == state then
				splitPaneEducationalTourStore.setCollapsedExpandButtonRect(nil)
				splitPaneEducationalTourStore.setCollapsedExpandButtonInstance(nil)
			end
		end
	end, { state, splitPaneEducationalTourStore })

	React.useLayoutEffect(function()
		if state == nil then
			return
		end

		local v2 = state
		local v3

		if isSplitPaneEducationalTourGuiObjectVisible(v2) then
			local parent2 = v2.Parent

			if parent2 == nil then
				v3 = false
			else
				v3 = parent2:IsA("GuiObject")

				if v3 then
					if parent2.AbsoluteSize.X > 0 then
						v3 = parent2.AbsoluteSize.Y > 0
					else
						v3 = false
					end
				end
			end
		else
			v3 = false
		end

		if v3 and v ~= nil then
			splitPaneEducationalTourStore.setCollapsedExpandButtonInstance(state)
			splitPaneEducationalTourStore.setCollapsedExpandButtonRect(v)
		elseif splitPaneEducationalTourStore.getCollapsedExpandButtonInstance(false) == state then
			splitPaneEducationalTourStore.setCollapsedExpandButtonRect(nil)
		end
	end, { state, v, splitPaneEducationalTourStore })

	local v2 = useTokens()
	local actionUtility = v2.Color.ActionUtility

	return React.createElement(View, {
		tag = "row align-y-center size-0-full auto-x padding-left-xsmall"
	}, {
		DividerContainer = React.createElement(View, { tag = "size-0-600 auto-x", LayoutOrder = 1 }, {
			Divider = React.createElement(Divider, { orientation = Orientation.Vertical })
		}),
		ButtonSlot = React.createElement(View, {
			tag = "size-1000-1000 padding-left-xsmall",
			LayoutOrder = 2
		}, {
			Button = React.createElement(View, {
				ref = setState,
				tag = "row align-x-center align-y-center",
				Size = UDim2.fromOffset(v2.Size.Size_1000, v2.Size.Size_1000),
				padding = UDim.new(0, v2.Size.Size_250),
				cornerRadius = UDim.new(0, v2.Radius.Medium),
				backgroundStyle = actionUtility.Background,
				stroke = actionUtility.Border ~= nil and {
					Color = actionUtility.Border.Color3,
					Transparency = actionUtility.Border.Transparency
				} or nil,
				testId = "split-pane-educational-tour--expand"
			}, {
				Icon = React.createElement(Icon, {
					name = IconName.RectangleRightPaneChevronLeft,
					size = v2.Size.Size_600,
					style = actionUtility.Foreground,
					LayoutOrder = 1
				})
			})
		})
	})
end

return SplitPaneEducationalTourCollapsedControl
