local LandingPage = script:FindFirstAncestor("LandingPage")
local LandingPageParent = LandingPage.Parent
local React = require(LandingPageParent.React)
local Foundation = require(LandingPageParent.Foundation)
local useStyle = require(LandingPageParent.UIBlox).Core.Style.useStyle
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FullscreenPageWithSafeArea = require(LandingPageParent.AppBlox).FullscreenPageWithSafeArea
local UserLib = require(LandingPageParent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local useLocalization = require(LandingPageParent.Localization).Hooks.useLocalization
local LandingPageConstants = require(LandingPage.Constants.LandingPageConstants)
local DisclaimerLinks = require(LandingPageParent.AuthCommon).Components.DisclaimerLinks
local EditAccountPicker = require(LandingPage.Components.EditAccountPicker)
local AuthAnalytics = require(LandingPageParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authPageload = AuthAnalytics.Events.authPageload
local GetAccountsListWithSignedOutAccounts = require(LandingPageParent.AccountSwitching).GetAccountsListWithSignedOutAccounts
local useRoactService = require(LandingPageParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(LandingPageParent.RoactServiceTags).RoactNetworking
local v23 = game:DefineFastFlag("EnableAccountPickerListViewEvents", false)
local v24 = game:DefineFastFlag("FixAccountPickerListViewScrollAndAlignment", false)

return function(t1: {[any]: any}) -- line: 53
	-- upvalues: React (copy), useRoactService (copy), RoactNetworking (copy), useStyle (copy), useLocalization (copy), authPageload (copy), EventStreamConstants (copy), v23 (copy), GetAccountsListWithSignedOutAccounts (copy), authButtonClick (copy), Foundation (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), EditAccountPicker (copy), FullscreenPageWithSafeArea (copy), LandingPageConstants (copy), v24 (copy), ButtonVariant (copy), InputSize (copy), DisclaimerLinks (copy)
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(t1.accounts)
	local v30 = useRoactService(RoactNetworking)
	local v31 = useStyle()
	local v32 = useLocalization({
		allAccounts = "Authentication.AccountPicker.Label.AllAccounts",
		manage = "Authentication.AccountPicker.Label.Manage",
		signInAsAccount = "Authentication.AccountPicker.Button.SignIntoAnotherAccount",
		createAccount = "Authentication.AccountPicker.Button.CreateAccount",
		signedOut = "Authentication.AccountPicker.Label.SignedOut"
	})

	React.useEffect(function() -- line: 67
		-- upvalues: authPageload (copy), EventStreamConstants (copy)
		authPageload(EventStreamConstants.Context.AccountPickerLandingScreenListView)
	end, {})
	React.useEffect(function() -- line: 71
		-- upvalues: v29 (copy), t1 (copy), v23 (copy), authPageload (copy), EventStreamConstants (copy)
		v29(t1.accounts)

		if v23 then
			authPageload(EventStreamConstants.Context.AccountPickerListViewAccountsDisplayed, tostring(#t1.accounts), nil)
		end
	end, { t1.accounts })

	local v33 = React.useCallback(function() -- line: 82
		-- upvalues: GetAccountsListWithSignedOutAccounts (copy), v30 (copy), t1 (copy)
		GetAccountsListWithSignedOutAccounts(v30, {
			isAuthenticated = false,
			filterUnauthenticatedSessionsForAccountPicker = true
		}):andThen(function(p1) -- line: 86
			-- upvalues: t1 (copy)
			t1.setAccountPickerAccounts(p1)
		end)
	end, {
		v30,
		t1.setAccountPickerAccounts
	})
	local t2 = {}

	for i, v in ipairs(v28) do
		local v37 = v.username or ""
		local v38 = "@" .. v37

		t2["AccountCard_" .. tostring(i)] = React.createElement(Foundation.View, {
			tag = "row items-center size-full-0 auto-y padding-x-small",
			LayoutOrder = i
		}, {
			AccountCard = React.createElement(Foundation.View, {
				tag = "row align-y-center gap-none size-full-0 auto-y padding-medium padding-right-small radius-medium",
				BackgroundTransparency = 1,
				onActivated = function() -- line: 143
					-- upvalues: v (copy), authButtonClick (copy), EventStreamConstants (copy), t1 (copy)
					local v40 = v

					authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreenListView, EventStreamConstants.Button.AccountPickerAccountSelected, v40.user_id, nil)
					t1.onAvatarActivated(v40.user_id, v40.username, v40.has_valid_session)
				end,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.None
				}
			}, {
				Avatar = React.createElement(Foundation.View, {
					tag = "radius-full col self-center",
					LayoutOrder = 0,
					Size = UDim2.new(0, 56, 0, 56)
				}, {
					AvatarContainer = React.createElement(Foundation.View, {
						tag = "radius-circle bg-surface-200",
						Size = UDim2.new(0, 56, 0, 56)
					}, {
						AvatarImage = React.createElement(Foundation.Image, {
							tag = "radius-circle",
							Size = UDim2.new(1, 0, 1, 0),
							Image = getRbxthumbWithTypeSizeAndOptions(tostring(v.user_id), Constants.RbxthumbTypes.AvatarHeadShot, 150)
						})
					})
				}),
				AccountInfo = React.createElement(Foundation.View, {
					tag = "col items-start fill auto-xy padding-left-small",
					LayoutOrder = 1
				}, {
					DisplayName = React.createElement(Foundation.Text, {
						tag = "auto-xy text-title-large text-align-x-left text-truncate-end content-emphasis",
						LayoutOrder = 0,
						Text = v.display_name or v37
					}),
					Username = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-small text-align-x-left text-truncate-end content-muted",
						LayoutOrder = 1,
						Text = v38
					})
				}),
				SignedOutPill = if v.has_valid_session then nil else React.createElement(Foundation.View, {
					tag = "col auto-xy padding-x-small padding-y-xsmall radius-small bg-surface-300",
					LayoutOrder = 2
				}, {
					PillText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-title-medium text-caption-large text-align-x-center",
						Text = v32.signedOut
					})
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, {
		EditAccountPicker = if not v26 then nil else React.createElement(EditAccountPicker, {
			accounts = t1.accounts,
			onClose = function() -- line: 204
				-- upvalues: v27 (copy), v33 (copy)
				v27(false)
				v33()
			end
		}),
		MainContainer = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v31.Theme.BackgroundDefault.Color
		}, {
			OuterContainer = React.createElement(Foundation.View, {
				tag = "col size-full-0 auto-xy",
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				LogoContainer = React.createElement(Foundation.View, {
					tag = "justify-center col align-x-center items-center size-full-full auto-y padding-bottom-xxlarge padding-top-xlarge",
					LayoutOrder = 0
				}, {
					Logo = React.createElement(Foundation.Image, {
						tag = "self-center",
						ZIndex = 1,
						Image = LandingPageConstants.Common.RobloxLogo.IMAGE,
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.new(0.7, 0, 0.7, 0),
						aspectRatio = LandingPageConstants.Common.RobloxLogo.ASPECT_RATIO,
						sizeConstraint = {
							MaxSize = Vector2.new(LandingPageConstants.Common.RobloxLogo.MAX_WIDTH_LARGE, LandingPageConstants.Common.RobloxLogo.MAX_WIDTH_LARGE / LandingPageConstants.Common.RobloxLogo.ASPECT_RATIO)
						}
					})
				}),
				HeaderContainer = React.createElement(Foundation.View, {
					tag = "row items-center size-full-0 auto-y padding-x-small padding-bottom-large padding-top-xxlarge",
					LayoutOrder = 1
				}, {
					Title = React.createElement(Foundation.Text, {
						LayoutOrder = 1,
						tag = "align-x-left fill auto-xy padding-left-medium text-heading-small text-align-x-left content-emphasis",
						Text = v32.allAccounts
					}),
					EditButton = React.createElement(Foundation.View, {
						LayoutOrder = 2,
						tag = "col size-0 auto-xy padding-x-small",
						onActivated = function() -- line: 101
							-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v27 (copy)
							authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreenListView, EventStreamConstants.Button.AccountPickerManageAccountsOpened, nil, nil)
							v27(true)
						end
					}, {
						EditIcon = React.createElement(Foundation.Text, {
							tag = "auto-xy text-title-medium text-align-x-right content-action-link",
							Text = v32.manage
						})
					})
				}),
				ScrollViewContainer = React.createElement(Foundation.View, {
					LayoutOrder = 2,
					tag = not v24 and "col fill size-full-0 padding-x-large" or "col fill size-full-0 padding-x-xlarge"
				}, {
					AccountListWrapper = if not v24 then React.createElement(Foundation.ScrollView, {
						scroll = {
							AutomaticCanvasSize = Enum.AutomaticSize.XY,
							CanvasSize = UDim2.fromOffset(0, 0),
							ScrollingDirection = Enum.ScrollingDirection.Y,
							scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
						},
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						AccountElements = React.createElement(Foundation.View, {
							tag = "col gap-xxsmall auto-xy radius-large bg-surface-100"
						}, t2)
					}) else React.createElement(Foundation.View, {
						tag = "col fill size-full-0 radius-large bg-surface-100",
						ClipsDescendants = true
					}, {
						ScrollView = React.createElement(Foundation.ScrollView, {
							scroll = {
								AutomaticCanvasSize = Enum.AutomaticSize.XY,
								CanvasSize = UDim2.fromOffset(0, 0),
								ScrollingDirection = Enum.ScrollingDirection.Y,
								scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
							},
							Size = UDim2.new(1, 0, 1, 0)
						}, {
							AccountElements = React.createElement(Foundation.View, {
								tag = "col gap-xxsmall auto-xy"
							}, t2)
						})
					})
				}),
				ButtonContainer = React.createElement(Foundation.View, {
					tag = "col align-x-center gap-small size-full-0 auto-y padding-x-xlarge padding-y-medium",
					LayoutOrder = 3
				}, {
					SignInButton = React.createElement(Foundation.Button, {
						LayoutOrder = 1,
						onActivated = function() -- line: 111
							-- upvalues: authButtonClick (copy), EventStreamConstants (copy), t1 (copy)
							authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreenListView, EventStreamConstants.Button.AccountPickerSignInAnotherAccount, nil, nil)
							t1.navigateToLogin()
						end,
						text = v32.signInAsAccount,
						variant = ButtonVariant.Standard,
						size = InputSize.Large,
						width = UDim.new(1, 0)
					}),
					CreateAccountButton = React.createElement(Foundation.Button, {
						LayoutOrder = 2,
						onActivated = function() -- line: 121
							-- upvalues: authButtonClick (copy), EventStreamConstants (copy), t1 (copy)
							authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreenListView, EventStreamConstants.Button.AccountPickerCreateAccount, nil, nil)
							t1.navigateToSignup()
						end,
						text = v32.createAccount,
						variant = ButtonVariant.Standard,
						size = InputSize.Large,
						width = UDim.new(1, 0)
					})
				}),
				DisclaimerLinksView = React.createElement(Foundation.View, {
					tag = "row align-x-center size-full-0 auto-y",
					LayoutOrder = 4
				}, {
					DisclaimerLinks = React.createElement(DisclaimerLinks, {
						fillDirection = Enum.FillDirection.Horizontal
					})
				})
			})
		})
	})
end
