local module = require("@luauforge/bundled/fHU")
local module2 = require("@luauforge/bundled/fHV")
local useStyle = require("@luauforge/bundled/fHO").Core.Style.useStyle
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize

local fullscreenPageWithSafeArea = require("@luauforge/bundled/fHW").FullscreenPageWithSafeArea

local module3 = require("@luauforge/bundled/fHY")
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = module3.Utils.Constants
local useLocalization = require("@luauforge/bundled/fHZ").Hooks.useLocalization
local module4 = require("@luauforge/bundled/fHN")
local disclaimerLinks = require("@luauforge/bundled/fIf").Components.DisclaimerLinks
local disclaimerLinksVariant = require("@luauforge/bundled/fIf").Enums.DisclaimerLinksVariant
local module5 = require("@luauforge/bundled/fHT")
local module6 = require("@luauforge/bundled/fIp")

local fFlagEnableExternalIdentityAccountPickerButtons = require("@luauforge/bundled/fIg").FFlagEnableExternalIdentityAccountPickerButtons
local fFlagLandingAndAccountPickerSsoTelemetry = require("@luauforge/bundled/fIg").FFlagLandingAndAccountPickerSsoTelemetry
require("@luauforge/bundled/fIa")
require("@luauforge/bundled/fIq")

local module7 = require("@luauforge/bundled/fIm")
local eventStreamConstants = module7.EventStreamConstants
local authButtonClick = module7.Events.authButtonClick
local authButtonShown = module7.Events.authButtonShown
local authPageload = module7.Events.authPageload

local getAccountsListWithSignedOutAccounts = require("@luauforge/bundled/fIe").GetAccountsListWithSignedOutAccounts
local useRoactService = require("@luauforge/bundled/fIb").useRoactService
local roactNetworking = require("@luauforge/bundled/fIc").RoactNetworking
local defineFastFlag = game:DefineFastFlag("EnableAccountPickerListViewEvents", false)

local defineFastFlag2 = game:DefineFastFlag("FixAccountPickerListViewScrollAndAlignment", false)

