local LandingPage = script:FindFirstAncestor("LandingPage")
local LandingPageParent = LandingPage.Parent
local React = require(LandingPageParent.React)
local useStyle = require(LandingPageParent.UIBlox).Core.Style.useStyle
local Foundation = require(LandingPageParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PeekViewState = require(LandingPageParent.PeekView).PeekViewState
local FullscreenPageWithSafeArea = require(LandingPageParent.AppBlox).FullscreenPageWithSafeArea
local AccountCarousel = require(LandingPage.Components.AccountCarousel)
local AccountCarouselMorePeekView = require(LandingPage.Components.AccountCarouselMorePeekView)
local useLocalization = require(LandingPageParent.Localization).Hooks.useLocalization
local LandingPageConstants = require(LandingPage.Constants.LandingPageConstants)
local EditAccountPicker = require(LandingPage.Components.EditAccountPicker)
local GetAccountsListWithSignedOutAccounts = require(LandingPageParent.AccountSwitching).GetAccountsListWithSignedOutAccounts
local useRoactService = require(LandingPageParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(LandingPageParent.RoactServiceTags).RoactNetworking

require(LandingPage.Components.AccountCarouselAvatar)

local DisclaimerLinks = require(LandingPageParent.AuthCommon).Components.DisclaimerLinks
local AuthAnalytics = require(LandingPageParent.AuthAnalytics)
local GetFFlagEnableAccountCarouselEvents = require(LandingPageParent.SharedFlags).GetFFlagEnableAccountCarouselEvents
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authPageload = AuthAnalytics.Events.authPageload
local authButtonClick = AuthAnalytics.Events.authButtonClick

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), PeekViewState (copy), useRoactService (copy), RoactNetworking (copy), GetAccountsListWithSignedOutAccounts (copy), useStyle (copy), useLocalization (copy), GetFFlagEnableAccountCarouselEvents (copy), authPageload (copy), EventStreamConstants (copy), EditAccountPicker (copy), FullscreenPageWithSafeArea (copy), Foundation (copy), LandingPageConstants (copy), AccountCarousel (copy), authButtonClick (copy), ButtonVariant (copy), InputSize (copy), DisclaimerLinks (copy), AccountCarouselMorePeekView (copy)
	local v25, v26 = React.useState(1)
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useState(PeekViewState.Closed)
	local v31 = useRoactService(RoactNetworking)
	local v32 = React.useCallback(function() -- line: 48
		-- upvalues: GetAccountsListWithSignedOutAccounts (copy), v31 (copy), t1 (copy)
		GetAccountsListWithSignedOutAccounts(v31, {
			isAuthenticated = false,
			filterUnauthenticatedSessionsForAccountPicker = true
		}):andThen(function(p1) -- line: 52
			-- upvalues: t1 (copy)
			t1.setAccountPickerAccounts(p1)
		end)
	end, {})
	local v33 = useStyle()
	local v34 = useLocalization({
		moreOptions = "Authentication.AccountPicker.Button.MoreOptions",
		chooseAnAccount = "Authentication.AccountSwitch.Header.ChooseAnAccount",
		signInAsAccount = {
			"Authentication.AccountPicker.Button.SignInAsAccount",
			displayName = t1.accounts and (not not t1.accounts[v25] and t1.accounts[v25].username) or ""
		},
		continueAs = {
			"Authentication.AccountPicker.Button.ContinueAsSignedIn",
			displayName = t1.accounts and (not not t1.accounts[v25] and t1.accounts[v25].username) or ""
		}
	})

	React.useEffect(function() -- line: 77
		-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authPageload (copy), EventStreamConstants (copy)
		if GetFFlagEnableAccountCarouselEvents() then
			authPageload(EventStreamConstants.Context.AccountPickerLandingScreen)
		end
	end, {})

	return React.createElement(React.Fragment, nil, {
		EditAccountPicker = if not v27 then nil else React.createElement(EditAccountPicker, {
			accounts = t1.accounts,
			onClose = function() -- line: 87
				-- upvalues: v28 (copy), v32 (copy)
				v28(false)
				v32()
			end
		}),
		AccountCarouselContainer = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v33.Theme.BackgroundDefault.Color
		}, {
			React.createElement(Foundation.View, {
				tag = "col auto-xy size-full-0",
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				LogoContainer = React.createElement(Foundation.View, {
					tag = "col auto-y size-full-full items-center align-x-center justify-center padding-top-xlarge",
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
				ChooseAnAccountTextContainer = React.createElement(Foundation.View, {
					tag = "col auto-y size-full-0 items-center align-x-center padding-top-xlarge",
					LayoutOrder = 1
				}, {
					ChooseAnAccountText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-heading-small content-emphasis text-align-x-center",
						Text = v34.chooseAnAccount
					})
				}),
				AccountCarousel = React.createElement(AccountCarousel, {
					LayoutOrder = 2,
					accounts = t1.accounts,
					avatarSize = t1.avatarSize,
					setSelectedAvatarIndex = v26
				}),
				ButtonContainer = React.createElement(Foundation.View, {
					tag = "auto-y size-full-0 gap-small col align-x-center padding-x-xlarge padding-y-medium",
					LayoutOrder = 3
				}, {
					PrimaryButton = React.createElement(Foundation.Button, {
						LayoutOrder = 2,
						onActivated = function() -- line: 141
							-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), t1 (copy), v25 (copy)
							if GetFFlagEnableAccountCarouselEvents() then
								authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, if not t1.accounts[v25].has_valid_session then EventStreamConstants.Button.AccountPickerSignInAccount else EventStreamConstants.Button.AccountPickerContinueAsAccount, t1.accounts[v25].user_id, nil)
							end

							t1.onAvatarActivated(t1.accounts[v25].user_id, t1.accounts[v25].username, t1.accounts[v25].has_valid_session)
						end,
						text = if not t1.accounts or (not t1.accounts[v25] or t1.accounts[v25].has_valid_session) then v34.continueAs else v34.signInAsAccount,
						variant = ButtonVariant.Emphasis,
						width = UDim.new(1, 0),
						size = InputSize.Large
					}),
					SecondaryButton = React.createElement(Foundation.Button, {
						LayoutOrder = 3,
						onActivated = function() -- line: 169
							-- upvalues: v30 (copy), PeekViewState (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy)
							v30(PeekViewState.Brief)

							if GetFFlagEnableAccountCarouselEvents() then
								authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, EventStreamConstants.Button.AccountPickerMoreOptions, nil, nil)
							end
						end,
						text = v34.moreOptions,
						variant = ButtonVariant.Standard,
						size = InputSize.Large,
						width = UDim.new(1, 0)
					})
				}),
				DisclaimerLinksView = React.createElement(Foundation.View, {
					tag = "row auto-y size-full-0 align-x-center",
					LayoutOrder = 4
				}, {
					DisclaimerLinks = React.createElement(DisclaimerLinks, {
						fillDirection = Enum.FillDirection.Horizontal
					})
				})
			}),
			PeekViewContainer = if v29 == PeekViewState.Closed then nil else React.createElement(AccountCarouselMorePeekView, {
				navigateToLogin = t1.navigateToLogin,
				navigateToSignup = t1.navigateToSignup,
				peekViewState = v29,
				setPeekViewState = v30,
				navigateToManageAccounts = function() -- line: 202
					-- upvalues: v28 (copy)
					v28(true)
				end
			})
		})
	})
end
