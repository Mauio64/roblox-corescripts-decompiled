local module = require("@luauforge/bundled/dJa")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local module3 = require("@luauforge/bundled/dJb")
local module4 = require("@luauforge/bundled/dJc")
local appPage = require("@luauforge/bundled/dJg").AppPage
local navigateDown = require("@luauforge/bundled/dJd").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/dJe").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dJf").NavigationCommands else nil

local useLocalization = require("@luauforge/bundled/dJt").Hooks.useLocalization

local module5 = require("@luauforge/bundled/dJB")
local module6 = require("@luauforge/bundled/dJu")
local module7 = require("@luauforge/bundled/dJv")
local PlainText = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/PlainText")
local module9 = require("@luauforge/bundled/dJA")
local module10 = require("@luauforge/bundled/dJF")
local module11 = require("@luauforge/bundled/dJI")
local module12 = require("@luauforge/bundled/dJh")
local module13 = require("@luauforge/bundled/dJK")
local module14 = require("@luauforge/bundled/dJM")
local module15 = require("@luauforge/bundled/dJO")
local module16 = require("@luauforge/bundled/dJP")
local getFormattedDeviceType = require("@luauforge/bundled/dJD").getFormattedDeviceType
local getFormattedRegionalLocation = require("@luauforge/bundled/dJD").getFormattedRegionalLocation
local getFormattedIPAddress = require("@luauforge/bundled/dJD").getFormattedIPAddress
local getFormattedDateTime = require("@luauforge/bundled/dJD").getFormattedDateTime
local module17 = require("@luauforge/bundled/dJQ")
local module18 = require("@luauforge/bundled/dJT")
local module19 = require("@luauforge/bundled/dJz")
local fFlagLuaAppDefaultHttpRetry = require("@luauforge/bundled/dJe").FFlagLuaAppDefaultHttpRetry

local DEFAULT_PADDING = require("@luauforge/bundled/dJE").DEFAULT_PADDING
local X_BUTTON_SIZE = require("@luauforge/bundled/dJE").X_BUTTON_SIZE

local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local function fn(city, subdivision, country, kind, challengeActionTypeTranslationKey)
	return {
		approve = "Authentication.TwoStepVerification.Action.Approve",
		deny = "Authentication.TwoStepVerification.Action.Deny",
		description = kind ~= module15.toRawValue(module15.DIALOG_TYPE_APPROVAL_2SV_GENERIC) and "Authentication.TwoStepVerification.Description.LoginToNewDevice" or (challengeActionTypeTranslationKey == nil or challengeActionTypeTranslationKey == "") and "Authentication.TwoStepVerification.Description.PostLoginActionConfirmation" or challengeActionTypeTranslationKey,
		deviceTypeLabel = "Authentication.TwoStepVerification.Label.DeviceTypeLabel",
		locationLabel = "Authentication.TwoStepVerification.Label.LocationLabel",
		ipAddressLabel = "Authentication.TwoStepVerification.Label.IPAddressLabel",
		dateTimeLabel = "Authentication.TwoStepVerification.Label.DateTimeLabel",
		unknownDeviceType = "Authentication.TwoStepVerification.Label.UnknownDevice",
		unknownLocation = "Authentication.TwoStepVerification.Label.UnknownLocation",
		unknownIPAddress = "Authentication.TwoStepVerification.Label.UnknownIPAddress",
		location = {
			"Authentication.TwoStepVerification.Label.Location",
			city = city,
			subdivision = subdivision,
			country = country
		},
		locationWithoutCity = {
			"Authentication.TwoStepVerification.Label.LocationWithoutCity",
			subdivision = subdivision,
			country = country
		},
		locationWithoutSubdivision = {
			"Authentication.TwoStepVerification.Label.LocationWithoutSubdivision",
			city = city,
			country = country
		},
		locationWithoutCountry = {
			"Authentication.TwoStepVerification.Label.LocationWithoutCountry",
			city = city,
			subdivision = subdivision
		},
		errorMessage = "Authentication.TwoStepVerification.Response.DefaultError",
		helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage"
	}
end

local config = module4.config
local v5 = {
	requestFunction = module4.requestFunctions.RequestInternal,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"ModalChallengeDialogApprovalHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

return module3.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end,
		finishDialog = function(p2, p3, p4)
			return callback(module11(p2, p3, p4))
		end
	}
