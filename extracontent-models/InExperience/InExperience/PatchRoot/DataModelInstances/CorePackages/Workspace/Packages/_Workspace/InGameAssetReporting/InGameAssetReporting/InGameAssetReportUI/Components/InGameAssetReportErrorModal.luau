local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local v = { stiffness = 400, damping = 40, mass = 1 }

local function InGameAssetReportErrorModal(p)
	local state, setState = React.useState(true)

	local v2, v3 = ReactOtter.useAnimatedBinding(1, function()
		if not state then
			p.onBack()
		end
	end)

	local v4 = React.useMemo(function(): number
		return if state then 0 else 1
	end, { state })

	React.useEffect(function()
		v3(ReactOtter.spring(v4, v))
	end, { v4 })

	local onActivated = React.useCallback(function()
		setState(false)
	end, { setState })

	return withLocalization({
		errorTitle = "Feature.ReportAbuse.Heading.SelectInSceneErrorTitle",
		errorDescription = "Feature.ReportAbuse.Label.SelectInSceneErrorDescription",
		errorBack = "Feature.ReportAbuse.Action.ErrorModalGoBack"
	})(function(props)
		return React.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = v2:map(function(p2: number)
				return p2 + 0.3
			end),
			BackgroundColor3 = Color3.fromHex("#000000"),
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[React.Event.Activated] = onActivated,
			ZIndex = 10
		}, {
			Alert = React.createElement(InteractiveAlert, {
				screenSize = p.screenSize,
				title = props.errorTitle,
				bodyText = props.errorDescription,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = v2:map(function(p2)
					return UDim2.new(0.5, 0, 0.5, 0):Lerp(UDim2.new(0.5, 0, -0.5, 0), p2)
				end),
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.PrimarySystem,
							props = { onActivated = onActivated, text = props.errorBack }
						}
					}
				}
			})
		})
	end)
end

return InGameAssetReportErrorModal
