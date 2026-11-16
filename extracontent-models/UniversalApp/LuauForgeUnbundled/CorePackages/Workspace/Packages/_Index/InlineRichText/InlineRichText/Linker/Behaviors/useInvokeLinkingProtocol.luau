local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/React")
local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/LinkingProtocol")
local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("useInvokeLinkingProtocol")

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")
local isStudio = RunService:IsStudio()

return function(p2)
	return React.useCallback(function(p3)
		default:isURLRegistered(p3):andThen(function(p4)
			if not p4 then
				default:openURL(p3):catch(function(p5)
					v5:error("Failed to open URL: ", p3, " with error: ", p5)
				end)

				return
			end

			if isStudio then
				print(`[OnActivated Debug] Detected URL with LinkingProtocol: {p3}`)
			end

			if not default:isInternalDlicEnabled() then
				default:detectURL(p3)
				return
			end

			default:detectDeeplinkIntent((default:createInternalDlic(p3, deepLinkSource.LuaInternal)))
		end)
	end, {})
end
