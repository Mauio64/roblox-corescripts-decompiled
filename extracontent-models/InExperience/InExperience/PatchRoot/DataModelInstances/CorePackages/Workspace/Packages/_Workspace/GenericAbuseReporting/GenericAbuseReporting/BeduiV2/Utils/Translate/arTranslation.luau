local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local translate = require(script.Parent.translate)

local translateIntoString = translate.translateIntoString
local translateIntoRichTextString = translate.translateIntoRichTextString

local context = React.createContext(nil)
local ArTranslation = {}
ArTranslation.ArTranslationContext = context

function ArTranslation.ArTranslationProvider(p)
	local v = React.useMemo(function()
		return {
			translateIntoString = function(p2)
				return translateIntoString(p.translations, p2)
			end,
			translateIntoRichTextString = function(p2)
				return translateIntoRichTextString(p.translations, p2)
			end
		}
	end, { p.translations })

	return React.createElement(context.Provider, { value = v }, p.children)
end

function ArTranslation.useArTranslation()
	local v = React.useContext(context)

	if not v then
		error("Invalid use of `useArTranslation` hook. Ensure your component has an ancestor wrapped in `ArTranslationProvider`")
	end

	return v
end

return ArTranslation
