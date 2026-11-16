local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local dialog = module2.Dialog
local buttonVariant = module2.Enums.ButtonVariant
local dialogSize = module2.Enums.DialogSize
local orientation = module2.Enums.Orientation
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/bundled/gvk")
local renderer = module3.Renderer
local linkBehavior = module3.Enums.LinkBehavior
local prepareRichTextCopy = module3.prepareRichTextCopy

require("@luauforge/bundled/gvc")
local module4 = require("@luauforge/bundled/gvl")
local module5 = require("@luauforge/bundled/gvn")
local module6 = require("@luauforge/bundled/gvo")
local fFlagLuaAppOdpPrologueAnalytics = require("@luauforge/bundled/gvp").FFlagLuaAppOdpPrologueAnalytics

local fFlagLuaAppAmpWizardSendAnalyticsSessionId = require("@luauforge/bundled/gvp").FFlagLuaAppAmpWizardSendAnalyticsSessionId

local function TextScreenNode(props)
	local props2 = props.props
	local report = props.report
	local node = props.ctx.analytics.node

	local v5 = node == module5.NEED_TO_REVERIFY_NODE
	local v6 = fFlagLuaAppOdpPrologueAnalytics and node == module5.PROLOGUE_NODE

	local v7 = fFlagLuaAppAmpWizardSendAnalyticsSessionId and node == module5.PROLOGUE_NODE
	local odpEventContext = props.ctx.odpEventContext
	local analyticsSessionId = props.ctx.analyticsSessionId
	local launchProps = props.ctx.launchProps
	local v8 = module4.useOdpAnalytics(props.ctx)
	local v9

	if fFlagLuaAppAmpWizardSendAnalyticsSessionId then
		v9 = module6.useVpcEntryAnalytics(props.ctx)
	else
		v9 = nil
	end

	local v10

	if fFlagLuaAppAmpWizardSendAnalyticsSessionId then
		local buttons = props2.buttons or {}
		local getPrologueType = module6.getPrologueType
		local v11 = #buttons
		local v12 = if #buttons > 0 then buttons[1].outcome else nil
		v10 = getPrologueType(v11, v12)
	else
		v10 = nil
	end

	local ref = module.useRef(nil)
	module.useEffect(function()
		if ref.current == node then
			return
		end

		ref.current = node

		if v5 then
			v8.reverifyShown()
		elseif v6 and odpEventContext ~= nil then
			v8.prologueShown(odpEventContext, analyticsSessionId, launchProps)
		end

		if v7 and v9 and v10 then
			v9.prologueShown(v10)
		end
	end, {
		node,
		v5,
		v6,
		odpEventContext,
		analyticsSessionId,
		launchProps,
		v8,
		v7,
		v9,
		v10
	})

	local v11 = module.useMemo(function()
		local result = {}

		for k, v12 in props2.buttons or {} do
			local v13 = { text = v12.label, variant = 0, onActivated = 0 }
			local v14 = if k == 1 then buttonVariant.Emphasis else buttonVariant.Standard
			v13.variant = v14
			function v13.onActivated()
				if v5 then
					v8.reverifyButtonClick(v12.outcome)
				elseif v6 and odpEventContext ~= nil then
					v8.prologueButtonClick(odpEventContext, analyticsSessionId, launchProps, v12.outcome)
				end

				if v7 and v9 and v10 then
					v9.prologueButtonClick(v12.outcome, v10)
				end

				report(v12.outcome)
			end

			table.insert(result, v13)
		end

		return result
	end, {
		props2,
		report,
		v5,
		v6,
		odpEventContext,
		analyticsSessionId,
		launchProps,
		v8,
		v7,
		v9,
		v10
	})

	local v12 = module.useCallback(function()
		if v5 then
			v8.reverifyClose()
		elseif v6 and odpEventContext ~= nil then
			v8.prologueButtonClick(odpEventContext, analyticsSessionId, launchProps, "Cancel")
		end

		if v7 and v9 and v10 then
			v9.prologueButtonClick("Cancel", v10)
		end

		report("Cancel")
	end, {
		report,
		v5,
		v6,
		odpEventContext,
		analyticsSessionId,
		launchProps,
		v8,
		v7,
		v9,
		v10
	})

	local v13 = not (props2.imageUrl == nil) and props2.imageUrl ~= ""

	local v14 = useTokens()

	local v15 = module.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return linkBehavior.Webview
			end
		}
	end, {})

	local footerText = props2.footerText
	local v16 = not (footerText == nil) and footerText ~= ""

	local v17 = module.useMemo(function()
		if v16 then
			return (prepareRichTextCopy(footerText))
		end

		return nil
	end, { footerText, v16 })

	local createElement = module.createElement
	local root = dialog.Root
	local v18 = { size = dialogSize.Small, onClose = v12 }

	local v19 = if v13 then module.createElement(dialog.HeroMedia, {
		media = props2.imageUrl
	}) else nil
	local children = {
		Illustration = v19,
		Title = module.createElement(dialog.Title, { text = props2.title }),
		Content = module.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Description = module.createElement(dialog.Text, {
				Text = props2.description
			})
		}),
		Actions = module.createElement(dialog.Actions, {
			LayoutOrder = 3,
			orientation = orientation.Vertical,
			actions = v11
		}),
		Footer = 0
	}

	local v20 = if v16 then module.createElement(renderer, {
		text = v17,
		textStyle = v14.Color.Content.Default,
		fontStyle = v14.Typography.BodySmall,
		linkerOptions = v15,
		wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = 4 },
		nodeProps = {
			LINK = { showUnderline = true }
		}
	}) else nil
	children.Footer = v20
	return createElement(root, v18, children)
end

return TextScreenNode
