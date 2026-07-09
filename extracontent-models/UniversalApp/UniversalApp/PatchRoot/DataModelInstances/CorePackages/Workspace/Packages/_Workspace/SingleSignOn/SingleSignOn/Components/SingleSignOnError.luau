local Parent = script:FindFirstAncestor("SingleSignOn").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppLogging = require(Parent.RoactServiceTags).AppLogging
local TelemetryConfigs = require(Parent.AuthAnalytics).TelemetryConfigs
local useNavigation = require(Parent.Navigation).useNavigation
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Progress = Foundation.Progress
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local useDesignTokens = require(Parent.Style).useDesignTokens
local ThirdPartySwitchAccountComponent = require(Parent.AuthCommon).Components.ThirdPartySwitchAccountComponent
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local v21 = game:DefineFastInt("SingleSignOnErrorAntiSpamDelaySeconds", 5)

local function SingleSignOnError(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), useRoactService (copy), AppLogging (copy), useDesignTokens (copy), React (copy), useNavigation (copy), v21 (copy), ThirdPartyUserService (copy), TelemetryConfigs (copy), View (copy), FoundationText (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), AppPage (copy), ThirdPartySwitchAccountComponent (copy)
	local v24 = useLocalization({
		message = "CommonUI.Features.Labels.ServerCommunicationError",
		retry = "CommonUI.Features.Labels.Retry"
	})
	local v25 = useRoactService(AppLogging)
	local v26 = useDesignTokens()
	local v27, v28 = React.useState(false)
	local v29 = useNavigation()
	local v30 = v21
	local v31 = if t1.isAccountSwitchingSupported == nil then ThirdPartyUserService and ThirdPartyUserService:IsAccountSwitchingSupported() else t1.isAccountSwitchingSupported
	local v32 = if t1.thirdPartyUserName == nil then ThirdPartyUserService and ThirdPartyUserService:GetUserPlatformName() else t1.thirdPartyUserName

	React.useEffect(function() -- line: 53
		-- upvalues: v30 (copy), v28 (copy)
		if v30 > 0 then
			task.delay(v30, function() -- line: 55
				-- upvalues: v28 (copy)
				v28(true)
			end)

			return
		end

		v28(true)
	end, {
		v28,
		v30
	})
	React.useEffect(function() -- line: 63
		-- upvalues: v25 (copy), TelemetryConfigs (copy)
		v25:logEventOnce("single_sign_on_error_did_mount")
		v25:logRobloxTelemetryCounter(TelemetryConfigs.SingleSignOnErrorMountTelemetryConfig, 1)
	end, { v25 })

	return React.createElement(View, {
		tag = "size-full"
	}, {
		Background = if not t1.renderBackground then nil else t1.renderBackground(),
		Content = React.createElement(View, {
			tag = "col anchor-center-center position-center-center gap-xxlarge align-x-center auto-y",
			Size = UDim2.fromOffset(v26.LuaApps.LandingPage.buttonWidth, 0)
		}, {
			ErrorMessage = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 text-align-x-center auto-y",
				Text = v24.message
			}),
			ActionContainer = React.createElement(View, {
				tag = "size-full-0 auto-xy",
				LayoutOrder = 2
			}, {
				ProgressIndicator = if v27 then nil else React.createElement(View, {
					tag = "col size-full auto-xy align-x-center align-y-center"
				}, {
					Progress = React.createElement(Progress, {
						shape = ProgressShape.Circle,
						size = ProgressSize.Large
					})
				}),
				ButtonContainer = React.createElement(View, {
					tag = "col size-full-0 auto-y gap-xxlarge"
				}, {
					LogInButton = React.createElement(Button, {
						LayoutOrder = 1,
						tag = "size-full-0 auto-y",
						isDisabled = not v27,
						variant = ButtonVariant.Standard,
						size = ButtonSize.Large,
						text = v24.retry,
						onActivated = function() -- line: 106
							-- upvalues: v25 (copy), TelemetryConfigs (copy), v29 (copy), AppPage (copy)
							v25:logEventOnce("single_sign_on_error_retry")
							v25:logRobloxTelemetryCounter(TelemetryConfigs.SingleSignOnErrorRetryButtonClickedConfig, 1)
							v29.replace(AppPage.SingleSignOnContainer)
						end,
						width = UDim.new(1, 0)
					}),
					ThirdPartySwitchAccountComponent = if not v31 then nil else React.createElement(ThirdPartySwitchAccountComponent, {
						layoutOrder = 2,
						dividerTextKey = "CommonUI.Features.Labels.With",
						isDisabled = not v27,
						thirdPartyUserName = v32
					})
				})
			})
		})
	})
end

return SingleSignOnError
