local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useIsGamepad = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useIsGamepad
local RadioButtonGroup = require(Modules.AvatarExperience.Catalog.Components.Filters.RadioButtonGroup)
local CheckboxGroup = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.Filters.CheckboxGroup
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local uDim = UDim.new(0, 4)

local function getTotalHeight(n1: number) -- line: 44
	-- upvalues: uDim (copy)
	return n1 + 19 + uDim.Offset
end
local function FilterSubsection(t1: {[any]: any}) -- line: 48
	-- upvalues: useStyle (copy), useIsGamepad (copy), React (copy), uDim (copy), CheckboxGroup (copy), RadioButtonGroup (copy), Focusable (copy), FilterUtils (copy), Constants (copy)
	local v16 = useStyle()
	local Theme = v16.Theme
	local Font = v16.Font
	local v19 = useIsGamepad()
	local v20, v21 = React.useBinding(0)
	local v22 = if t1.selectionMode ~= "multiple" then RadioButtonGroup else CheckboxGroup

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v20:map(function(n2: number) -- line: 67
			-- upvalues: uDim (copy)
			return UDim2.new(1, 0, 0, n2 + 19 + uDim.Offset)
		end),
		LayoutOrder = t1.LayoutOrder,
		ref = t1.frameRef,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = uDim
		}),
		Title = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = Font.Header2.Font,
			TextSize = Font.Header2.RelativeSize * Font.BaseSize,
			Text = t1.title,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency
		}),
		RadioButtonGroupContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = v20:map(FilterUtils.mapHeightToSize)
		}, {
			RadioButtons = React.createElement(v22, {
				items = t1.items,
				itemHeight = Constants.SortAndFiltersRowHeight,
				selectedValue = t1.selectedValue,
				onActivated = function(p1) -- line: 101
					-- upvalues: t1 (copy)
					if t1.setSelectedValue then
						t1.setSelectedValue(p1)
					end
				end,
				useDefaultControlState = v19,
				onHeightChanged = function(n3: number) -- line: 57
					-- upvalues: v21 (copy), t1 (copy), uDim (copy)
					v21(n3)

					if t1.onHeightChanged then
						t1.onHeightChanged(n3 + 19 + uDim.Offset)
					end
				end
			})
		})
	})
end

return FilterSubsection
