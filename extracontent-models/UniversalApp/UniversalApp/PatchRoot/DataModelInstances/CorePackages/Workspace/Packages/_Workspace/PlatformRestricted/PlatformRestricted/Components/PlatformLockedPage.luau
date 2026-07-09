local Parent = script:FindFirstAncestor("PlatformRestricted").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local Avatar = Foundation.Avatar
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local FullscreenPageWithSafeArea = require(Parent.AppBlox).FullscreenPageWithSafeArea
local AuthAnalytics = require(Parent.AuthAnalytics)
local authPageload = AuthAnalytics.Events.authPageload
local authButtonClick = AuthAnalytics.Events.authButtonClick
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local AuthCommon = require(Parent.AuthCommon)
local LogoutReasonNames = AuthCommon.Enums.LogoutReasonNames
local ConsoleDisconnect = AuthCommon.Thunks.ConsoleDisconnect
local RoactUtils = require(Parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local AppGuiService = require(Parent.RoactServiceTags).AppGuiService
local Responsive = require(Parent.Responsive)

local function PlatformLockedPage(t1: {[any]: any}) -- line: 51
	-- upvalues: useTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), AppGuiService (copy), Responsive (copy), useLocalization (copy), useSelector (copy), React (copy), authPageload (copy), EventStreamConstants (copy), authButtonClick (copy), ConsoleDisconnect (copy), LogoutReasonNames (copy), FullscreenPageWithSafeArea (copy), View (copy), FoundationText (copy), Avatar (copy), InputSize (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), FillBehavior (copy)
	local v31 = useTokens()
	local v32 = useDispatch()
	local v33 = useRoactService(RoactNetworking)
	local v34 = useRoactService(AppGuiService)
	local v35 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v36 = Responsive.useOrientation() == Responsive.Keys.Landscape
	local v37 = useLocalization({
		title = "Feature.PlatformRestriction.Title.AskParent",
		description = "Feature.PlatformRestriction.Content.NeedPermission",
		continueButton = "Feature.PlatformRestriction.Action.Continue",
		signOutButton = "Feature.PlatformRestriction.Action.Signout"
	})
	local v38 = useSelector(function(p1) -- line: 66
		return p1.LocalUserId
	end)
	local v39 = useSelector(function(p2) -- line: 69
		if p2.Users and p2.LocalUserId then
			return p2.Users[p2.LocalUserId]
		end

		return nil
	end)
	local v40 = if not v39 then nil else v39.displayName
	local v41 = if not v39 then nil else v39.name

	React.useEffect(function() -- line: 79
		-- upvalues: authPageload (copy), EventStreamConstants (copy)
		authPageload(EventStreamConstants.Context.PlatformRestrictedPage)
	end, {})

	local function onSignOut() -- line: 83
		-- upvalues: authButtonClick (copy), EventStreamConstants (copy), v35 (copy), v32 (copy), ConsoleDisconnect (copy), v33 (copy), v34 (copy), t1 (copy), LogoutReasonNames (copy)
		authButtonClick(EventStreamConstants.Context.PlatformRestrictedPage, EventStreamConstants.Button.Logout)

		if v35 then
			v32(ConsoleDisconnect(v33, v34, t1.LogoutThunk))

			return
		end

		v32(t1.LogoutThunk(v33, v34, LogoutReasonNames.Moderation))
	end

	local v43 = if not v36 then UDim.new(0, v31.Padding.XXLarge) else UDim.new(0, 0)

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = false,
		BackgroundColor3 = v31.Color.Surface.Surface_100.Color3,
		useFullScalePage = v35
	}, { React.createElement(View, {
		tag = "col align-x-center size-full-full",
		padding = {
			top = UDim.new(0.1, 0),
			bottom = UDim.new(0, v31.Padding.XXLarge),
			left = v43,
			right = v43
		}
	}, {
		InnerColumn = React.createElement(View, {
			tag = "col flex-y-between",
			Size = UDim2.new(not v36 and 1 or 0.35, 0, 1, 0)
		}, {
			ContentArea = React.createElement(View, {
				tag = "col gap-large size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Title = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-heading-large text-align-x-left content-emphasis",
					LayoutOrder = 1,
					Text = v37.title
				}),
				UserInfoRow = v40 and React.createElement(View, {
					tag = "row align-y-center gap-medium size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					Avatar = v38 and React.createElement(Avatar, {
						LayoutOrder = 1,
						userId = v38,
						size = InputSize.Large
					}),
					NameStack = React.createElement(View, {
						tag = "col fill gap-xxsmall auto-y",
						LayoutOrder = 2
					}, {
						DisplayName = React.createElement(FoundationText, {
							tag = "size-full-0 auto-y text-label-large text-align-x-left content-emphasis",
							LayoutOrder = 1,
							Text = v40
						}),
						Username = v41 and React.createElement(FoundationText, {
							tag = "size-full-0 auto-y text-body-medium text-align-x-left content-muted",
							LayoutOrder = 2,
							Text = "@" .. v41
						})
					})
				}),
				Description = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
					LayoutOrder = 3,
					Text = v37.description
				})
			}),
			ButtonArea = React.createElement(View, {
				tag = "col align-x-center gap-small size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				ContinueButton = React.createElement(Button, {
					LayoutOrder = 1,
					text = v37.continueButton,
					variant = ButtonVariant.Emphasis,
					size = ButtonSize.Large,
					fillBehavior = FillBehavior.Fill,
					width = UDim.new(1, 0),
					onActivated = function() -- line: 169
						-- upvalues: authButtonClick (copy), EventStreamConstants (copy)
						authButtonClick(EventStreamConstants.Context.PlatformRestrictedPage, EventStreamConstants.Button.Continue)
					end
				}),
				SignOutButton = React.createElement(Button, {
					LayoutOrder = 2,
					text = v37.signOutButton,
					variant = ButtonVariant.Utility,
					size = ButtonSize.Large,
					fillBehavior = FillBehavior.Fill,
					width = UDim.new(1, 0),
					onActivated = onSignOut
				})
			})
		})
	}) })
end

return PlatformLockedPage