end)(function(props)
	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(Vector2.new(0, 0))
	local state4, setState4 = module.useState(Vector2.new(0, 0))
	local state5, setState5 = module.useState(nil)

	local theme = useStyle().Theme
	local v8 = useLocalization(fn(
		props.dialogItem.origin.city,
		props.dialogItem.origin.subdivision,
		props.dialogItem.origin.country,
		props.dialogItem.type,
		props.dialogItem.challengeActionTypeTranslationKey
	))

	local function fn2(p2)
		if state3 ~= p2.AbsoluteSize then
			setState3(p2.AbsoluteSize)
		end
	end
	local function fn3(p2)
		if state4 ~= p2.AbsoluteSize then
			setState4(p2.AbsoluteSize)
		end
	end
	local function fn4(p2)
		if p2.CanvasSize.Y.Offset > p2.AbsoluteSize.Y then
			module18.loginInfoOverflowed()
		end
	end

	local function fn5(p2, p3, fn6, fn7)
		props.finishDialog(v7, p2, p3):andThen(function(p4)
			fn6()
		end):catch(function(p4)
			if p4 == module14.InconsistentStateTransition then
				props.navigateToModalState({
					modalState = module12.ChallengeDialogAlreadyCompleted
				})
			else
				fn7(p4)
			end
		end):await()
	end

	local function onActivated()
		setState5(nil)
		setState(true)
		local function fn6()
			module17.sendDialogActionSelectedEvent(
				props.dialogItem.type,
				props.dialogItem.typeInternalId,
				module16.toRawValue(module16.DIALOG_STATE_APPROVED)
			)

			setState(false)
			props.closeModal()
		end
		local function fn7(p2)
			setState(false)
			setState5(p2)
		end
		fn5(
			{
				type = props.dialogItem.type,
				typeInternalId = props.dialogItem.typeInternalId
			},
			module13.Approve,
			fn6,
			fn7
		)
	end

	local function onActivated2()
		setState5(nil)
		setState2(true)
		local function fn6()
			module17.sendDialogActionSelectedEvent(
				props.dialogItem.type,
				props.dialogItem.typeInternalId,
				module16.toRawValue(module16.DIALOG_STATE_DENIED)
			)

			setState2(false)
			props.navigateToModalState({ modalState = module12.ChallengeDialogDenied })
		end
		local function fn7(p2)
			setState2(false)
			setState5(p2)
		end
		fn5(
			{
				type = props.dialogItem.type,
				typeInternalId = props.dialogItem.typeInternalId
			},
			module13.Deny,
			fn6,
			fn7
		)
	end

	local function fn6()
		local function fn7()
			module17.sendDialogAbandonedEvent(props.dialogItem.type, props.dialogItem.typeInternalId)
			props.closeModal()
		end
		local function fn8(p2)
			props.closeModal()
		end
		fn5(
			{
				type = props.dialogItem.type,
				typeInternalId = props.dialogItem.typeInternalId
			},
			module13.Deny,
			fn7,
			fn8
		)
	end

	local function fn7(p2, p3, p4, p5)
		return module.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				LayoutOrder = p5
			},
			{
				ListLayout = module.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, DEFAULT_PADDING / 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Label = module.createElement(module7, {
					layoutOrder = 1,
					contentWidth = p4,
					size = module19.Footer,
					text = p2
				}),
				Info = module.createElement(module7, {
					layoutOrder = 2,
					contentWidth = p4,
					useEmphasis = true,
					text = p3
				})
			}
		)
	end

	return module.createElement(module5, {
		title = "",
		closeModal = fn6,
		makeBodyFragment = function(p2)
			return module.createElement(module.Fragment, nil, {
				Description = module.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					LayoutOrder = 1,
					[module.Change.AbsoluteSize] = fn2
				}, {
					ListLayout = module.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, DEFAULT_PADDING),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					ModalBodyText = module.createElement(module7, {
						layoutOrder = 1,
						contentWidth = p2 - 2 * X_BUTTON_SIZE,
						useBold = true,
						useEmphasis = true,
						size = module19.Header1,
						text = v8.description
					}),
					Lock = module.createElement(module6, { layoutOrder = 2 })
				}),
				LoginAttemptInfoScrollable = module.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -state3.Y - DEFAULT_PADDING),
					CanvasSize = UDim2.new(1, 0, 0, state4.Y),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarImageColor3 = theme.UIEmphasis.Color,
					LayoutOrder = 2,
					[module.Change.CanvasSize] = fn4
				}, {
					LoginAttemptInfoCanvas = module.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0),
						[module.Change.AbsoluteSize] = fn3
					}, {
						ListLayout = module.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, DEFAULT_PADDING / 2),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						ContentPadding = module.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, DEFAULT_PADDING / 2)
						}),
						DeviceType = fn7(
							v8.deviceTypeLabel,
							getFormattedDeviceType(
								props.dialogItem.origin.deviceType,
								props.dialogItem.origin.deviceOs,
								v8
							),
							p2,
							1
						),
						RegionalLocation = fn7(
							v8.locationLabel,
							getFormattedRegionalLocation(
								props.dialogItem.origin.city,
								props.dialogItem.origin.subdivision,
								props.dialogItem.origin.country,
								v8
							),
							p2,
							2
						),
						IPAddress = fn7(
							v8.ipAddressLabel,
							getFormattedIPAddress(props.dialogItem.origin.ipAddress, v8),
							p2,
							3
						),
						DateTimeInfo = fn7(
							v8.dateTimeLabel,
							getFormattedDateTime(props.dialogItem.origin.timestamp, v8),
							p2,
							4
						)
					})
				})
			})
		end,
		buttonConfig = module9({
			{
				isDisabled = state or state2,
				isLoading = state,
				onActivated = onActivated,
				text = v8.approve,
				type = buttonType.Secondary
			},
			{
				isDisabled = state2 or state,
				isLoading = state2,
				onActivated = onActivated2,
				text = v8.deny,
				type = buttonType.Secondary
			}
		}),
		footerContent = module10(function(p2)
			return module.createElement(module.Fragment, nil, {
				ErrorMessage = state5 and module.createElement(PlainText, {
					errorText = v8.errorMessage,
					contentWidth = p2,
					layoutOrder = 1
				}),
				SupportLink = module.createElement(module7, {
					BackgroundTransparency = 0,
					layoutOrder = 2,
					text = v8.helpMessage,
					contentWidth = p2,
					size = module19.Footer,
					onActivated = function()
						props.navigateToPage({
							name = appPage.GenericWebPage,
							detail = "https://en.help.roblox.com/hc/en-us/articles/212459863-Add-2-Step-Verification-to-Your-Account",
							extraProps = { title = "" }
						})
					end
				})
			})
		end)
	})
end)
