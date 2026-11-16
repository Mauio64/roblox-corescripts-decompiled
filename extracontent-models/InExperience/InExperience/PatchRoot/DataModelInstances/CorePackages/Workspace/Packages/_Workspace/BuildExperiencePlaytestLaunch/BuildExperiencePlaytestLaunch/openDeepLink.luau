local BuildExperiencePlaytestLaunch = script:FindFirstAncestor("BuildExperiencePlaytestLaunch")
local parent = BuildExperiencePlaytestLaunch.Parent

local LinkingProtocol = require(parent.LinkingProtocol)
local leaveExperience = require(BuildExperiencePlaytestLaunch.leaveExperience)

local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local function openDeepLink(p: string, flag: boolean)
	if default:isInternalDlicEnabled() then
		local internalDlic = default:createInternalDlic(p, DeepLinkSource.LuaInternal)

		if flag then
			leaveExperience(function()
				default:detectDeeplinkIntent(internalDlic)
			end)
		else
			default:detectDeeplinkIntent(internalDlic)
		end
	elseif flag then
		leaveExperience(function()
			default:detectURL(p)
		end)
	else
		default:detectURL(p)
	end
end

return openDeepLink
