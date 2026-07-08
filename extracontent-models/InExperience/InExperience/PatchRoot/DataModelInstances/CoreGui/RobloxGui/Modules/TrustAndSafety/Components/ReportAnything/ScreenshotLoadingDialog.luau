local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function ScreenshotLoadingDialog(t1: {[any]: any}) -- line: 11
	-- upvalues: React (copy), ButtonStack (copy), ButtonType (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Buttons = React.createElement(ButtonStack, {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					text = "This is page 1. Click to go next",
					onActivated = function() -- line: 21
						-- upvalues: t1 (copy)
						t1.onNextPage()
					end
				}
			}}
		})
	})
end

return ScreenshotLoadingDialog
