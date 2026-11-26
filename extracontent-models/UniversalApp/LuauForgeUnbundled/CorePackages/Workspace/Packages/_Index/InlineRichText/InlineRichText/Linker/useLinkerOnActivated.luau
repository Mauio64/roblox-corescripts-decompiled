local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/React")

local useNavigateToWebview = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Linker/Behaviors/useNavigateToWebview")
local useInvokeLinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Linker/Behaviors/useInvokeLinkingProtocol")
local useShowErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Linker/Behaviors/useShowErrorToast")
local LinkBehavior = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/LinkBehavior")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("useLinkerOnActivated")

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

local function useLinkerOnActivated(p2)
	local v6 = useNavigateToWebview()
	local v7 = useInvokeLinkingProtocol()
	local v8 = useShowErrorToast({ errorToastTextOverride = p2.errorToastTextOverride })

	local v9 = {
		[LinkBehavior.Webview] = v6,
		[LinkBehavior.LinkingProtocol] = v7,
		[LinkBehavior.ErrorToast] = v8
	}

	return React.useCallback(function(p3)
		local v10 = v9[p3.linkBehavior]

		if v10 then
			v10(p3.url)
		else
			v5:error(`Link activation failed with invalid link behavior: {p3.linkBehavior}. This behavior is either invalid or doesn't support activation.`)
		end
	end, { v9 })
end

return useLinkerOnActivated
