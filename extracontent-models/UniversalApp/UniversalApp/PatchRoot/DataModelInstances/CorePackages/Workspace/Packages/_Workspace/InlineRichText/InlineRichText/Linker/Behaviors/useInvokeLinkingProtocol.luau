local InlineRichText = script:FindFirstAncestor("InlineRichText")
local RunService = game:GetService("RunService")
local InlineRichTextParent = InlineRichText.Parent
local React = require(InlineRichTextParent.React)
local default = require(InlineRichTextParent.LinkingProtocol).LinkingProtocol.default
local v6 = require(InlineRichText.Logger):new(script.Name)

require(InlineRichText.Types)

local v7 = RunService:IsStudio()

return function(_: nil) -- line: 15
	-- upvalues: React (copy), default (copy), v7 (copy), v6 (copy)
	return React.useCallback(function(s1: string) -- line: 16
		-- upvalues: default (copy), v7 (copy), v6 (copy)
		default:isURLRegistered(s1):andThen(function(p2) -- line: 17
			-- upvalues: v7 (copy), s1 (copy), default (copy), v6 (copy)
			if p2 then
				if v7 then
					print(`[OnActivated Debug] Detected URL with LinkingProtocol: { s1 }`)
				end

				default:detectURL(s1)

				return
			end

			default:openURL(s1):catch(function(p3) -- line: 24
				-- upvalues: v6 (copy), s1 (copy)
				v6:error("Failed to open URL: ", s1, " with error: ", p3)
			end)
		end)
	end, {})
end
