local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local withLocalization = require(Modules.LuaApp.withLocalization)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local FFlagUseStandardFoundationButtonVariant = require(Modules.LuaApp.Flags.FFlagUseStandardFoundationButtonVariant)
local v14 = Roact.PureComponent:extend("AuthBackAndContinueButton")

v14.defaultProps = {
	size = UDim2.new(1, 0, 0, 36)
}

function v14.init(p1) -- line: 30
	function p1.backButtonOnActivated() -- line: 31
		-- upvalues: p1 (copy)
		local navigateBack = p1.props.navigateBack
		local backButtonIsDisabled = p1.props.backButtonIsDisabled
		local backButtonIsLoading = p1.props.backButtonIsLoading

		if not backButtonIsDisabled and not backButtonIsLoading then
			navigateBack()
		end
	end
end
function v14.render(p2) -- line: 42
	-- upvalues: withLocalization (copy), Roact (copy), Button (copy), FFlagUseStandardFoundationButtonVariant (copy), ButtonVariant (copy), ButtonSize (copy)
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

	return withLocalization({
		backButtonText = "CommonUI.Controls.Action.Back"
	})(function(p3) -- line: 58
		-- upvalues: Roact (copy), size (copy), position (copy), anchorPoint (copy), layoutOrder (copy), Button (copy), FFlagUseStandardFoundationButtonVariant (copy), ButtonVariant (copy), ButtonSize (copy), backButtonIsDisabled (copy), backButtonIsLoading (copy), p2 (copy), nextButtonText (copy), nextButtonIsDisabled (copy), nextButtonIsLoading (copy), nextButtonOnActivated (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = size,
			Position = position,
			AnchorPoint = anchorPoint,
			LayoutOrder = layoutOrder
		}, {
			BackButton = Roact.createElement(Button, {
				variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
				size = ButtonSize.Medium,
				text = p3.backButtonText,
				isDisabled = backButtonIsDisabled,
				isLoading = backButtonIsLoading,
				onActivated = p2.backButtonOnActivated,
				width = UDim.new(0.5, -6)
			}),
			NextButton = Roact.createElement(Button, {
				variant = ButtonVariant.SubEmphasis,
				size = ButtonSize.Medium,
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

return (RoactRodux.connect(nil, function(p4) -- line: 92
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateBack (copy)
	return {
		navigateBack = function() -- line: 94
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v12 (copy), p4 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				return v12.back()
			end

			return p4(NavigateBack())
		end
	}
end)(v14))
