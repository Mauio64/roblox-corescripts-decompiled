local Parent = script:FindFirstAncestor("InGameAssetReporting").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local UIBlox = require(Parent.UIBlox)
local Localization = require(Parent.Localization)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1
}

local function InGameAssetReportIPInfringementModal(t2: {[any]: any}) -- line: 31
	-- upvalues: React (copy), useLocalization (copy), ReactOtter (copy), t1 (copy), View (copy), FoundationText (copy), InteractiveAlert (copy), ButtonType (copy)
	local v15, v16 = React.useState(true)
	local v17 = useLocalization({
		yourReportCode = "Feature.ReportAbuse.Label.YourReportCode",
		ipInfringementModalText = "Feature.ReportAbuse.Description.IpInfringementReportModal",
		reportCompleteClose = "Feature.ReportAbuse.Action.Close",
		thankYouIpInfringementReport = "Feature.ReportAbuse.Title.SelectInSceneIpReport"
	})
	local v18, v19 = ReactOtter.useAnimatedBinding(1, function() -- line: 40
		-- upvalues: v15 (copy), t2 (copy)
		if not v15 then
			t2.onClose()
		end
	end)
	local v20 = React.useMemo(function() -- line: 47
		-- upvalues: v15 (copy)
		if v15 then
			return 0
		end

		return 1
	end, { v15 })

	React.useEffect(function() -- line: 51
		-- upvalues: v19 (copy), ReactOtter (copy), v20 (copy), t1 (copy)
		v19(ReactOtter.spring(v20, t1))
	end, { v20 })

	local v21 = React.useCallback(function() -- line: 55
		-- upvalues: v16 (copy)
		v16(false)
	end, { v16 })
	local v22 = React.useCallback(function() -- line: 59
		-- upvalues: React (copy), View (copy), FoundationText (copy), v17 (copy), t2 (copy)
		return React.createElement(View, {
			tag = "auto-xy col gap-small align-x-center"
		}, {
			text1 = React.createElement(FoundationText, {
				tag = "auto-xy text-title-medium content-default text-align-x-center",
				LayoutOrder = 1,
				Text = v17.yourReportCode
			}),
			text2 = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-medium content-emphasis text-align-x-center",
				LayoutOrder = 2,
				Text = t2.reportCode
			}),
			text3 = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium content-default text-align-x-center text-wrap",
				RichText = true,
				LayoutOrder = 3,
				Text = v17.ipInfringementModalText
			})
		})
	end, { t2.reportCode })

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v18:map(function(n1: number) -- line: 85
			return n1 + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = v21,
		ZIndex = 10
	}, {
		Alert = React.createElement(InteractiveAlert, {
			richText = true,
			screenSize = t2.screenSize,
			title = v17.thankYouIpInfringementReport,
			middleContent = v22,
			anchorPoint = Vector2.new(0.5, 0.5),
			position = v18:map(function(p1) -- line: 102
				return UDim2.new(0.5, 0, 0.5, 0):Lerp(UDim2.new(0.5, 0, -0.5, 0), p1)
			end),
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v21,
						text = v17.reportCompleteClose
					}
				}}
			}
		})
	})
end

return InGameAssetReportIPInfringementModal
