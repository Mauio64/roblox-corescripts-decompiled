local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local parent = InGameAssetReporting.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local Constants = require(InGameAssetReporting.InGameAssetReportUI.Resources.Constants)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local IpErrorCodes = Constants.IpErrorCodes

local v = {
	titleKey = "Feature.ReportAbuse.Heading.IpNoReportableContent",
	descriptionKey = "Feature.ReportAbuse.Description.IpNoReportableContent",
	showReportExperience = true
}

local v2 = {
	titleKey = "InGame.CommonUI.Title.Error",
	descriptionKey = "Feature.ReportAbuse.Description.IpGenericError",
	showReportExperience = false
}

local v3 = {
	[IpErrorCodes.ClientNoAssetsExtracted] = v,
	[IpErrorCodes.NoEligibleContents] = v,
	[IpErrorCodes.Unknown] = v2
}

local v4 = { stiffness = 400, damping = 40, mass = 1 }

local function InGameAssetIPInfringementErrorModal(data)
	local state, setState = React.useState(true)

	local v5, v6 = ReactOtter.useAnimatedBinding(1, function()
		if not state then
			data.onBack()
		end
	end)

	local v7 = React.useMemo(function(): number
		return if state then 0 else 1
	end, { state })

	React.useEffect(function()
		v6(ReactOtter.spring(v7, v4))
	end, { v7 })

	local onActivated = React.useCallback(function()
		setState(false)
	end, { setState })
	local v8

	if data.errorCode and v3[data.errorCode] then
		v8 = v3[data.errorCode]
	else
		v8 = v2
	end

	return withLocalization({
		errorBack = "Feature.ReportAbuse.Action.ErrorModalGoBack",
		reportExperience = "Feature.ReportAbuse.Action.IpReportExperience",
		title = v8.titleKey,
		description = v8.descriptionKey
	})(function(props)
		local buttons = {}

		if v8.showReportExperience and data.onReportExperience then
			table.insert(buttons, {
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = data.onReportExperience,
					text = props.reportExperience,
					isLoading = data.isReportExperienceLoading,
					isDisabled = data.isReportExperienceLoading
				}
			})

			table.insert(buttons, {
				buttonType = ButtonType.Secondary,
				props = { onActivated = onActivated, text = props.errorBack }
			})
		else
			table.insert(buttons, {
				buttonType = ButtonType.PrimarySystem,
				props = { onActivated = onActivated, text = props.errorBack }
			})
		end

		return React.createElement("TextButton", {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = v5:map(function(p: number)
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
				screenSize = data.screenSize,
				title = props.title,
				bodyText = props.description,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = v5:map(function(p)
					return UDim2.new(0.5, 0, 0.5, 0):Lerp(UDim2.new(0.5, 0, -0.5, 0), p)
				end),
				buttonStackInfo = { buttons = buttons }
			})
		})
	end)
end

return React.memo(InGameAssetIPInfringementErrorModal)
