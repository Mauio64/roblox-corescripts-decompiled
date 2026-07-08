local Parent = script:FindFirstAncestor("InGameAssetReporting").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local UIBlox = require(Parent.UIBlox)
local withLocalization = require(Parent.Localization).withLocalization
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1
}

local function InGameAssetReportErrorModal(t2: {[any]: any}) -- line: 24
	-- upvalues: React (copy), ReactOtter (copy), t1 (copy), withLocalization (copy), InteractiveAlert (copy), ButtonType (copy)
	local v11, v12 = React.useState(true)
	local v13, v14 = ReactOtter.useAnimatedBinding(1, function() -- line: 27
		-- upvalues: v11 (copy), t2 (copy)
		if not v11 then
			t2.onBack()
		end
	end)
	local v15 = React.useMemo(function() -- line: 34
		-- upvalues: v11 (copy)
		if v11 then
			return 0
		end

		return 1
	end, { v11 })

	React.useEffect(function() -- line: 38
		-- upvalues: v14 (copy), ReactOtter (copy), v15 (copy), t1 (copy)
		v14(ReactOtter.spring(v15, t1))
	end, { v15 })

	local v16 = React.useCallback(function() -- line: 42
		-- upvalues: v12 (copy)
		v12(false)
	end, { v12 })

	return withLocalization({
		errorTitle = "Feature.ReportAbuse.Heading.SelectInSceneErrorTitle",
		errorDescription = "Feature.ReportAbuse.Label.SelectInSceneErrorDescription",
		errorBack = "Feature.ReportAbuse.Action.ErrorModalGoBack"
	})(function(p1) -- line: 50
		-- upvalues: React (copy), v13 (copy), v16 (copy), InteractiveAlert (copy), t2 (copy), ButtonType (copy)
		return React.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = v13:map(function(n1: number) -- line: 54
				return n1 + 0.3
			end),
			BackgroundColor3 = Color3.fromHex("#000000"),
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[React.Event.Activated] = v16,
			ZIndex = 10
		}, {
			Alert = React.createElement(InteractiveAlert, {
				screenSize = t2.screenSize,
				title = p1.errorTitle,
				bodyText = p1.errorDescription,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = v13:map(function(p2) -- line: 70
					return UDim2.new(0.5, 0, 0.5, 0):Lerp(UDim2.new(0.5, 0, -0.5, 0), p2)
				end),
				buttonStackInfo = {
					buttons = {{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = v16,
							text = p1.errorBack
						}
					}}
				}
			})
		})
	end)
end

return InGameAssetReportErrorModal
