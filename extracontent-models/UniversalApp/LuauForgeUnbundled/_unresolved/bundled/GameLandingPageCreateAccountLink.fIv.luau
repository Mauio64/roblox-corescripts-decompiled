local module = require("@luauforge/bundled/fHU")
local module2 = require("@luauforge/bundled/fHV")
local module3 = require("@luauforge/bundled/fIf")
local useLocalization = require("@luauforge/bundled/fHZ").Hooks.useLocalization
local module4 = require("@luauforge/bundled/fIw")
local renderer = module4.Renderer
local prepareRichTextCopy = module4.prepareRichTextCopy

local createLegalLinkRenderer = module3.Utils.createLegalLinkRenderer

local view = module2.View
local useTokens = module2.Hooks.useTokens

local function GameLandingPageCreateAccountLink(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		createAccountText = {
			"Authentication.Login.Label.DontHaveAnAccountCreateOne",
			startTag = "<a href=\"create-account\">",
			endTag = "</a>"
		}
	})

	local v7 = module.useCallback(function(p3)
		if p3 == "create-account" then
			p2.onCreateAccount()
		end
	end, { p2.onCreateAccount })

	local v8 = module.useMemo(function()
		return { LINK = createLegalLinkRenderer(v7) }
	end, { v7 })

	local v9 = module.useMemo(function()
		return prepareRichTextCopy(v6.createAccountText)
	end, { v6.createAccountText })

	local labelLarge = v5.Typography.LabelLarge
	local v10 = {
		Font = labelLarge.Font,
		FontSize = labelLarge.FontSize,
		LineHeight = 1
	}

	return module.createElement(view, {
		tag = "col align-x-center size-full-0 auto-y",
		LayoutOrder = p2.LayoutOrder,
		padding = {
			top = UDim.new(0, v5.Size.Size_400),
			bottom = UDim.new(0, v5.Size.Size_400)
		},
		testId = "game-landing-page-create-account"
	}, {
		Line = module.createElement(renderer, {
			text = v9,
			renderers = v8,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = v10,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			wrapperProps = {
				tag = "size-full-0 auto-y",
				testId = "game-landing-page-create-account-link"
			}
		})
	})
end

return GameLandingPageCreateAccountLink
