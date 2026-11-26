local module = require("@luauforge/bundled/hLs")
local useLocalization = require("@luauforge/bundled/hLt").Hooks.useLocalization
local useRoactService = require("@luauforge/bundled/hLu").useRoactService
local appLogging = require("@luauforge/bundled/hLv").AppLogging
local telemetryConfigs = require("@luauforge/bundled/hLw").TelemetryConfigs

local useNavigation = require("@luauforge/bundled/hLx").useNavigation
local appPage = require("@luauforge/bundled/hLy").AppPage

local module2 = require("@luauforge/bundled/hLz")
local text = module2.Text
local view = module2.View
local progress = module2.Progress
local progressShape = module2.Enums.ProgressShape
local progressSize = module2.Enums.ProgressSize
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local buttonSize = module2.Enums.ButtonSize
local useDesignTokens = require("@luauforge/bundled/hLA").useDesignTokens
local thirdPartySwitchAccountComponent = require("@luauforge/bundled/hLB").Components.ThirdPartySwitchAccountComponent
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local defineFastInt = game:DefineFastInt("SingleSignOnErrorAntiSpamDelaySeconds", 5)

local function SingleSignOnError(props)
	local v5 = useLocalization({
		message = "CommonUI.Features.Labels.ServerCommunicationError",
		retry = "CommonUI.Features.Labels.Retry"
	})

	local v6 = useRoactService(appLogging)
	local v7 = useDesignTokens()
	local state, setState = module.useState(false)
	local v8 = useNavigation()
	local v9 = defineFastInt
	local v10

	if props.isAccountSwitchingSupported == nil then
		v10 = ThirdPartyUserService and ThirdPartyUserService:IsAccountSwitchingSupported()
	else
		v10 = props.isAccountSwitchingSupported
	end

	local v11

	if props.thirdPartyUserName == nil then
		v11 = ThirdPartyUserService and ThirdPartyUserService:GetUserPlatformName()
	else
		v11 = props.thirdPartyUserName
	end

	module.useEffect(function()
		if v9 > 0 then
			task.delay(v9, function()
				setState(true)
			end)
		else
			setState(true)
		end
	end, { setState, v9 })

	module.useEffect(function()
		v6:logEventOnce("single_sign_on_error_did_mount")
		v6:logRobloxTelemetryCounter(telemetryConfigs.SingleSignOnErrorMountTelemetryConfig, 1)
	end, { v6 })

	local createElement = module.createElement

	local v15 = if props.renderBackground then props.renderBackground() else nil
	local createElement2 = module.createElement
	local v17 = {
		Size = UDim2.fromOffset(v7.LuaApps.LandingPage.buttonWidth, 0),
		tag = "col anchor-center-center position-center-center gap-xxlarge align-x-center auto-y"
	}

	local v18 = {
		ErrorMessage = module.createElement(text, {
			LayoutOrder = 1,
			tag = "size-full-0 text-align-x-center auto-y",
			Text = v5.message
		}),
		ActionContainer = 0
	}

	local createElement3 = module.createElement

	local v22 = if not state then module.createElement(
		view,
		{ tag = "col size-full auto-xy align-x-center align-y-center" },
		{
			Progress = module.createElement(progress, {
				shape = progressShape.Circle,
				size = progressSize.Large
			})
		}
	) else nil

	local createElement4 = module.createElement

	local v25 = {
		LogInButton = module.createElement(button, {
			LayoutOrder = 1,
			isDisabled = not state,
			variant = buttonVariant.Standard,
			size = buttonSize.Large,
			tag = "size-full-0 auto-y",
			text = v5.retry,
			onActivated = function()
				v6:logEventOnce("single_sign_on_error_retry")
				v6:logRobloxTelemetryCounter(telemetryConfigs.SingleSignOnErrorRetryButtonClickedConfig, 1)

				v8.replace(appPage.SingleSignOnContainer)
			end,
			width = UDim.new(1, 0)
		}),
		ThirdPartySwitchAccountComponent = 0
	}

	local v26 = if v10 then module.createElement(thirdPartySwitchAccountComponent, {
		layoutOrder = 2,
		isDisabled = not state,
		dividerTextKey = "CommonUI.Features.Labels.With",
		thirdPartyUserName = v11
	}) else nil
	v25.ThirdPartySwitchAccountComponent = v26
	v18.ActionContainer = createElement3(view, {
		tag = "size-full-0 auto-xy",
		LayoutOrder = 2
	}, {
		ProgressIndicator = v22,
		ButtonContainer = createElement4(view, {
			tag = "col size-full-0 auto-y gap-xxlarge"
		}, v25)
	})
	return createElement(view, { tag = "size-full" }, {
		Background = v15,
		Content = createElement2(view, v17, v18)
	})
end

return SingleSignOnError
