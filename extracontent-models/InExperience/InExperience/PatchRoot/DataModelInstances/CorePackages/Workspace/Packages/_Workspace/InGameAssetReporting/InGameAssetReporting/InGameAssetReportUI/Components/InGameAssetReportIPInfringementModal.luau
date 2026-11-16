local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View

local useLocalization = Localization.Hooks.useLocalization

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local v = { stiffness = 400, damping = 40, mass = 1 }

local function InGameAssetReportIPInfringementModal(props)
	local state, setState = React.useState(true)
	local v2 = useLocalization({
		yourReportCode = "Feature.ReportAbuse.Label.YourReportCode",
		ipInfringementModalText = "Feature.ReportAbuse.Description.IpInfringementReportModal",
		reportCompleteClose = "Feature.ReportAbuse.Action.Close",
		thankYouIpInfringementReport = "Feature.ReportAbuse.Title.SelectInSceneIpReport"
	})

	local v3, v4 = ReactOtter.useAnimatedBinding(1, function()
		if not state then
			props.onClose()
		end
	end)

	local v5 = React.useMemo(function(): number
		return if state then 0 else 1
	end, { state })

	React.useEffect(function()
		v4(ReactOtter.spring(v5, v))
	end, { v5 })

	local onActivated = React.useCallback(function()
		setState(false)
	end, { setState })

	local middleContent = React.useCallback(function()
		return React.createElement(View, { tag = "auto-xy col gap-small align-x-center" }, {
			text1 = React.createElement(Text, {
				Text = v2.yourReportCode,
				tag = "auto-xy text-title-medium content-default text-align-x-center",
				LayoutOrder = 1
			}),
			text2 = React.createElement(Text, {
				Text = props.reportCode,
				tag = "auto-xy text-heading-medium content-emphasis text-align-x-center",
				LayoutOrder = 2
			}),
			text3 = React.createElement(Text, {
				Text = v2.ipInfringementModalText,
				tag = "auto-xy text-body-medium content-default text-align-x-center text-wrap",
				RichText = true,
				LayoutOrder = 3
			})
		})
	end, { props.reportCode })

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v3:map(function(p: number)
			return p + 0.3
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
			screenSize = props.screenSize,
			title = v2.thankYouIpInfringementReport,
			richText = true,
			middleContent = middleContent,
			anchorPoint = Vector2.new(0.5, 0.5),
			position = v3:map(function(p)
				return UDim2.new(0.5, 0, 0.5, 0):Lerp(UDim2.new(0.5, 0, -0.5, 0), p)
			end),
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = { onActivated = onActivated, text = v2.reportCompleteClose }
					}
				}
			}
		})
	})
end

return InGameAssetReportIPInfringementModal
