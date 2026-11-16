local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

local module = require("@luauforge/bundled/edC")

local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module3 = require("@luauforge/bundled/fyp")

local extended = Roact.PureComponent:extend("AuthBackAndContinueButton")

extended.defaultProps = { size = UDim2.new(1, 0, 0, 36) }

function extended:init()
	function self.backButtonOnActivated()
		local navigateBack = self.props.navigateBack
		local backButtonIsDisabled = self.props.backButtonIsDisabled
		local backButtonIsLoading = self.props.backButtonIsLoading

		if not (backButtonIsDisabled or backButtonIsLoading) then
			navigateBack()
		end
	end
end

function extended.render(p2)
	local size = p2.props.size
	local position = p2.props.position
	local anchorPoint = p2.props.anchorPoint
	local layoutOrder = p2.props.layoutOrder

	local backButtonIsDisabled = p2.props.backButtonIsDisabled
	local backButtonIsLoading = p2.props.backButtonIsLoading

	local nextButtonText = p2.props.nextButtonText
	local nextButtonIsDisabled = p2.props.nextButtonIsDisabled
	local nextButtonIsLoading = p2.props.nextButtonIsLoading
	local nextButtonOnActivated = p2.props.nextButtonOnActivated

	return module({ backButtonText = "CommonUI.Controls.Action.Back" })(function(p3)
		local createElement = Roact.createElement

		local createElement2 = Roact.createElement

		local v9 = if module3 then buttonVariant.Standard else buttonVariant.Subtle
		return createElement("Frame", {
			Size = size,
			Position = position,
			AnchorPoint = anchorPoint,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1
		}, {
			BackButton = createElement2(button, {
				testId = "--auth-button-back",
				variant = v9,
				size = buttonSize.Medium,
				text = p3.backButtonText,
				isDisabled = backButtonIsDisabled,
				isLoading = backButtonIsLoading,
				onActivated = p2.backButtonOnActivated,
				width = UDim.new(0.5, -6)
			}),
			NextButton = Roact.createElement(button, {
				testId = "--auth-button-next",
				variant = buttonVariant.SubEmphasis,
				size = buttonSize.Medium,
				text = nextButtonText,
				isDisabled = nextButtonIsDisabled,
				isLoading = nextButtonIsLoading,
				onActivated = nextButtonOnActivated,
				width = UDim.new(0.5, -6),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0)
			})
		})
	end)
end

return (RoactRodux.connect(nil, function(callback)
	return {
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.back()
			end

			return callback(RobloxAppToastsRodux())
		end
	}
end)(extended))
