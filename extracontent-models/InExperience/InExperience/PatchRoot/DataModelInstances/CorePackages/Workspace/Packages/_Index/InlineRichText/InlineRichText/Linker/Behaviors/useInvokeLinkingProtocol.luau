local InlineRichText = script:FindFirstAncestor("InlineRichText")
local RunService = game:GetService("RunService")
local parent = InlineRichText.Parent

local React = require(parent.React)
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

require(InlineRichText.Types)
local isStudio = RunService:IsStudio()

return function(_: nil)
	return React.useCallback(function(p: string)
		default:isURLRegistered(p):andThen(function(p2)
			if not p2 then
				default:openURL(p):catch(function(p3)
					v:error("Failed to open URL: ", p, " with error: ", p3)
				end)

				return
			end

			if isStudio then
				print(`[OnActivated Debug] Detected URL with LinkingProtocol: {p}`)
			end

			if not default:isInternalDlicEnabled() then
				default:detectURL(p)
				return
			end

			default:detectDeeplinkIntent((default:createInternalDlic(p, DeepLinkSource.LuaInternal)))
		end)
	end, {})
end
