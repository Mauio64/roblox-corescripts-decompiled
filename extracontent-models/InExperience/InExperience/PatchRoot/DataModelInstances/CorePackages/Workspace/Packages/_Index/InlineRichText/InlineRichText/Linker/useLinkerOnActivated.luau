local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local React = require(parent.React)

local useNavigateToWebview = require(InlineRichText.Linker.Behaviors.useNavigateToWebview)
local useInvokeLinkingProtocol = require(InlineRichText.Linker.Behaviors.useInvokeLinkingProtocol)
local useShowErrorToast = require(InlineRichText.Linker.Behaviors.useShowErrorToast)
local LinkBehavior = require(InlineRichText.Enums.LinkBehavior)
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

require(InlineRichText.Types)

local function useLinkerOnActivated(p)
	local v2 = useNavigateToWebview()
	local v3 = useInvokeLinkingProtocol()
	local v4 = useShowErrorToast({ errorToastTextOverride = p.errorToastTextOverride })

	local v5 = {
		[LinkBehavior.Webview] = v2,
		[LinkBehavior.LinkingProtocol] = v3,
		[LinkBehavior.ErrorToast] = v4
	}

	return (React.useCallback(function(p2)
		local v6 = v5[p2.linkBehavior]

		if v6 then
			v6(p2.url)
		else
			v:error(`Link activation failed with invalid link behavior: {p2.linkBehavior}. This behavior is either invalid or doesn't support activation.`)
		end
	end, { v5 }))
end

return useLinkerOnActivated
