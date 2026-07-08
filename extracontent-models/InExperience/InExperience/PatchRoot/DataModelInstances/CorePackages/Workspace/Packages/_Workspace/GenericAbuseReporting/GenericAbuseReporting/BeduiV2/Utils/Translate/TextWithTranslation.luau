local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local ControlState = Foundation.Enums.ControlState
local FoundationText = Foundation.Text
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local v9 = game:DefineFastFlag("AddFontStyleToTextWithTranslation", false)
local v10 = game:DefineFastFlag("AddUnderlineToLinksInTextWithTranslation", false)

local function TextWithTranslation(t1: {[any]: any}) -- line: 36
	-- upvalues: useArTranslation (copy), useOpenLink (copy), React (copy), v10 (copy), ControlState (copy), FoundationText (copy), v9 (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local translateIntoRichTextString = useArTranslation().translateIntoRichTextString
	local v15 = useOpenLink()
	local v16, v17 = React.useState(false)
	local v18, v19 = React.useMemo(function() -- line: 42
		-- upvalues: translateIntoRichTextString (copy), t1 (copy)
		return translateIntoRichTextString(t1.input)
	end, {
		t1.input,
		translateIntoRichTextString
	})
	local v20 = React.useCallback(function() -- line: 46
		-- upvalues: v19 (copy), v15 (copy), translateIntoString (copy), t1 (copy)
		local href = nil

		if v19 ~= nil then
			href = v19.href
		end

		v15(translateIntoString(t1.input), href)
	end, {
		v19,
		t1.input,
		v15,
		translateIntoString
	})
	local v21 = if not v10 then nil else React.useCallback(function(p1) -- line: 55
		-- upvalues: ControlState (copy), v17 (copy)
		if p1 == ControlState.Hover then
			v17(true)

			return
		end

		v17(false)
	end, {})

	return React.createElement(FoundationText, {
		RichText = true,
		TextWrapped = true,
		Text = if not v16 then v18 else `<u>{ v18 }</u>`,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = if not v9 then nil else t1.fontStyle,
		tag = t1.tag,
		LayoutOrder = t1.layoutOrder,
		onActivated = if v19 == nil then nil else v20,
		onStateChanged = if not v10 or v19 == nil then nil else v21
	})
end

return React.memo(TextWithTranslation)
