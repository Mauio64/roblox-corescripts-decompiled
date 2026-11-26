local module = require("@luauforge/deferred/gzp")
local module2 = require("@luauforge/deferred/gzq")
local useLocalization = require("@luauforge/deferred/gzr").Hooks.useLocalization

local view = module2.View
local text = module2.Text
local avatar = module2.Avatar
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local buttonSize = module2.Enums.ButtonSize
local fillBehavior = module2.Enums.FillBehavior
local inputSize = module2.Enums.InputSize
local useTokens = module2.Hooks.useTokens

local fullscreenPageWithSafeArea = require("@luauforge/deferred/gzs").FullscreenPageWithSafeArea

local module3 = require("@luauforge/deferred/gzt")
local authPageload = module3.Events.authPageload
local authButtonClick = module3.Events.authButtonClick
local eventStreamConstants = module3.EventStreamConstants

local module4 = require("@luauforge/deferred/gzu")
local logoutReasonNames = module4.Enums.LogoutReasonNames
local consoleDisconnect = module4.Thunks.ConsoleDisconnect
local getFFlagLuaAppPlatformRestrictionVPC = require("@luauforge/deferred/gzv").GetFFlagLuaAppPlatformRestrictionVPC

local v5 = game:DefineFastFlag("PlatformRestrictedUseProfileFrameThumbnail", false)
	and require("@luauforge/deferred/gzv").GetFFlagProfileFrameThumbnailEnabled()
local module5 = require("@luauforge/deferred/gzw")

local module6 = require("@luauforge/deferred/gzx")
local useDispatch = module6.Hooks.RoactRodux.useDispatch
local useSelector = module6.Hooks.RoactRodux.useSelector
local useRoactService = require("@luauforge/deferred/gzC").useRoactService
local roactNetworking = require("@luauforge/deferred/gzD").RoactNetworking
local appGuiService = require("@luauforge/deferred/gzD").AppGuiService
local module7 = require("@luauforge/deferred/gzE")

local function PlatformLockedPage(props)
	local v6 = useTokens()
	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(appGuiService)
	local v10 = module7.usePreferredInput() == module7.Input.Directional
	local v11 = module7.useOrientation() == module7.Keys.Landscape

	local v12 = useLocalization({
		title = "Feature.PlatformRestriction.Title.AskParent",
		description = "Feature.PlatformRestriction.Content.NeedPermission",
		continueButton = "Feature.PlatformRestriction.Action.Continue",
		pendingButton = "Feature.PlatformRestriction.Action.Pending",
		signOutButton = "Feature.PlatformRestriction.Action.Signout"
	})

	local v13 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v14 = useSelector(function(p2)
		if p2.Users and p2.LocalUserId then
			return p2.Users[p2.LocalUserId]
		end

		return nil
	end)

	local displayName = if v14 then v14.displayName else nil
	local name = if v14 then v14.name else nil

	module.useEffect(function()
		authPageload(eventStreamConstants.Context.PlatformRestrictedPage)
	end, {})

	local function onSignOut()
		authButtonClick(
			eventStreamConstants.Context.PlatformRestrictedPage,
			eventStreamConstants.Button.Logout
		)

		if v10 then
			v7(consoleDisconnect(v8, v9, props.LogoutThunk))
		else
			v7(props.LogoutThunk(v8, v9, logoutReasonNames.Moderation))
		end
	end

	local v15 = getFFlagLuaAppPlatformRestrictionVPC() and props.openVpcWizard ~= nil

	local function onContinue()
		authButtonClick(
			eventStreamConstants.Context.PlatformRestrictedPage,
			eventStreamConstants.Button.Continue
		)
	end

	local udim = if v11 then UDim.new(0, 0) else UDim.new(0, v6.Padding.XXLarge)

	local createElement = module.createElement
	local v17 = {
		includeStatusBar = false,
		BackgroundColor3 = v6.Color.Surface.Surface_100.Color3,
		useFullScalePage = v10
	}

	local createElement2 = module.createElement
	local v20 = {
		tag = "col align-x-center size-full-full",
		padding = {
			top = UDim.new(0.1, 0),
			bottom = UDim.new(0, v6.Padding.XXLarge),
			left = udim,
			right = udim
		}
	}

	local createElement3 = module.createElement
	local v23 = {
		tag = "col flex-y-between",
		Size = UDim2.new(v11 and 0.35 or 1, 0, 1, 0)
	}
	local v24 = {
		ContentArea = module.createElement(
			view,
			{ tag = "col gap-large size-full-0 auto-y", LayoutOrder = 1 },
			{
				Title = module.createElement(text, {
					tag = "size-full-0 auto-y text-heading-large text-align-x-left content-emphasis",
					Text = v12.title,
					LayoutOrder = 1
				}),
				UserInfoRow = displayName and module.createElement(
					view,
					{
						tag = "row align-y-center gap-medium size-full-0 auto-y",
						LayoutOrder = 2
					},
					{
						Avatar = v13 and module.createElement(avatar, {
							userId = v13,
							size = inputSize.Large,
							includeProfileFrame = v5,
							LayoutOrder = 1
						}),
						NameStack = module.createElement(
							view,
							{ tag = "col fill gap-xxsmall auto-y", LayoutOrder = 2 },
							{
								DisplayName = module.createElement(text, {
									tag = "size-full-0 auto-y text-label-large text-align-x-left content-emphasis",
									Text = displayName,
									LayoutOrder = 1
								}),
								Username = name and module.createElement(text, {
									tag = "size-full-0 auto-y text-body-medium text-align-x-left content-muted",
									Text = "@" .. name,
									LayoutOrder = 2
								})
							}
						)
					}
				),
				Description = module.createElement(text, {
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
					Text = v12.description,
					LayoutOrder = 3
				})
			}
		),
		ButtonArea = 0
	}

	local createElement4 = module.createElement

	local v28 = if v15 then module.createElement(module5, {
		text = v12.continueButton,
		pendingText = v12.pendingButton,
		LayoutOrder = 1,
		localUserId = v13,
		networking = v8,
		openVpcWizard = props.openVpcWizard,
		refreshUserAccess = props.refreshUserAccess
	}) else module.createElement(button, {
		text = v12.continueButton,
		variant = buttonVariant.Emphasis,
		size = buttonSize.Large,
		fillBehavior = fillBehavior.Fill,
		width = UDim.new(1, 0),
		onActivated = onContinue,
		LayoutOrder = 1
	})
	v24.ButtonArea = createElement4(
		view,
		{ tag = "col align-x-center gap-small size-full-0 auto-y", LayoutOrder = 2 },
		{
			ContinueButton = v28,
			SignOutButton = module.createElement(button, {
				text = v12.signOutButton,
				variant = buttonVariant.Utility,
				size = buttonSize.Large,
				fillBehavior = fillBehavior.Fill,
				width = UDim.new(1, 0),
				onActivated = onSignOut,
				LayoutOrder = 2
			})
		}
	)
	return createElement(fullscreenPageWithSafeArea, v17, {
		createElement2(view, v20, { InnerColumn = createElement3(view, v23, v24) })
	})
end

return PlatformLockedPage
