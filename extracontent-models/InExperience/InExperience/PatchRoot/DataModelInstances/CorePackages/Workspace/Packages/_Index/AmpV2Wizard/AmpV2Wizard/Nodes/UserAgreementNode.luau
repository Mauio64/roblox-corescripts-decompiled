local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local ScrollView = Foundation.ScrollView
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local InlineRichText = require(parent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior

require(AmpV2Wizard.Types)
local FullPageChrome = require(AmpV2Wizard.FullPageChrome)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)
local prepareRichTextCopy = InlineRichText.prepareRichTextCopy

local function canonicalLegalUrl(value: string) -- 3 equivalent calls inferred from this helper
	local v = string.gsub(value, "[?#].*$", "")
	return string.lower((string.gsub(v, "^https?://[^/]+", "")))
end

local function renderGlyph(icon: string)
	local name = IconName[icon]

	if name == nil then
		return React.createElement(Image, {
			Image = icon,
			Size = UDim2.fromOffset(24, 24),
			ScaleType = Enum.ScaleType.Fit,
			tag = "content-emphasis"
		})
	end

	return React.createElement(Icon, {
		name = name,
		size = IconSize.Large,
		tag = "content-emphasis"
	})
end

local function renderBulletLeading(p)
	local icon = p.icon

	if icon == nil or icon == "" then
		return nil
	end

	return React.createElement(
		View,
		{
			tag = "col align-x-center align-y-center",
			Size = UDim2.fromOffset(40, 40),
			LayoutOrder = 1,
			testId = "amp-v2-wizard-bullet-glyph"
		},
		{ Glyph = renderGlyph(icon) }
	)
end

local function renderBullet(p, k: number)
	local createElement = React.createElement

	local v = { Leading = renderBulletLeading(p), Copy = 0 }
	local createElement2 = React.createElement

	local v2 = {
		Title = React.createElement(Text, {
			Text = p.title,
			tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Description = 0
	}
	local description

	if not (p.description == nil or p.description == "") then
		description = React.createElement(Text, {
			Text = p.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 2
		})
	end

	v2.Description = description
	v.Copy = createElement2(View, { tag = "col fill gap-xsmall auto-y", LayoutOrder = 2 }, v2)
	return createElement(
		View,
		{
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small",
			LayoutOrder = k
		},
		v
	)
end

local function UserAgreementNode(props)
	local props2 = props.props
	local report = props.report
	local v = useTokens()
	local copyVariant = props2.copyVariant
	local termsUrl = props2.termsUrl or "https://www.roblox.com/info/terms"
	local privacyUrl = props2.privacyUrl or "https://www.roblox.com/info/privacy"
	local v2 = OdpAnalytics.useOdpAnalytics(props.ctx)

	React.useEffect(function()
		v2.agreementShown(copyVariant)
	end, {})

	local onActivated = React.useCallback(function()
		v2.agreementContinue(copyVariant)
		report("Continue")
	end, { report, copyVariant, v2 })

	local onBack = React.useCallback(function()
		v2.agreementBack(copyVariant)
		report("Back")
	end, { report, copyVariant, v2 })

	local onActivatedSubscriber = React.useCallback(function(p)
		local v3 = canonicalLegalUrl(p.url) -- inferred equivalent call

		if v3 == canonicalLegalUrl(termsUrl) then -- inferred equivalent call
			v2.agreementTerms(copyVariant)
		elseif v3 == canonicalLegalUrl(privacyUrl) then -- inferred equivalent call
			v2.agreementPrivacy(copyVariant)
		end
	end, { termsUrl, privacyUrl, copyVariant, v2 })

	local linkerOptions = React.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return LinkBehavior.Webview
			end,
			onActivatedSubscriber = onActivatedSubscriber
		}
	end, { onActivatedSubscriber })

	local v3 = {}

	for k, v4 in props2.bullets or {} do
		v3[`Bullet_{k}`] = renderBullet(v4, k)
	end

	local legalText = props2.legalText
	local v4

	if legalText == nil then
		v4 = false
	else
		v4 = legalText ~= ""
	end

	local text = React.useMemo(function()
		if v4 then
			return (prepareRichTextCopy(legalText))
		end

		return nil
	end, { legalText, v4 })

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v5 = {
		LayoutOrder = 1,
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = UDim2.fromScale(1, 0),
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 1)
		}
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local createElement5 = React.createElement

	local v6 = {
		Title = React.createElement(Text, {
			Text = props2.title,
			tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Description = 0
	}
	local description

	if not (props2.description == nil or props2.description == "") then
		description = React.createElement(Text, {
			Text = props2.description,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
			LayoutOrder = 2
		})
	end

	v6.Description = description
	local v7 = {
		Intro = createElement5(View, { tag = "col gap-none size-full-0 auto-y", LayoutOrder = 1 }, v6),
		Bullets = 0
	}
	local bullets

	if next(v3) ~= nil then
		bullets = React.createElement(View, {
			tag = "col gap-xxlarge size-full-0 auto-y",
			LayoutOrder = 2
		}, v3)
	end

	v7.Bullets = bullets
	local children = {
		Body = createElement2(ScrollView, v5, {
			Content = createElement3(View, { tag = "col gap-none size-full-0 auto-y" }, {
				Copy = createElement4(
					View,
					{
						tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge",
						LayoutOrder = 1
					},
					v7
				)
			})
		}),
		Footer = 0
	}

	local createElement6 = React.createElement

	local v8 = {
		Continue = React.createElement(Button, {
			text = props2.continueLabel or "",
			onActivated = onActivated,
			variant = ButtonVariant.Emphasis,
			size = InputSize.Medium,
			width = UDim.new(1, 0),
			LayoutOrder = 1
		}),
		Legal = 0
	}
	local legal

	if v4 then
		legal = React.createElement(Renderer, {
			text = text,
			textStyle = v.Color.Content.Default,
			fontStyle = v.Typography.CaptionLarge,
			linkerOptions = linkerOptions,
			wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = 2 },
			nodeProps = {
				LINK = { showUnderline = true }
			}
		})
	end

	v8.Legal = legal
	children.Footer = createElement6(
		View,
		{
			tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
			LayoutOrder = 2
		},
		v8
	)
	local element = createElement(View, { tag = "col size-full" }, children)

	return React.createElement(FullPageChrome, { title = props2.headerTitle, onBack = onBack }, {
		Content = element
	})
end

return UserAgreementNode
