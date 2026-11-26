local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/bundled/dzO")
local module2 = require("@luauforge/bundled/egZ")

local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

local module3 = require("@luauforge/bundled/fGg")

return function(p2)
	local onActivated = p2.onActivated

	module.isType(onActivated, "function", "onActivated")

	return module2({ logOutText = "Application.Logout.Action.Logout" })(function(p3)
		local createElement = Roact.createElement
		local v6 = {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}
		local v7 = {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(688, 1e999)
			}),
			LogOutButtonFrame = 0
		}

		local createElement2 = Roact.createElement
		local v9 = {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		}

		local createElement3 = Roact.createElement

		local v13 = if module3 then buttonVariant.Standard else buttonVariant.Subtle
		v7.LogOutButtonFrame = createElement2("Frame", v9, {
			LogOutButton = createElement3(button, {
				variant = v13,
				size = buttonSize.Large,
				text = p3.logOutText,
				onActivated = onActivated,
				isLoading = false,
				isDisabled = false,
				width = UDim.new(1, 0)
			})
		})
		return createElement("Frame", v6, v7)
	end)
end
