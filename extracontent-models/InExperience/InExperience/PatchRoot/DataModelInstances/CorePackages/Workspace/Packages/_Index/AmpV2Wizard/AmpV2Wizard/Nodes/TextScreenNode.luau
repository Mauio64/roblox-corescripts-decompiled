local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens

local InlineRichText = require(parent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior
local prepareRichTextCopy = InlineRichText.prepareRichTextCopy

require(AmpV2Wizard.Types)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)
local OdpAnalyticsConstants = require(AmpV2Wizard.OdpAnalyticsConstants)
local VpcEntryAnalytics = require(AmpV2Wizard.VpcEntryAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOdpPrologueAnalytics = SharedFlags.FFlagLuaAppOdpPrologueAnalytics

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAmpWizardSendAnalyticsSessionId = SharedFlags2.FFlagLuaAppAmpWizardSendAnalyticsSessionId

local function TextScreenNode(props)
	local props2 = props.props
	local report = props.report
	local node = props.ctx.analytics.node

	local v = node == OdpAnalyticsConstants.NEED_TO_REVERIFY_NODE
	local v2 = FFlagLuaAppOdpPrologueAnalytics and node == OdpAnalyticsConstants.PROLOGUE_NODE

	local v3 = FFlagLuaAppAmpWizardSendAnalyticsSessionId and node == OdpAnalyticsConstants.PROLOGUE_NODE
	local odpEventContext = props.ctx.odpEventContext
	local analyticsSessionId = props.ctx.analyticsSessionId
	local launchProps = props.ctx.launchProps
	local v4 = OdpAnalytics.useOdpAnalytics(props.ctx)
	local v5

	if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
		v5 = VpcEntryAnalytics.useVpcEntryAnalytics(props.ctx)
	else
		v5 = nil
	end

	local v6

	if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
		local buttons = props2.buttons or {}
		local getPrologueType = VpcEntryAnalytics.getPrologueType
		local v7 = #buttons
		local v8

		if #buttons > 0 then
			v8 = buttons[1].outcome
		end

		v6 = getPrologueType(v7, v8)
	else
		v6 = nil
	end

	local ref = React.useRef(nil)
	React.useEffect(function()
		if ref.current == node then
			return
		end

		ref.current = node

		if v then
			v4.reverifyShown()
		elseif v2 and odpEventContext ~= nil then
			v4.prologueShown(odpEventContext, analyticsSessionId, launchProps)
		end

		if v3 and v5 and v6 then
			v5.prologueShown(v6)
		end
	end, {
		node,
		v,
		v2,
		odpEventContext,
		analyticsSessionId,
		launchProps,
		v4,
		v3,
		v5,
		v6
	})

	local actions = React.useMemo(function()
		local result = {}

		for k, v7 in props2.buttons or {} do
			local v8 = { text = v7.label, variant = 0, onActivated = 0 }
			local variant

			if k == 1 then
				variant = ButtonVariant.Emphasis
			else
				variant = ButtonVariant.Standard
			end

			v8.variant = variant
			function v8.onActivated()
				if v then
					v4.reverifyButtonClick(v7.outcome)
				elseif v2 and odpEventContext ~= nil then
					v4.prologueButtonClick(odpEventContext, analyticsSessionId, launchProps, v7.outcome)
				end

				if v3 and v5 and v6 then
					v5.prologueButtonClick(v7.outcome, v6)
				end

				report(v7.outcome)
			end

			table.insert(result, v8)
		end

		return result
	end, {
		props2,
		report,
		v,
		v2,
		odpEventContext,
		analyticsSessionId,
		launchProps,
		v4,
		v3,
		v5,
		v6
	})

	local onClose = React.useCallback(function()
		if v then
			v4.reverifyClose()
		elseif v2 and odpEventContext ~= nil then
			v4.prologueButtonClick(odpEventContext, analyticsSessionId, launchProps, "Cancel")
		end

		if v3 and v5 and v6 then
			v5.prologueButtonClick("Cancel", v6)
		end

		report("Cancel")
	end, {
		report,
		v,
		v2,
		odpEventContext,
		analyticsSessionId,
		launchProps,
		v4,
		v3,
		v5,
		v6
	})
	local v7

	if props2.imageUrl == nil then
		v7 = false
	else
		v7 = props2.imageUrl ~= ""
	end

	local v8 = useTokens()

	local linkerOptions = React.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return LinkBehavior.Webview
			end
		}
	end, {})

	local footerText = props2.footerText
	local v9

	if footerText == nil then
		v9 = false
	else
		v9 = footerText ~= ""
	end

	local text = React.useMemo(function()
		if v9 then
			return (prepareRichTextCopy(footerText))
		end

		return nil
	end, { footerText, v9 })

	local createElement = React.createElement
	local root = Dialog.Root
	local v10 = { size = DialogSize.Small, onClose = onClose }
	local illustration

	if v7 then
		illustration = React.createElement(Dialog.HeroMedia, { media = props2.imageUrl })
	end

	local children = {
		Illustration = illustration,
		Title = React.createElement(Dialog.Title, { text = props2.title }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(Dialog.Text, { Text = props2.description })
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = Orientation.Vertical,
			actions = actions
		}),
		Footer = 0
	}
	local footer

	if v9 then
		footer = React.createElement(Renderer, {
			text = text,
			textStyle = v8.Color.Content.Default,
			fontStyle = v8.Typography.BodySmall,
			linkerOptions = linkerOptions,
			wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = 4 },
			nodeProps = {
				LINK = { showUnderline = true }
			}
		})
	end

	children.Footer = footer
	return createElement(root, v10, children)
end

return TextScreenNode
