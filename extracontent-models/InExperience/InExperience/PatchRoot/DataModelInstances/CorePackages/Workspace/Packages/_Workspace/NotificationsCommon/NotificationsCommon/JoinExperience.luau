local parent = script.Parent.Parent
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local SharedFlags = require(parent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

return function(p, p2)
	return pcall(function()
		if not p2 then
			default:isURLRegistered(p):andThen(function(p3)
				if not p3 then
					return
				end

				if default:isInternalDlicEnabled() then
					default:detectDeeplinkIntent((default:createInternalDlic(p, DeepLinkSource.LuaInternal)))
				else
					default:detectURL(p)
				end
			end)
		elseif default:isInternalDlicEnabled() then
			local internalDlic = default:createInternalDlic(p, DeepLinkSource.LuaInternal)

			if not isSubjectToDesktopPolicies() then
				game:Shutdown()
			end

			default:isURLRegistered(p):andThen(function(p3)
				if p3 then
					default:detectDeeplinkIntent(internalDlic)
					return
				end

				game:Shutdown()
				default:detectDeeplinkIntent(internalDlic)
			end)
		else
			if not isSubjectToDesktopPolicies() then
				game:Shutdown()
			end

			default:isURLRegistered(p):andThen(function(p3)
				if p3 then
					default:detectURL(p)
					return
				end

				game:Shutdown()
				default:detectURL(p)
			end)
		end
	end)
end