return function(props)
	local state, setState = module.useState(false)
	local state2, setState2 = module.useState(props.accounts)
	local v5 = useRoactService(roactNetworking)

	local v6 = useStyle()
	local externalIdentityProviders = props.externalIdentityProviders or {}
	local v7 = fFlagEnableExternalIdentityAccountPickerButtons and props.isRedesign == true
	local v8 = v7 and "ssoRedesign" or "default"
	local v9 = v7 and 48 or 56
	local v10 = v7 and props.activeExternalIdentityProvider ~= nil
	local v11

	if v7 then
		v11 = #externalIdentityProviders > 0 and props.onExternalIdentityActivated ~= nil
	else
		v11 = v7
	end

	local v12 = useLocalization({
		allAccounts = "Authentication.AccountPicker.Label.AllAccounts",
		manage = "Authentication.AccountPicker.Label.Manage",
		signInAsAccount = "Authentication.AccountPicker.Button.SignIntoAnotherAccount",
		createAccount = "Authentication.AccountPicker.Button.CreateAccount",
		signedOut = "Authentication.AccountPicker.Label.SignedOut"
	})

	module.useEffect(function()
		if fFlagLandingAndAccountPickerSsoTelemetry then
			authPageload(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				v8,
				nil,
				eventStreamConstants.Context.AccountPickerLandingScreenListView
			)
		else
			authPageload(eventStreamConstants.Context.AccountPickerLandingScreenListView)
		end
	end, {})

	if fFlagEnableExternalIdentityAccountPickerButtons then
		local ref = module.useRef({})
		local v13 = table.find(externalIdentityProviders, "google") ~= nil
		local v14 = table.find(externalIdentityProviders, "apple") ~= nil
		module.useEffect(function()
			if not v11 then
				return
			end

			for k, externalIdentityProvider in externalIdentityProviders do
				if ref.current[externalIdentityProvider] then
					continue
				end

				ref.current[externalIdentityProvider] = true

				local accountPickerLandingScreenListView = eventStreamConstants.Context.AccountPickerLandingScreenListView
				local v16 = if externalIdentityProvider == "google" then eventStreamConstants.Button.GoogleSso else eventStreamConstants.Button.AppleSso
				authButtonShown(
					accountPickerLandingScreenListView,
					v16,
					"visible",
					eventStreamConstants.Context.AccountPickerLandingScreenListView
				)
			end
		end, { v11, v13, v14 })
	end

	module.useEffect(function()
		setState2(props.accounts)

		if defineFastFlag then
			authPageload(
				eventStreamConstants.Context.AccountPickerListViewAccountsDisplayed,
				tostring(#props.accounts),
				nil
			)
		end
	end, { props.accounts })

	local v13 = module.useCallback(function()
		getAccountsListWithSignedOutAccounts(v5, {
			isAuthenticated = false,
			filterUnauthenticatedSessionsForAccountPicker = true
		}):andThen(function(p2)
			props.setAccountPickerAccounts(p2)
		end)
	end, { v5, props.setAccountPickerAccounts })

	local function onActivated()
		if fFlagLandingAndAccountPickerSsoTelemetry then
			authButtonClick(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				eventStreamConstants.Button.AccountPickerManageAccountsOpened,
				v8,
				nil,
				nil,
				eventStreamConstants.Context.AccountPickerLandingScreenListView
			)
		else
			authButtonClick(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				eventStreamConstants.Button.AccountPickerManageAccountsOpened,
				nil,
				nil
			)
		end

		setState(true)
	end

	local function onActivated2()
		if fFlagLandingAndAccountPickerSsoTelemetry then
			authButtonClick(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				eventStreamConstants.Button.AccountPickerSignInAnotherAccount,
				v8,
				nil,
				nil,
				eventStreamConstants.Context.AccountPickerLandingScreenListView
			)
		else
			authButtonClick(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				eventStreamConstants.Button.AccountPickerSignInAnotherAccount,
				nil,
				nil
			)
		end

		props.navigateToLogin()
	end

	local function onActivated3()
		if fFlagLandingAndAccountPickerSsoTelemetry then
			authButtonClick(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				eventStreamConstants.Button.AccountPickerCreateAccount,
				v8,
				nil,
				nil,
				eventStreamConstants.Context.AccountPickerLandingScreenListView
			)
		else
			authButtonClick(
				eventStreamConstants.Context.AccountPickerLandingScreenListView,
				eventStreamConstants.Button.AccountPickerCreateAccount,
				nil,
				nil
			)
		end

		props.navigateToSignup()
	end

	local children = {}

	for i, v14 in ipairs(state2) do
		local username = v14.username or ""
		local v15 = "@" .. username

		local v16 = "AccountCard_" .. tostring(i)
		local createElement = module.createElement
		local view = module2.View

		local createElement2 = module.createElement
		local view2 = module2.View
		local v18 = {
			tag = v7 and "row align-y-center gap-none size-full-0 auto-y padding-y-medium padding-x-large radius-medium" or "row align-y-center gap-none size-full-0 auto-y padding-medium padding-right-small radius-medium",
			BackgroundTransparency = 1,
			onActivated = function()
				local v19 = v14
				authButtonClick(
					eventStreamConstants.Context.AccountPickerLandingScreenListView,
					eventStreamConstants.Button.AccountPickerAccountSelected,
					v19.user_id,
					nil
				)

				props.onAvatarActivated(v19.user_id, v19.username, v19.has_valid_session)
			end,
			isDisabled = v10,
			testId = `account-picker-account-{i}`,
			stateLayer = { affordance = module2.Enums.StateLayerAffordance.None }
		}

		local v19 = {
			Avatar = module.createElement(
				module2.View,
				{
					tag = "radius-full col self-center",
					Size = UDim2.new(0, v9, 0, v9),
					LayoutOrder = 0,
					testId = `account-picker-avatar-{i}`
				},
				{
					AvatarContainer = module.createElement(
						module2.View,
						{
							Size = UDim2.new(0, v9, 0, v9),
							tag = "radius-circle bg-surface-200"
						},
						{
							AvatarImage = module.createElement(module2.Image, {
								Size = UDim2.new(1, 0, 1, 0),
								Image = getRbxthumbWithTypeSizeAndOptions(
									tostring(v14.user_id),
									constants.RbxthumbTypes.AvatarHeadShot,
									150
								),
								tag = "radius-circle"
							})
						}
					)
				}
			),
			AccountInfo = module.createElement(
				module2.View,
				{
					tag = "col items-start fill auto-xy padding-left-small",
					LayoutOrder = 1
				},
				{
					DisplayName = module.createElement(module2.Text, {
						Text = v14.display_name or username,
						tag = "auto-xy text-title-large text-align-x-left text-truncate-end content-emphasis",
						LayoutOrder = 0
					}),
					Username = module.createElement(module2.Text, {
						Text = v15,
						tag = "auto-xy text-body-small text-align-x-left text-truncate-end content-muted",
						LayoutOrder = 1
					})
				}
			),
			SignedOutPill = 0
		}

		local v20 = if not v14.has_valid_session then module.createElement(
			module2.View,
			{
				tag = "col auto-xy padding-x-small padding-y-xsmall radius-small bg-surface-300",
				LayoutOrder = 2
			},
			{
				PillText = module.createElement(module2.Text, {
					Text = v12.signedOut,
					tag = "auto-xy text-title-medium text-caption-large text-align-x-center"
				})
			}
		) else nil
		v19.SignedOutPill = v20
		children[v16] = createElement(view, {
			tag = v7 and "row items-center size-full-0 auto-y" or "row items-center size-full-0 auto-y padding-x-small",
			LayoutOrder = i
		}, {
			AccountCard = createElement2(view2, v18, v19)
		})
	end

	local element = module.createElement(module2.Button, {
		onActivated = onActivated2,
		text = v12.signInAsAccount,
		variant = buttonVariant.Standard,
		size = inputSize.Large,
		width = UDim.new(1, 0),
		LayoutOrder = 1,
		testId = "account-picker-sign-in"
	})

	local element2 = module.createElement(module2.Button, {
		onActivated = onActivated3,
		text = v12.createAccount,
		variant = buttonVariant.Standard,
		size = inputSize.Large,
		width = UDim.new(1, 0),
		LayoutOrder = 2,
		testId = "account-picker-create"
	})

	local createElement = module.createElement
	local fragment = module.Fragment
	local v16

	if state then
		v16 = module.createElement(module5, {
			accounts = props.accounts,
			onClose = function()
				setState(false)
				v13()
			end
		})
	end

	local createElement2 = module.createElement
	local v18 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}

	local createElement3 = module.createElement
	local view = module2.View
	local v20 = { tag = "col size-full-0 auto-xy", Size = UDim2.new(1, 0, 1, 0) }

	local createElement4 = module.createElement
	local view2 = module2.View

	local v22 = if v7 then UDim2.new(1, 0, 0, 80) else nil

	local createElement5 = module.createElement
	local image = module2.Image
	local v24 = {
		Image = module4.Common.RobloxLogo.IMAGE,
		ScaleType = Enum.ScaleType.Fit,
		Size = 0,
		tag = "self-center",
		aspectRatio = 0,
		sizeConstraint = 0,
		ZIndex = 1,
		testId = "account-picker-logo"
	}
	local v25 = if v7 then UDim2.fromOffset(138, 26) else UDim2.new(0.7, 0, 0.7, 0)
	v24.Size = v25

	v24.aspectRatio = module4.Common.RobloxLogo.ASPECT_RATIO
	v24.sizeConstraint = not v7 and {
		MaxSize = Vector2.new(
			module4.Common.RobloxLogo.MAX_WIDTH_LARGE,
			module4.Common.RobloxLogo.MAX_WIDTH_LARGE / module4.Common.RobloxLogo.ASPECT_RATIO
		)
	} or nil
	local children2 = {
		LogoContainer = createElement4(view2, {
			tag = v7 and "justify-center col align-x-center items-center size-full-0" or "justify-center col align-x-center items-center size-full-full auto-y padding-bottom-xxlarge padding-top-xlarge",
			Size = v22,
			LayoutOrder = 0
		}, { Logo = createElement5(image, v24) }),
		HeaderContainer = module.createElement(module2.View, {
			tag = v7 and "row items-center size-full-0 auto-y padding-x-xlarge padding-bottom-large" or "row items-center size-full-0 auto-y padding-x-small padding-bottom-large padding-top-xxlarge",
			LayoutOrder = 1
		}, {
			Title = module.createElement(module2.Text, {
				LayoutOrder = 1,
				Text = v12.allAccounts,
				tag = v7 and "align-x-left fill auto-xy text-heading-small text-align-x-left content-emphasis" or "align-x-left fill auto-xy padding-left-medium text-heading-small text-align-x-left content-emphasis"
			}),
			EditButton = module.createElement(
				module2.View,
				{
					LayoutOrder = 2,
					tag = "col size-0 auto-xy padding-x-small",
					onActivated = onActivated,
					isDisabled = v10
				},
				{
					EditIcon = module.createElement(module2.Text, {
						Text = v12.manage,
						tag = "auto-xy text-title-medium text-align-x-right content-action-link"
					})
				}
			)
		}),
		ScrollViewContainer = 0,
		ButtonContainer = 0,
		DisclaimerLinksView = 0
	}

	local createElement6 = module.createElement
	local view3 = module2.View
	local v28

	if v7 or defineFastFlag2 then
		v28 = module.createElement(
			module2.View,
			{
				tag = "col fill size-full-0 radius-large bg-surface-100",
				ClipsDescendants = true,
				testId = "account-picker-list"
			},
			{
				ScrollView = module.createElement(module2.ScrollView, {
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.XY,
						CanvasSize = UDim2.fromOffset(0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = module2.Enums.ScrollBarVisibility.None
					},
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					AccountElements = module.createElement(
						module2.View,
						{ tag = "col gap-xxsmall auto-xy" },
						children
					)
				})
			}
		)
	else
		v28 = module.createElement(module2.ScrollView, {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = module2.Enums.ScrollBarVisibility.None
			},
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			AccountElements = module.createElement(
				module2.View,
				{ tag = "col gap-xxsmall auto-xy radius-large bg-surface-100" },
				children
			)
		})
	end

	children2.ScrollViewContainer = createElement6(view3, {
		tag = v7 and "col fill size-full-0 padding-x-xlarge" or defineFastFlag2 and "col fill size-full-0 padding-x-xlarge" or "col fill size-full-0 padding-x-large",
		LayoutOrder = 2
	}, { AccountListWrapper = v28 })

	local createElement7 = module.createElement
	local view4 = module2.View
	local v30

	if v7 then
		v30 = {
			PrimaryActions = module.createElement(
				module2.View,
				{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 1 },
				{ SignInButton = element, CreateAccountButton = element2 }
			),
			ExternalIdentitySignInOptions = 0
		}

		local v31 = if v11 and props.onExternalIdentityActivated ~= nil then module.createElement(module6, {
			layoutOrder = 2,
			providers = externalIdentityProviders,
			size = inputSize.Large,
			onActivated = props.onExternalIdentityActivated
		}) else nil
		v30.ExternalIdentitySignInOptions = v31
	else
		v30 = { SignInButton = element, CreateAccountButton = element2 }
	end

	children2.ButtonContainer = createElement7(view4, {
		tag = v7 and "col align-x-center gap-medium size-full-0 auto-y padding-x-xlarge padding-top-medium" or "col align-x-center gap-small size-full-0 auto-y padding-x-xlarge padding-y-medium",
		LayoutOrder = 3,
		testId = "account-picker-actions"
	}, v30)

	local createElement8 = module.createElement
	local view5 = module2.View

	local createElement9 = module.createElement
	local v34 = {
		fillDirection = Enum.FillDirection.Horizontal,
		variant = 0,
		ctx = 0,
		state = 0
	}
	local v35 = if v7 then disclaimerLinksVariant.Foundation else nil
	v34.variant = v35

	local v36 = if fFlagLandingAndAccountPickerSsoTelemetry then eventStreamConstants.Context.AccountPickerLandingScreenListView else nil
	v34.ctx = v36

	v34.state = if fFlagLandingAndAccountPickerSsoTelemetry then v8 else nil
	children2.DisclaimerLinksView = createElement8(view5, {
		tag = v7 and "row align-x-center size-full-0 auto-y padding-top-small padding-bottom-xxlarge" or "row align-x-center size-full-0 auto-y",
		LayoutOrder = 4,
		testId = "account-picker-disclaimer-links"
	}, {
		DisclaimerLinks = createElement9(disclaimerLinks, v34)
	})
	return createElement(fragment, nil, {
		EditAccountPicker = v16,
		MainContainer = createElement2(fullscreenPageWithSafeArea, v18, {
			OuterContainer = createElement3(view, v20, children2)
		})
	})
end
