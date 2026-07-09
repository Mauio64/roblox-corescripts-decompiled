local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(Modules.LuaApp.Constants)
local getScreenBottomInset = require(Modules.LuaApp.getScreenBottomInset)

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useStyle (copy), getScreenBottomInset (copy), React (copy), Constants (copy), Loading (copy), IconSize (copy)
	local screenSize = t1.screenSize
	local Theme = useStyle().Theme
	local globalGuiInset = t1.globalGuiInset
	local v15 = getScreenBottomInset()
	local uDim2 = UDim2.fromOffset(0, globalGuiInset.top)
	local uDim2_2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v15)

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = Constants.DisplayOrder.AntiAddictionPrompt
	}, {
		OverlayFrame = React.createElement("ImageButton", {
			AutoButtonColor = false,
			ImageTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency
		}, {
			Overlay = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Position = uDim2,
				Size = uDim2_2
			}, {
				Content = React.createElement(Loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					size = IconSize.Large
				})
			})
		})
	})
end
