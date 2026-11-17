local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local translate = require(script.Parent.translate)

local FFlagAbuseReportTranslateColorWrapper = require(GenericAbuseReporting.Flags.FFlagAbuseReportTranslateColorWrapper)

local useTokens = Foundation.Hooks.useTokens

local translateIntoString = translate.translateIntoString
local translateIntoRichTextString = translate.translateIntoRichTextString

local context = React.createContext(nil)
local ArTranslation = {}
ArTranslation.ArTranslationContext = context

function ArTranslation.ArTranslationProvider(p)
	local v

	if FFlagAbuseReportTranslateColorWrapper then
		v = useTokens()
	end

	local v2

	if FFlagAbuseReportTranslateColorWrapper then
		v2 = `#{v.Color.Content.Link.Color3:ToHex()}`
	else
		v2 = nil
	end

	local v3 = React.useMemo(function()
		return {
			translateIntoString = function(p2)
				return translateIntoString(p.translations, p2)
			end,
			translateIntoRichTextString = function(p2, flag: boolean?)
				return translateIntoRichTextString(p.translations, p2, v2, flag)
			end
		}
	end, { p.translations, v2 })

	return React.createElement(context.Provider, { value = v3 }, p.children)
end

function ArTranslation.useArTranslation()
	local v = React.useContext(context)

	if not v then
		error("Invalid use of `useArTranslation` hook. Ensure your component has an ancestor wrapped in `ArTranslationProvider`")
	end

	return v
end

return ArTranslation
