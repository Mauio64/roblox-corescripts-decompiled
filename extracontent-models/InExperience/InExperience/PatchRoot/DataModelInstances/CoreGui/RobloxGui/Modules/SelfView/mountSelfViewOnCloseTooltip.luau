local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Constants = require(RobloxGui.Modules.TopBar.Constants)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Dark = ColorMode.Dark

local Promise = require(CorePackages.Packages.Promise)

local SelfViewTooltipFTUX = require(script.Parent.SelfViewTooltipFTUX)

return function(props)
	local selfViewTooltipOnCloseGui = Instance.new("ScreenGui")
	selfViewTooltipOnCloseGui.Name = "SelfViewTooltipOnCloseGui"
	selfViewTooltipOnCloseGui.DisplayOrder = -1
	selfViewTooltipOnCloseGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	selfViewTooltipOnCloseGui.Parent = CoreGui

	local v = Constants.useDisplayScaleState(Constants.TopBarButtonHeight)
	local v2 = Constants.useDisplayScaleState(Constants.ScreenSideOffset)

	local element = Roact.createElement(AppStyleProvider, {
		style = { themeName = Dark }
	}, {
		frame = Roact.createElement("Frame", {
			Position = UDim2.fromOffset(v2, -v),
			Size = UDim2.fromOffset(v, v),
			BackgroundTransparency = 0,
			Visible = false
		}, {
			tooltip = Roact.createElement(SelfViewTooltipFTUX, {
				fallbackText = props.fallbackText,
				translationKey = props.translationKey,
				tooltipLifetime = props.tooltipLifetime
			})
		})
	})

	local v3 = Roact.mount(element, selfViewTooltipOnCloseGui, "SelfViewTooltipOnClose")

	Promise.delay(props.tooltipLifetime + 5):andThen(function()
		pcall(function()
			Roact.unmount(v3)
		end)
	end)
end
