local Parent = script:FindFirstAncestor("BuildExperience").Parent
local default = require(Parent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local isSubjectToDesktopPolicies = require(Parent.SharedFlags).isSubjectToDesktopPolicies

return {
	getGameShareUrl = function(n1: number) -- line: 15
		return `https://www.roblox.com/games/{ n1 }`
	end,
	sharePublishedExperience = function(n2: number) -- line: 19
		-- upvalues: isSubjectToDesktopPolicies (copy), default (copy)
		local v6 = `https://www.roblox.com/games/{ n2 }`

		if isSubjectToDesktopPolicies() then
			default:setClipboardText({
				context = "BuildExperienceGameShare",
				text = v6
			})

			return {
				copiedToClipboard = true,
				url = v6
			}
		end

		default:shareUrl({
			context = "BuildExperienceGameShare",
			url = v6
		})

		return {
			copiedToClipboard = false,
			url = v6
		}
	end
}
