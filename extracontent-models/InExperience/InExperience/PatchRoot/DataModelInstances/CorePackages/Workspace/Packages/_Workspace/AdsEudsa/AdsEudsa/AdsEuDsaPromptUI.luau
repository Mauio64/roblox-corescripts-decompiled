local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local UIBlox = require(ParentParent.UIBlox)
local Cryo = require(ParentParent.Cryo)
local CoreScriptsRootProvider = require(ParentParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(ParentParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local RobloxTranslator = require(ParentParent.RobloxTranslator)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useStyle = UIBlox.Core.Style.useStyle
local v13 = RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.WhyThisAd")
local v14 = RobloxTranslator:FormatByKey("CoreScripts.Ads.Action.Close")
local v15 = Roact.Component:extend("InteractiveAlert")

function v15.init(p1) -- line: 28
	p1.state = {
		animating = false,
		screenSize = Vector2.new(0, 0)
	}
end
function v15.renderWithStyle(p2, _) -- line: 35
	-- upvalues: ButtonType (copy), v14 (copy), Roact (copy), InteractiveAlert (copy), v13 (copy)
	local t1 = {
		isDefaultChild = true,
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = function() -- line: 39
				-- upvalues: p2 (copy)
				p2.props.handler:hidePrompt()
			end,
			text = v14
		}
	}

	return Roact.createFragment({
		Frame = Roact.createElement("Frame", {
			Selectable = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[Roact.Change.AbsoluteSize] = function(p4) -- line: 55
				-- upvalues: p2 (copy)
				p2:setState({
					screenSize = p4.AbsoluteSize
				})
			end
		}, {
			InteractiveAlert = Roact.createElement(InteractiveAlert, {
				screenSize = p2.state.screenSize,
				title = v13,
				bodyText = p2.props.bodyText,
				buttonStackInfo = {
					buttons = { t1 }
				}
			})
		})
	})
end
function v15.render(p5) -- line: 76
	return p5:renderWithStyle(p5.props.style)
end

local v16 = v15

return function(p6) -- line: 81
	-- upvalues: useStyle (copy), Cryo (copy), Roact (copy), CoreScriptsRootProvider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), v16 (copy)
	local v23 = useStyle()
	local v24 = Cryo.Dictionary.join(p6, {
		style = v23
	})

	return Roact.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = Roact.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			WrappedEuDsaPrompt = Roact.createElement(v16, v24)
		})
	})
end
