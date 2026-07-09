local Parent = script:FindFirstAncestor("LandingPage").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local PeekView = require(Parent.PeekView).PeekView
local PeekViewState = require(Parent.PeekView).PeekViewState
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local debounce = require(Parent.AuthCommon).Utils.debounce
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local v9 = game:DefineFastInt("AccountPickerPeekViewCloseOffset", 10)
local v10 = game:DefineFastInt("AccountPickerPeekViewBriefViewSize", 80)
local AuthAnalytics = require(Parent.AuthAnalytics)
local GetFFlagEnableAccountCarouselEvents = require(Parent.SharedFlags).GetFFlagEnableAccountCarouselEvents
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local v15 = v10 * 3

local function v16(p1) -- line: 28
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y align-y-center text-align-x-left align-x-left padding-y-medium",
		onActivated = p1.onActivated,
		LayoutOrder = p1.LayoutOrder
	}, {
		ButtonText = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-large content-emphasis text-align-x-left padding-left-xlarge",
			Text = p1.text
		})
	})
end

return function(p2) -- line: 49
	-- upvalues: useSelector (copy), useLocalization (copy), debounce (copy), v9 (copy), PeekViewState (copy), React (copy), Foundation (copy), PeekView (copy), v15 (copy), v16 (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy)
	local v19 = useSelector(function(p3) -- line: 50
		return p3.ScreenSize
	end)
	local v20 = useLocalization({
		signInToAnotherAccount = "Authentication.AccountPicker.Button.SignIntoAnotherAccount",
		moreOptions = "Authentication.AccountPicker.Label.MoreOptions",
		createAccount = "Authentication.AccountPicker.Button.CreateAccount",
		manageAccounts = "Authentication.AccountPicker.Label.ManageAccounts"
	})
	local v21 = debounce(function(n1: number) -- line: 61
		-- upvalues: v9 (copy), p2 (copy), PeekViewState (copy)
		if n1 < v9 then
			p2.setPeekViewState(PeekViewState.Closed)
		end
	end, 0.03)

	return React.createElement(Foundation.View, {
		tag = "anchor-bottom-center position-bottom-center bg-over-media",
		Size = UDim2.new(1, 0, 0, v19.Y)
	}, { React.createElement(PeekView, {
		hasScrim = true,
		superBriefViewContentHeight = nil,
		peekHeaderClose = false,
		canDragFullViewToBrief = true,
		returnToFullView = true,
		thumbstickScrollEnabled = true,
		showDraggerInClosedState = true,
		screenSize = v19,
		briefViewContentHeight = UDim.new(0, v15),
		stateOnMount = PeekViewState.Brief,
		peekHeaderPositionYChange = function(p4) -- line: 67
			-- upvalues: v21 (copy)
			v21(p4)
		end,
		peekViewState = p2.peekViewState
	}, {
		PeekViewContent = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y col gap-small align-x-left padding-bottom-xlarge"
		}, {
			Title = React.createElement(Foundation.Text, {
				tag = "auto-xy text-heading-medium content-emphasis text-align-x-left padding-left-xlarge padding-bottom-small",
				LayoutOrder = 1,
				Text = v20.moreOptions
			}),
			ManageAccountsButton = React.createElement(v16, {
				LayoutOrder = 2,
				onActivated = function() -- line: 98
					-- upvalues: p2 (copy)
					p2.navigateToManageAccounts()
				end,
				text = v20.manageAccounts
			}),
			LoginButton = React.createElement(v16, {
				LayoutOrder = 3,
				onActivated = function() -- line: 105
					-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), p2 (copy), PeekViewState (copy)
					if GetFFlagEnableAccountCarouselEvents() then
						authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, EventStreamConstants.Button.AccountPickerSignInAnotherAccount, nil, nil)
					end

					p2.setPeekViewState(PeekViewState.Closed)
					p2.navigateToLogin()
				end,
				text = v20.signInToAnotherAccount
			}),
			SignupButton = React.createElement(v16, {
				LayoutOrder = 4,
				onActivated = function() -- line: 121
					-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), p2 (copy), PeekViewState (copy)
					if GetFFlagEnableAccountCarouselEvents() then
						authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, EventStreamConstants.Button.AccountPickerCreateAccount, nil, nil)
					end

					p2.setPeekViewState(PeekViewState.Closed)
					p2.navigateToSignup()
				end,
				text = v20.createAccount
			})
		})
	}) })
end
