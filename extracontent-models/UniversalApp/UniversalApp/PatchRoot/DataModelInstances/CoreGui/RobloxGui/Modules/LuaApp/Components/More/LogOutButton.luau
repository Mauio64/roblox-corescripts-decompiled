local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local withLocalization = require(Modules.LuaApp.withLocalization)
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FFlagUseStandardFoundationButtonVariant = require(Modules.LuaApp.Flags.FFlagUseStandardFoundationButtonVariant)

return function(t1: {[any]: any}) -- line: 23
	-- upvalues: ArgCheck (copy), withLocalization (copy), Roact (copy), Button (copy), FFlagUseStandardFoundationButtonVariant (copy), ButtonVariant (copy), ButtonSize (copy)
	local onActivated = t1.onActivated

	ArgCheck.isType(onActivated, "function", "onActivated")

	return withLocalization({
		logOutText = "Application.Logout.Action.Logout"
	})(function(p1) -- line: 30
		-- upvalues: Roact (copy), Button (copy), FFlagUseStandardFoundationButtonVariant (copy), ButtonVariant (copy), ButtonSize (copy), onActivated (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(688, 1e999)
			}),
			LogOutButtonFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				LogOutButton = Roact.createElement(Button, {
					isLoading = false,
					isDisabled = false,
					variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
					size = ButtonSize.Large,
					text = p1.logOutText,
					onActivated = onActivated,
					width = UDim.new(1, 0)
				})
			})
		})
	end)
end
