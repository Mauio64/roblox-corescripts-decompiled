local parent = script.Parent.Parent
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Cryo = require(parent.Cryo)

local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local RobloxTranslator = require(parent.RobloxTranslator)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useStyle = UIBlox.Core.Style.useStyle

local formatByKey = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.WhyThisAd")
local formatByKey2 = RobloxTranslator:FormatByKey("CoreScripts.Ads.Action.Close")

local extended = Roact.Component:extend("InteractiveAlert")

function extended:init()
	self.state = { screenSize = Vector2.new(0, 0), animating = false }
end

function extended:renderWithStyle(_)
	local v = {
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = function()
				self.props.handler:hidePrompt()
			end,
			text = formatByKey2
		},
		isDefaultChild = true
	}

	return Roact.createFragment({
		Frame = Roact.createElement("Frame", {
			Selectable = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[Roact.Change.AbsoluteSize] = function(p)
				self:setState({ screenSize = p.AbsoluteSize })
			end
		}, {
			InteractiveAlert = Roact.createElement(InteractiveAlert, {
				screenSize = self.state.screenSize,
				title = formatByKey,
				bodyText = self.props.bodyText,
				buttonStackInfo = {
					buttons = { v }
				}
			})
		})
	})
end

function extended:render()
	return self:renderWithStyle(self.props.style)
end

return function(p)
	local style = useStyle()

	local joined = Cryo.Dictionary.join(p, { style = style })

	return Roact.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = Roact.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{
				WrappedEuDsaPrompt = Roact.createElement(extended, joined)
			}
		)
	})
end
