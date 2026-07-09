local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local uDim = UDim.new(0, 12)

local function FilterSection(t1: {[any]: any}) -- line: 24
	-- upvalues: useStyle (copy), React (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), uDim (copy), Dash (copy)
	local v10 = useStyle()
	local Theme = v10.Theme
	local Font = v10.Font

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.Size,
		AutomaticSize = if not GetFFlagAXEnableInventorySortsAndFilters() then nil else t1.AutomaticSize
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = uDim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = uDim,
			PaddingBottom = uDim,
			PaddingLeft = uDim,
			PaddingRight = uDim
		}),
		Title = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = Font.Header1.Font,
			TextSize = Font.Header1.RelativeSize * Font.BaseSize,
			Text = t1.title,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency
		}),
		Content = React.createElement("Frame", {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			Size = t1.contentSize,
			AutomaticSize = if not GetFFlagAXEnableInventorySortsAndFilters() then nil else t1.AutomaticSize,
			BackgroundTransparency = Theme.PlaceHolder.Transparency,
			BackgroundColor3 = Theme.PlaceHolder.Color
		}, Dash.join({
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		}, t1.children))
	})
end

return FilterSection
