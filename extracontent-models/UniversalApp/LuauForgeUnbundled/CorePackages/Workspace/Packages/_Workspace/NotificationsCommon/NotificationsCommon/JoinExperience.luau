local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/LinkingProtocol")
local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/SharedFlags").isSubjectToDesktopPolicies

return function(p2, p3)
	return pcall(function()
		if not p3 then
			default:isURLRegistered(p2):andThen(function(p4)
				if not p4 then
					return
				end

				if not default:isInternalDlicEnabled() then
					default:detectURL(p2)

					return
				end

				default:detectDeeplinkIntent((default:createInternalDlic(p2, deepLinkSource.LuaInternal)))
			end)
		elseif default:isInternalDlicEnabled() then
			local internalDlic = default:createInternalDlic(p2, deepLinkSource.LuaInternal)

			if not isSubjectToDesktopPolicies() then
				game:Shutdown()
			end

			default:isURLRegistered(p2):andThen(function(p4)
				if p4 then
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

			default:isURLRegistered(p2):andThen(function(p4)
				if p4 then
					default:detectURL(p2)
					return
				end

				game:Shutdown()
				default:detectURL(p2)
			end)
		end
	end)
end
