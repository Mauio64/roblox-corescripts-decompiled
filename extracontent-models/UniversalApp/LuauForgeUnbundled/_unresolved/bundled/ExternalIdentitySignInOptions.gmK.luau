local module = require("@luauforge/bundled/gmo")
local module2 = require("@luauforge/bundled/gmp")
local module3 = require("@luauforge/bundled/gmt")
local useLocalization = module3.Hooks.useLocalization
local localizationRoactContext = module3.LocalizationRoactContext
require("@luauforge/bundled/gmL")
local fFlagEnablePioneerLandingPageSso = require("@luauforge/bundled/gmA").FFlagEnablePioneerLandingPageSso

local fFlagEnableAccountSwitcherExternalIdentityButtons = require("@luauforge/bundled/gml").FFlagEnableAccountSwitcherExternalIdentityButtons

local button = module2.Button
local divider = module2.Divider
local image = module2.Image
local text = module2.Text
local view = module2.View
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local orientation = module2.Enums.Orientation

local v5 = { google = "rbxasset://textures/ui/ExternalIdentity/google.png" }

local v6 = { apple = "apple" }

local v7 = {
	google = { key = "Authentication.Login.Action.Google", fallback = "Google" },
	apple = { key = "Authentication.Login.Action.Apple", fallback = "Apple" }
}

local function createTextureContent(props, p2, p3, p4, p5)
	local v8 = props.size == inputSize.Large
	local v9 = if v8 then p2.Size.Size_600 else p2.Size.Size_500
	local v10 = props.isDisabled and 0.5 or 0
	return module.createElement(
		view,
		{
			tag = "row align-x-center align-y-center gap-small size-full-full padding-x-medium",
			ZIndex = 2
		},
		{
			BrandIcon = module.createElement(image, {
				LayoutOrder = 1,
				Image = p4,
				Size = UDim2.fromOffset(v9, v9),
				imageStyle = { Color3 = Color3.new(1, 1, 1), Transparency = v10 },
				testId = `external-identity-{p5}--brand-icon`
			}),
			Label = module.createElement(text, {
				LayoutOrder = 2,
				Text = p3,
				tag = `shrink auto-xy text-truncate-end {v8 and "text-label-large" or "text-label-medium"}`,
				textStyle = {
					Color3 = p2.Color.ActionStandard.Foreground.Color3,
					Transparency = v10
				}
			})
		}
	)
end

local function createProviderButton(props, p2, p3, p4, i)
	local v8 = v5[p4]
	local createElement = module.createElement
	local v10 = {
		LayoutOrder = i,
		tag = props.orientation == orientation.Vertical and "size-full-0 auto-y" or "grow auto-y",
		testId = `external-identity-{p4}--container`
	}

	local createElement2 = module.createElement
	local v14 = if not v8 then p3[p4] else nil
	local v11 = {
		Button = createElement2(button, {
			text = v14,
			icon = v6[p4],
			variant = buttonVariant.Standard,
			size = props.size,
			width = UDim.new(1, 0),
			isDisabled = props.isDisabled == true,
			onActivated = function()
				props.onActivated(p4)
			end,
			testId = `external-identity-{p4}`
		}),
		TextureContent = 0
	}

	local v15 = if v8 then createTextureContent(props, p2, p3[p4], v8, p4) else nil
	v11.TextureContent = v15
	return createElement(view, v10, v11)
end

local function localizeProviderLabel(object, p2)
	local v8 = v7[p2]
	local success, result = pcall(function()
		return object:Format(v8.key)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return result
	end

	return v8.fallback
end

local function ExternalIdentitySignInOptions(props)
	local v8 = module2.Hooks.useTokens()
	local v9 = module.useContext(localizationRoactContext)
	local v10 = {
		orText = useLocalization({ orText = "Authentication.SignUp.Description.Or" }).orText,
		google = 0,
		apple = 0
	}
	local google = v7.google
	local success, result = pcall(function()
		return v9:Format(google.key)
	end)

	if not success or typeof(result) ~= "string" or result == "" then
		result = google.fallback
	end

	v10.google = result
	local apple = v7.apple
	local success2, result2 = pcall(function()
		return v9:Format(apple.key)
	end)

	if not success2 or typeof(result2) ~= "string" or result2 == "" then
		result2 = apple.fallback
	end

	v10.apple = result2

	if #props.providers == 0 then
		return nil
	end

	local v11 = {}

	for i, provider in ipairs(props.providers) do
		local v12 = provider == "google" and "google" or "apple"
		v11[v12] = createProviderButton(props, v8, v10, v12, i)
	end

	local v12 = props.orientation == orientation.Vertical and "col gap-small size-full-0 auto-y"
		or (fFlagEnableAccountSwitcherExternalIdentityButtons or fFlagEnablePioneerLandingPageSso)
		and (props.size == inputSize.Large and "row gap-small size-full-1200" or "row gap-small size-full-1000")
		or "row gap-small size-full-0 auto-y"

	return module.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-medium size-full-0 auto-y",
			testId = "external-identity-sign-in-options"
		},
		{
			Divider = props.showDivider ~= false and module.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-y-center gap-medium size-full-0 auto-y"
				},
				{
					Left = module.createElement(view, {
						LayoutOrder = 1,
						tag = "grow auto-y"
					}, {
						Line = module.createElement(divider, {
							orientation = orientation.Horizontal
						})
					}),
					Label = module.createElement(text, {
						LayoutOrder = 2,
						Text = v10.orText,
						tag = "auto-xy text-caption-small content-muted"
					}),
					Right = module.createElement(view, {
						LayoutOrder = 3,
						tag = "grow auto-y"
					}, {
						Line = module.createElement(divider, {
							orientation = orientation.Horizontal
						})
					})
				}
			),
			Buttons = module.createElement(view, { LayoutOrder = 2, tag = v12 }, v11)
		}
	)
end

return ExternalIdentitySignInOptions
