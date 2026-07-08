local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Constants = require(RobloxGui.Modules.TopBar.Constants)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Dark = UIBlox.App.Style.Constants.ThemeName.Dark
local Promise = require(CorePackages.Packages.Promise)
local SelfViewTooltipFTUX = require(script.Parent.SelfViewTooltipFTUX)

return function(p1) -- line: 15
	-- upvalues: CoreGui (copy), Constants (copy), Roact (copy), AppStyleProvider (copy), Dark (copy), SelfViewTooltipFTUX (copy), Promise (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "SelfViewTooltipOnCloseGui"
	ScreenGui.DisplayOrder = -1
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local v13 = Constants.useDisplayScaleState(Constants.TopBarButtonHeight)
	local v14 = Constants.useDisplayScaleState(Constants.ScreenSideOffset)
	local v15 = Roact.createElement(AppStyleProvider, {
		style = {
			themeName = Dark
		}
	}, {
		frame = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			Visible = false,
			Position = UDim2.fromOffset(v14, -v13),
			Size = UDim2.fromOffset(v13, v13)
		}, {
			tooltip = Roact.createElement(SelfViewTooltipFTUX, {
				fallbackText = p1.fallbackText,
				translationKey = p1.translationKey,
				tooltipLifetime = p1.tooltipLifetime
			})
		})
	})
	local v16 = Roact.mount(v15, ScreenGui, "SelfViewTooltipOnClose")

	Promise.delay(p1.tooltipLifetime + 5):andThen(function() -- line: 46
		-- upvalues: Roact (copy), v16 (copy)
		pcall(function() -- line: 47
			-- upvalues: Roact (copy), v16 (copy)
			Roact.unmount(v16)
		end)
	end)
end
