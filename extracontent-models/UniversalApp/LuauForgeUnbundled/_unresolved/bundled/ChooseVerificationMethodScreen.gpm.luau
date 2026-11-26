local module = require("@luauforge/bundled/gpn")
local module2 = require("@luauforge/bundled/gnx")
local module3 = require("@luauforge/bundled/gnz")
local module4 = require("@luauforge/bundled/gow")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization

local fullscreenPageWithSafeArea = module4.FullscreenPageWithSafeArea
local useStyle = module3.Core.Style.useStyle
local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens

local module5 = require("@luauforge/bundled/goz")

local list = module5.List
local systemBanner = module5.SystemBanner
local alertVariant = module5.Enums.AlertVariant
local alertSeverity = module5.Enums.AlertSeverity
local iconName = module5.Enums.IconName
local useTokens = module5.Hooks.useTokens
local scrollView = module5.ScrollView
local visibility = module5.Enums.Visibility

local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount

local module6 = require("@luauforge/bundled/gnU")
local module7 = require("@luauforge/bundled/goc")
local module8 = require("@luauforge/bundled/goH")
local module9 = require("@luauforge/bundled/gou")
local module10 = require("@luauforge/bundled/gos")
local module11 = require("@luauforge/bundled/gop")
local module12 = require("@luauforge/bundled/goK")

local function ChooseVerificationMethodScreen(p2)
	local v5 = module2.useContext(module6)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()

	local state, setState = module2.useState(Vector2.new(0, 0))

	local param = p2.navigation.getParam("sendCodeRouteParams")

	local previousRecoveryMethod = param and param.previousRecoveryMethod or ""

	local v9 = useLocalization({
		chooseVerificationMethodHeadingText = "Authentication.AccountRecovery.Heading.ChooseVerificationMethod",
		previousMethodVerifiedText = {
			"Authentication.AccountRecovery.Label.PreviousContactMethodVerification",
			contactMethod = previousRecoveryMethod
		},
		phoneText = "Authentication.AccountRecovery.LabelPhone",
		emailText = "Authentication.AccountRecovery.LabelEmail",
		backupCodeText = "Authentication.AccountRecovery.Label.BackupCode",
		enterPhoneBackupCodeOrAnotherEmailText = "Authentication.AccountRecovery.Description.EnterPhoneBackupCodeOrAnotherEmail"
	})

	useClearFocusOnUnmount()

	local function fn(p3)
		if state ~= p3.AbsoluteSize then
			setState(p3.AbsoluteSize)
		end
	end

	local function onBackActivated()
		p2.navigation.goBack()
	end

	local function fn2(p3)
		if not param then
			p2.navigation.goBack()

			return
		end

		module11.sendRecoveryMethodInputSwitchEvent(
			v5.state.recoverySessionId,
			p3,
			"chooseVerificationMethod"
		)

		p2.navigation.navigate(
			module9.SendCodeScreen,
			module.Dictionary.join(param, { recoveryMethodInputTypeOverride = p3 })
		)
	end

	local createElement = module2.createElement
	local v11 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v12 = {
		UIPadding = module2.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module2.createElement
	local v14 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module2.createElement
	local v16 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0
	}
	local v17 = if module12() then Enum.HorizontalAlignment.Center else nil
	v16.HorizontalAlignment = v17
	v12.Wrapper = createElement2("Frame", v14, {
		UIListLayout = createElement3("UIListLayout", v16),
		Header = module2.createElement(module8, {
			LayoutOrder = 1,
			onBackActivated = onBackActivated,
			backButtonDisabled = false,
			recoveryHeadingText = v9.chooseVerificationMethodHeadingText,
			currentComponent = "chooseVerificationMethod",
			recoverySessionId = v5.state.recoverySessionId
		}),
		Content = module2.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				UISizeConstraint = module12() and module2.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(module7.ContentMaxWidth, 1e999)
				}),
				UIListLayout = module2.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = module2.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[module2.Change.AbsoluteSize] = fn
				}, {
					UIPadding = module2.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module2.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					HeadingToScrollSpacing = module2.createElement("Frame", {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v8.Size.Size_500),
						BackgroundTransparency = 1
					})
				}),
				ContentScrollView = module2.createElement(scrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -state.Y)
				}, {
					UIPadding = module2.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module2.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					VerifiedBanner = module2.createElement(systemBanner, {
						LayoutOrder = 1,
						severity = alertSeverity.Info,
						variant = alertVariant.Standard,
						title = v9.previousMethodVerifiedText,
						description = v9.enterPhoneBackupCodeOrAnotherEmailText
					}),
					BannerSpacing = module2.createElement("Frame", {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_400),
						BackgroundTransparency = 1
					}),
					MethodList = module2.createElement(list.Root, {
						LayoutOrder = 3,
						hasDivider = { hasDivider = true, isInset = false },
						isContained = { isContained = false, hasMargin = false }
					}, {
						PhoneItem = module2.createElement(list.Item, {
							leading = iconName.SmartphonePortrait,
							title = v9.phoneText,
							onActivated = {
								onActivated = function()
									fn2(module10.Phone)
								end
							},
							LayoutOrder = 1
						}),
						EmailItem = module2.createElement(list.Item, {
							leading = iconName.Envelope,
							title = v9.emailText,
							onActivated = {
								onActivated = function()
									fn2(module10.Email)
								end
							},
							LayoutOrder = 2
						}),
						BackupCodeItem = module2.createElement(list.Item, {
							leading = iconName.ClockSpinReverseDashed,
							title = v9.backupCodeText,
							onActivated = {
								onActivated = function()
									fn2(module10.BackupCode)
								end
							},
							LayoutOrder = 3
						})
					})
				})
			}
		)
	})
	return createElement(fullscreenPageWithSafeArea, v11, v12)
end

return ChooseVerificationMethodScreen
