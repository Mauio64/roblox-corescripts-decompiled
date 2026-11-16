local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local translate = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")

local translateIntoString = translate.translateIntoString
local translateIntoRichTextString = translate.translateIntoRichTextString

local context = React.createContext(nil)

return {
	ArTranslationContext = context,
	ArTranslationProvider = function(p2)
		local v5 = React.useMemo(function()
			return {
				translateIntoString = function(p3)
					return translateIntoString(p2.translations, p3)
				end,
				translateIntoRichTextString = function(p3)
					return translateIntoRichTextString(p2.translations, p3)
				end
			}
		end, { p2.translations })

		return React.createElement(context.Provider, { value = v5 }, p2.children)
	end,
	useArTranslation = function()
		local v5 = React.useContext(context)

		if not v5 then
			error("Invalid use of `useArTranslation` hook. Ensure your component has an ancestor wrapped in `ArTranslationProvider`")
		end

		return v5
	end
}
