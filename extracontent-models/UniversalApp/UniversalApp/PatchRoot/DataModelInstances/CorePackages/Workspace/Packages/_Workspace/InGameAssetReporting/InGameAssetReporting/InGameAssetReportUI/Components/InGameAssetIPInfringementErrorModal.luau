local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local InGameAssetReportingParent = InGameAssetReporting.Parent
local React = require(InGameAssetReportingParent.React)
local ReactOtter = require(InGameAssetReportingParent.ReactOtter)
local UIBlox = require(InGameAssetReportingParent.UIBlox)
local withLocalization = require(InGameAssetReportingParent.Localization).withLocalization
local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local IpErrorCodes = Constants.IpErrorCodes
local t1 = {
	titleKey = "Feature.ReportAbuse.Heading.IpNoReportableContent",
	descriptionKey = "Feature.ReportAbuse.Description.IpNoReportableContent",
	showReportExperience = true
}
local t2 = {
	titleKey = "InGame.CommonUI.Title.Error",
	descriptionKey = "Feature.ReportAbuse.Description.IpGenericError",
	showReportExperience = false
}
local t3 = {
	[IpErrorCodes.ClientNoAssetsExtracted] = t1,
	[IpErrorCodes.NoEligibleContents] = t1,
	[IpErrorCodes.Unknown] = t2
}
local t4 = {
	stiffness = 400,
	damping = 40,
	mass = 1
}

local function InGameAssetIPInfringementErrorModal(t5: {[any]: any}) -- line: 49
	-- upvalues: React (copy), ReactOtter (copy), t4 (copy), t3 (copy), t2 (copy), withLocalization (copy), ButtonType (copy), InteractiveAlert (copy)
	local v17, v18 = React.useState(true)
	local v19, v20 = ReactOtter.useAnimatedBinding(1, function() -- line: 52
		-- upvalues: v17 (copy), t5 (copy)
		if not v17 then
			t5.onBack()
		end
	end)
	local v21 = React.useMemo(function() -- line: 59
		-- upvalues: v17 (copy)
		if v17 then
			return 0
		end

		return 1
	end, { v17 })

	React.useEffect(function() -- line: 63
		-- upvalues: v20 (copy), ReactOtter (copy), v21 (copy), t4 (copy)
		v20(ReactOtter.spring(v21, t4))
	end, { v21 })

	local v22 = React.useCallback(function() -- line: 67
		-- upvalues: v18 (copy)
		v18(false)
	end, { v18 })
	local v23 = if not t5.errorCode or not t3[t5.errorCode] then t2 else t3[t5.errorCode]

	return withLocalization({
		errorBack = "Feature.ReportAbuse.Action.ErrorModalGoBack",
		reportExperience = "Feature.ReportAbuse.Action.IpReportExperience",
		title = v23.titleKey,
		description = v23.descriptionKey
	})(function(p1) -- line: 80
		-- upvalues: v23 (copy), t5 (copy), ButtonType (copy), v22 (copy), React (copy), v19 (copy), InteractiveAlert (copy)
		local t6 = {}

		if v23.showReportExperience and t5.onReportExperience then
			table.insert(t6, {
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = t5.onReportExperience,
					text = p1.reportExperience,
					isLoading = t5.isReportExperienceLoading,
					isDisabled = t5.isReportExperienceLoading
				}
			})
			table.insert(t6, {
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = v22,
					text = p1.errorBack
				}
			})
		else
			table.insert(t6, {
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = v22,
					text = p1.errorBack
				}
			})
		end

		return React.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = v19:map(function(n1: number) -- line: 113
				return n1 + 0.3
			end),
			BackgroundColor3 = Color3.fromHex("#000000"),
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[React.Event.Activated] = v22,
			ZIndex = 10
		}, {
			Alert = React.createElement(InteractiveAlert, {
				screenSize = t5.screenSize,
				title = p1.title,
				bodyText = p1.description,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = v19:map(function(p2) -- line: 129
					return UDim2.new(0.5, 0, 0.5, 0):Lerp(UDim2.new(0.5, 0, -0.5, 0), p2)
				end),
				buttonStackInfo = {
					buttons = t6
				}
			})
		})
	end)
end

return React.memo(InGameAssetIPInfringementErrorModal)
