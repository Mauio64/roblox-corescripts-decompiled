local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local translate = require(script.Parent.translate)
local useTokens = Foundation.Hooks.useTokens
local translateIntoString = translate.translateIntoString
local translateIntoRichTextString = translate.translateIntoRichTextString
local v8 = React.createContext(nil)

return {
	ArTranslationContext = v8,
	ArTranslationProvider = function(t1: {[any]: any}) -- line: 27
		-- upvalues: useTokens (copy), React (copy), translateIntoString (copy), translateIntoRichTextString (copy), v8 (copy)
		local LinkColor3 = useTokens().Color.Content.Link.Color3
		local v11 = React.useMemo(function() -- line: 31
			-- upvalues: translateIntoString (copy), t1 (copy), translateIntoRichTextString (copy), LinkColor3 (copy)
			return {
				translateIntoString = function(p1) -- line: 32
					-- upvalues: translateIntoString (copy), t1 (copy)
					return translateIntoString(t1.translations, p1)
				end,
				translateIntoRichTextString = function(p2) -- line: 36
					-- upvalues: translateIntoRichTextString (copy), t1 (copy), LinkColor3 (copy)
					return translateIntoRichTextString(t1.translations, p2, LinkColor3)
				end
			}
		end, {
			t1.translations,
			LinkColor3
		})

		return React.createElement(v8.Provider, {
			value = v11
		}, t1.children)
	end,
	useArTranslation = function() -- line: 51
		-- upvalues: React (copy), v8 (copy)
		local v12 = React.useContext(v8)

		if not v12 then
			error("Invalid use of `useArTranslation` hook. Ensure your component has an ancestor wrapped in `ArTranslationProvider`")
		end

		return v12
	end
}
