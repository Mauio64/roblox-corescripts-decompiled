local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local ParentParent = script.Parent.Parent.Parent
local FTUXConstants = require(ParentParent.Resources.FTUXConstants)

require(ParentParent.Enums.PlatformEnum)

local function Header(t1: {[any]: any}) -- line: 18
	-- upvalues: useStyle (copy), FTUXConstants (copy), withLocalization (copy), React (copy), UIBlox (copy)
	local v10 = useStyle()
	local Theme = v10.Theme
	local Font = v10.Font
	local PanelConstants = FTUXConstants[t1.platform].PanelConstants
	local BackgroundContrastColor = Theme.BackgroundContrast.Color
	local HEADER_HEIGHT_RATIO = PanelConstants.HEADER_HEIGHT_RATIO
	local v16 = PanelConstants.CONTENT_PADDING / PanelConstants.SLIDESHOW_FRAME_WIDTH
	local v17 = 1 - 2 * v16

	return withLocalization({
		headerText = "CoreScripts.VRFTUX.Heading.Header"
	})(function(p1) -- line: 33
		-- upvalues: React (copy), BackgroundContrastColor (copy), HEADER_HEIGHT_RATIO (copy), v17 (copy), v16 (copy), UIBlox (copy), Font (copy), Theme (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 0,
			LayoutOrder = 1,
			BackgroundColor3 = BackgroundContrastColor,
			Size = UDim2.new(1, 0, HEADER_HEIGHT_RATIO, 0)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.26, 0)
			}),
			HeaderFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0)
			}, {
				Box = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(v17, 0, 1, 0),
					Position = UDim2.new(v16, 0, 0, 0)
				}, {
					HeaderText = React.createElement(UIBlox.App.Text.StyledTextLabel, {
						fluidSizing = true,
						text = p1.headerText,
						fontStyle = Font.Header1,
						colorStyle = Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Left,
						size = UDim2.new(1, 0, 1, 0),
						automaticSize = Enum.AutomaticSize.XY
					})
				})
			})
		})
	end)
end

return Header
