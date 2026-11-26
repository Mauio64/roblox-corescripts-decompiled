local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/LinkingProtocol")
local leaveExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/leaveExperience")

local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local function openDeepLink(p2, p3)
	if default:isInternalDlicEnabled() then
		local internalDlic = default:createInternalDlic(p2, deepLinkSource.LuaInternal)

		if p3 then
			leaveExperience(function()
				default:detectDeeplinkIntent(internalDlic)
			end)
		else
			default:detectDeeplinkIntent(internalDlic)
		end
	elseif p3 then
		leaveExperience(function()
			default:detectURL(p2)
		end)
	else
		default:detectURL(p2)
	end
end

return openDeepLink
