local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local useStyle = UIBlox.Core.Style.useStyle
local module = require("@luauforge/bundled/gXF")
local module2 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module3 = require("@luauforge/bundled/dzD")
local module4 = require("@luauforge/bundled/igI")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module5 = require("@luauforge/bundled/ikw")
local module6 = require("@luauforge/bundled/ikx")
local module7 = require("@luauforge/bundled/iky")
local module8 = require("@luauforge/bundled/ikz")

local defineFastInt = game:DefineFastInt("ParentalControlsScreentimeLockoutPollIntervalMs", 15000)

local fFlagEnableScreentimeMoreTimeOption = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableScreentimeMoreTimeOption

local fFlagEnableUserAccessServiceIntegration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableUserAccessServiceIntegration
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getUserAccessStore = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/gin").GetUserAccessStore else nil

local function getAddMoreTimeButtonStackProps(addMoreTimeText, p2, fn)
	local v5 = {
		buttonType = buttonType.Secondary,
		props = {
			isDisabled = false,
			onActivated = function()
				fn()
			end,
			text = addMoreTimeText
		}
	}
	local v6 = {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = { v5 }
	}

	if p2 then
		return v6
	end

	return nil
end

local v5 = RoactRodux.connect(not fFlagUseSignalsForUserAccess and function(p2, p3)
	return {
		userAccess = p2.UserAccess,
		restrictionDetail = p2.UserAccess and p2.UserAccess.restrictionDetail or nil
	}
end or nil, function(callback)
	return {
		fetchUserAccess = function(p2)
			callback(module(p2))
		end
	}
end)(fFlagEnableScreentimeMoreTimeOption and function(props)
	local v6 = useLocalization({
		CloseText = "CommonUI.Controls.Action.CloseRoblox",
		TitleText = "Feature.Screentime.Heading.ScreentimeLimitDialog",
		BodyText = "Feature.Screentime.Content.ScreentimeLimitDialog",
		AddMoreTimeText = "Feature.Screentime.Label.Options"
	})

	local screenSize = props.screenSize
	local theme = useStyle().Theme
	local globalGuiInset = props.globalGuiInset
	local v7 = module4()
	local udim = UDim2.fromOffset(0, globalGuiInset.top)
	local udim2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v7)
	local v8

	if fFlagEnableScreentimeMoreTimeOption then
		v8 = useAppPolicy(function(p2)
			return p2.getScreentimeMoreTimeOptionEnabled()
		end)
	else
		v8 = false
	end

	local v9 = {
		RestrictionModal = 1,
		AddTimeModal = 2,
		RetryModal = 3,
		ErrorModal = 4,
		UnlockedAndWaiting = 5
	}

	local state, setState = React.useState(1)
	local state2, setState2 = React.useState(0)

	React.useEffect(function()
		local v10 = setInterval(function()
			props.fetchUserAccess(props.networking)
		end, defineFastInt)

		return function()
			if v10 then
				clearInterval(v10)
			end
		end
	end, {})

	local element = React.createElement(interactiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v6.TitleText,
		bodyText = v6.BodyText,
		buttonStackInfo = getAddMoreTimeButtonStackProps(v6.AddMoreTimeText, v8, function(p2)
			setState(2)
		end)
	})

	if props.userAccess == nil then
		return nil
	end

	if state == 5 then
		return React.createElement(module7, {
			screenSize = screenSize,
			globalGuiInset = globalGuiInset
		})
	elseif state == 2 then
		return React.createElement(module5, {
			screenSize = screenSize,
			globalGuiInset = globalGuiInset,
			onClose = function()
				setState(1)
			end,
			onAddTime = function(p2)
				module8(props.networking, p2):andThen(function()
					setState(5)
				end):catch(function()
					setState2(p2)
					setState(3)
				end)
			end
		})
	elseif state == 3 then
		return React.createElement(module6, {
			screenSize = screenSize,
			globalGuiInset = globalGuiInset,
			onClose = function()
				setState(1)
			end,
			onRetry = function()
				module8(props.networking, state2):andThen(function()
					setState(5)
				end):catch(function()
					setState(4)
				end)
			end
		})
	elseif state == 4 then
		return React.createElement(module6, {
			screenSize = screenSize,
			globalGuiInset = globalGuiInset,
			onClose = function()
				setState(1)
			end
		})
	end

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = module3.DisplayOrder.AntiAddictionPrompt,
			IgnoreGuiInset = true
		},
		{
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 1,
				BackgroundColor3 = theme.Overlay.Color,
				BackgroundTransparency = theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Selectable = false
			}, {
				Overlay = React.createElement(
					"Frame",
					{
						Position = udim,
						Size = udim2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{ Content = element }
				)
			})
		}
	)
end or function(props)
	local v6 = useLocalization({
		CloseText = "CommonUI.Controls.Action.CloseRoblox",
		TitleText = "Feature.Screentime.Heading.ScreentimeLimitDialog",
		BodyText = "Feature.Screentime.Content.ScreentimeLimitDialog"
	})

	local screenSize = props.screenSize

	local v7 = useStyle()
	local theme = v7.Theme
	local font = v7.Font

	local globalGuiInset = props.globalGuiInset
	local v8 = module4()

	local udim = UDim2.fromOffset(0, globalGuiInset.top)
	local udim2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v8)

	React.useEffect(function()
		local v9 = setInterval(function()
			props.fetchUserAccess(props.networking)
		end, defineFastInt)

		return function()
			if v9 then
				clearInterval(v9)
			end
		end
	end, {})

	local element = React.createElement(
		partialPageModal,
		{ title = v6.TitleText, screenSize = screenSize },
		{
			Body = React.createElement(
				"Frame",
				{
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 60),
					BackgroundColor3 = theme.BackgroundUIDefault.Color,
					LayoutOrder = 1
				},
				{
					CustomInner = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = v6.BodyText,
						TextColor3 = theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextScaled = true,
						FontFace = normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font),
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
							MaxTextSize = font.BaseSize * font.Body.RelativeSize
						})
					})
				}
			)
		}
	)

	if props.userAccess == nil then
		return nil
	end

	return React.createElement(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = module3.DisplayOrder.AntiAddictionPrompt,
			IgnoreGuiInset = true
		},
		{
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 1,
				BackgroundColor3 = theme.Overlay.Color,
				BackgroundTransparency = theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Selectable = false
			}, {
				Overlay = React.createElement(
					"Frame",
					{
						Position = udim,
						Size = udim2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{ Content = element }
				)
			})
		}
	)
end)
local v6

if fFlagUseSignalsForUserAccess then
	local function ScreentimeRestrictionModalWithSignals(p2)
		local v7 = useSignalState(getUserAccessStore(false).getUserAccessRestrictionDetail)
		local v8 = React.useMemo(function()
			if fFlagEnableUserAccessServiceIntegration then
				return { restrictionDetail = v7 }
			end

			return nil
		end, { v7 })
		return React.createElement(
			v5,
			Cryo.Dictionary.union(p2, { userAccess = v8, restrictionDetail = v7 })
		)
	end

	v6 = React.memo(ScreentimeRestrictionModalWithSignals)
else
	v6 = v5
end

return (roactServices.connect({ networking = module2 })(v6))
