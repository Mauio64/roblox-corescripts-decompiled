local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local view = module2.View
local text = module2.Text
local image = module2.Image
local icon = module2.Icon
local button = module2.Button
local scrollView = module2.ScrollView
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local iconSize = module2.Enums.IconSize
local iconName = module2.Enums.IconName
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/bundled/gvk")
local renderer = module3.Renderer
local linkBehavior = module3.Enums.LinkBehavior

require("@luauforge/bundled/gvc")
local module4 = require("@luauforge/bundled/gvr")
local module5 = require("@luauforge/bundled/gvl")
local prepareRichTextCopy = module3.prepareRichTextCopy

local function canonicalLegalUrl(value)
	local v5 = string.gsub(value, "[?#].*$", "")
	return string.lower((string.gsub(v5, "^https?://[^/]+", "")))
end

local function renderGlyph(icon2)
	local v5 = iconName[icon2]

	if v5 == nil then
		return module.createElement(image, {
			Image = icon2,
			Size = UDim2.fromOffset(24, 24),
			ScaleType = Enum.ScaleType.Fit,
			tag = "content-emphasis"
		})
	end

	return module.createElement(icon, {
		name = v5,
		size = iconSize.Large,
		tag = "content-emphasis"
	})
end

local function renderBulletLeading(p2)
	local icon2 = p2.icon

	if icon2 == nil or icon2 == "" then
		return nil
	end

	return module.createElement(
		view,
		{
			tag = "col align-x-center align-y-center",
			Size = UDim2.fromOffset(40, 40),
			LayoutOrder = 1,
			testId = "amp-v2-wizard-bullet-glyph"
		},
		{ Glyph = renderGlyph(icon2) }
	)
end

local function renderBullet(p2, k)
	local createElement = module.createElement

	local v7 = { Leading = renderBulletLeading(p2), Copy = 0 }
	local createElement2 = module.createElement

	local v10 = {
		Title = module.createElement(text, {
			Text = p2.title,
			tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Description = 0
	}

	local v11 = if p2.description ~= nil and p2.description ~= "" then module.createElement(text, {
		Text = p2.description,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
		LayoutOrder = 2
	}) else nil
	v10.Description = v11
	v7.Copy = createElement2(view, {
		tag = "col fill gap-xsmall auto-y",
		LayoutOrder = 2
	}, v10)
	return createElement(
		view,
		{
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small",
			LayoutOrder = k
		},
		v7
	)
end

local function UserAgreementNode(props)
	local props2 = props.props
	local report = props.report
	local v5 = useTokens()
	local copyVariant = props2.copyVariant
	local termsUrl = props2.termsUrl or "https://www.roblox.com/info/terms"
	local privacyUrl = props2.privacyUrl or "https://www.roblox.com/info/privacy"
	local v6 = module5.useOdpAnalytics(props.ctx)

	module.useEffect(function()
		v6.agreementShown(copyVariant)
	end, {})

	local v7 = module.useCallback(function()
		v6.agreementContinue(copyVariant)
		report("Continue")
	end, { report, copyVariant, v6 })

	local v8 = module.useCallback(function()
		v6.agreementBack(copyVariant)
		report("Back")
	end, { report, copyVariant, v6 })

	local v9 = module.useCallback(function(p2)
		local url = p2.url
		local v10 = string.gsub(url, "[?#].*$", "")
		local v11 = string.lower((string.gsub(v10, "^https?://[^/]+", "")))
		local v13 = string.gsub(termsUrl, "[?#].*$", "")

		if v11 == string.lower((string.gsub(v13, "^https?://[^/]+", ""))) then
			v6.agreementTerms(copyVariant)
			return
		end

		local v15 = string.gsub(privacyUrl, "[?#].*$", "")

		if v11 == string.lower((string.gsub(v15, "^https?://[^/]+", ""))) then
			v6.agreementPrivacy(copyVariant)
		end
	end, { termsUrl, privacyUrl, copyVariant, v6 })

	local v10 = module.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return linkBehavior.Webview
			end,
			onActivatedSubscriber = v9
		}
	end, { v9 })

	local v11 = {}

	for k, v12 in props2.bullets or {} do
		v11[`Bullet_{k}`] = renderBullet(v12, k)
	end

	local legalText = props2.legalText
	local v12 = not (legalText == nil) and legalText ~= ""

	local v13 = module.useMemo(function()
		if v12 then
			return (prepareRichTextCopy(legalText))
		end

		return nil
	end, { legalText, v12 })

	local createElement = module.createElement
	local createElement2 = module.createElement
	local v17 = {
		LayoutOrder = 1,
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = UDim2.fromScale(1, 0),
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 1)
		}
	}

	local createElement3 = module.createElement

	local createElement4 = module.createElement

	local createElement5 = module.createElement

	local v27 = {
		Title = module.createElement(text, {
			Text = props2.title,
			tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		}),
		Description = 0
	}

	local v28 = if props2.description ~= nil and props2.description ~= "" then module.createElement(text, {
		Text = props2.description,
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
		LayoutOrder = 2
	}) else nil
	v27.Description = v28
	local v24 = {
		Intro = createElement5(view, {
			tag = "col gap-none size-full-0 auto-y",
			LayoutOrder = 1
		}, v27),
		Bullets = 0
	}

	local v29 = if next(v11) ~= nil then module.createElement(
		view,
		{ tag = "col gap-xxlarge size-full-0 auto-y", LayoutOrder = 2 },
		v11
	) else nil
	v24.Bullets = v29
	local children = {
		Body = createElement2(scrollView, v17, {
			Content = createElement3(view, { tag = "col gap-none size-full-0 auto-y" }, {
				Copy = createElement4(
					view,
					{
						tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge",
						LayoutOrder = 1
					},
					v24
				)
			})
		}),
		Footer = 0
	}

	local createElement6 = module.createElement

	local v32 = {
		Continue = module.createElement(button, {
			text = props2.continueLabel or "",
			onActivated = v7,
			variant = buttonVariant.Emphasis,
			size = inputSize.Medium,
			width = UDim.new(1, 0),
			LayoutOrder = 1
		}),
		Legal = 0
	}

	local v33 = if v12 then module.createElement(renderer, {
		text = v13,
		textStyle = v5.Color.Content.Default,
		fontStyle = v5.Typography.CaptionLarge,
		linkerOptions = v10,
		wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = 2 },
		nodeProps = {
			LINK = { showUnderline = true }
		}
	}) else nil
	v32.Legal = v33
	children.Footer = createElement6(
		view,
		{
			tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
			LayoutOrder = 2
		},
		v32
	)
	local element = createElement(view, { tag = "col size-full" }, children)

	return module.createElement(module4, { title = props2.headerTitle, onBack = v8 }, {
		Content = element
	})
end

return UserAgreementNode
