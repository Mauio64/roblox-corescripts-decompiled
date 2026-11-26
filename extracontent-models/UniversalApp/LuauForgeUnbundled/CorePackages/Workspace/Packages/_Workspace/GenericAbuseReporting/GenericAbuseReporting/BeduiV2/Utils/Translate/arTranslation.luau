local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local translate = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")

local FFlagAbuseReportTranslateColorWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportTranslateColorWrapper")

local useTokens = Foundation.Hooks.useTokens

local translateIntoString = translate.translateIntoString
local translateIntoRichTextString = translate.translateIntoRichTextString

local context = React.createContext(nil)

return {
	ArTranslationContext = context,
	ArTranslationProvider = function(p2)
		local v5 = if FFlagAbuseReportTranslateColorWrapper then useTokens() else nil

		local v6 = if FFlagAbuseReportTranslateColorWrapper then `#{v5.Color.Content.Link.Color3:ToHex()}` else nil

		local v7 = React.useMemo(function()
			return {
				translateIntoString = function(p3)
					return translateIntoString(p2.translations, p3)
				end,
				translateIntoRichTextString = function(p3, p4)
					return translateIntoRichTextString(p2.translations, p3, v6, p4)
				end
			}
		end, { p2.translations, v6 })

		return React.createElement(context.Provider, { value = v7 }, p2.children)
	end,
	useArTranslation = function()
		local v5 = React.useContext(context)

		if not v5 then
			error("Invalid use of `useArTranslation` hook. Ensure your component has an ancestor wrapped in `ArTranslationProvider`")
		end

		return v5
	end
}
