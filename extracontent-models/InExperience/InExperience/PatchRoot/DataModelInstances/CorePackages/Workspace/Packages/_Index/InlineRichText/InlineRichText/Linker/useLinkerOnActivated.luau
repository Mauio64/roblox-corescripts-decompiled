local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local React = require(InlineRichTextParent.React)
local useNavigateToWebview = require(InlineRichText.Linker.Behaviors.useNavigateToWebview)
local useInvokeLinkingProtocol = require(InlineRichText.Linker.Behaviors.useInvokeLinkingProtocol)
local useShowErrorToast = require(InlineRichText.Linker.Behaviors.useShowErrorToast)
local LinkBehavior = require(InlineRichText.Enums.LinkBehavior)
local v8 = require(InlineRichText.Logger):new(script.Name)

require(InlineRichText.Types)

local function useLinkerOnActivated(t1: {[any]: any}) -- line: 18
	-- upvalues: useNavigateToWebview (copy), useInvokeLinkingProtocol (copy), useShowErrorToast (copy), LinkBehavior (copy), React (copy), v8 (copy)
	local v11 = useNavigateToWebview()
	local v12 = useInvokeLinkingProtocol()
	local v13 = useShowErrorToast({
		errorToastTextOverride = t1.errorToastTextOverride
	})
	local t2 = {
		[LinkBehavior.Webview] = v11,
		[LinkBehavior.LinkingProtocol] = v12,
		[LinkBehavior.ErrorToast] = v13
	}

	return (React.useCallback(function(p1) -- line: 31
		-- upvalues: t2 (copy), v8 (copy)
		local v16 = t2[p1.linkBehavior]

		if v16 then
			v16(p1.url)

			return
		end

		v8:error(`Link activation failed with invalid link behavior: { p1.linkBehavior }. This behavior is either invalid or doesn't support activation.`)
	end, { t2 }))
end

return useLinkerOnActivated
