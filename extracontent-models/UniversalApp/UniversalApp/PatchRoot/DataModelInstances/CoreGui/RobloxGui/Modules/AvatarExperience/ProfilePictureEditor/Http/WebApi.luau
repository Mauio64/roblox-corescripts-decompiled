local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Url = require(Modules.LuaApp.Http.Url)
local Utils = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)

return {
	FetchPPEConfig = function(p1) -- line: 13
		-- upvalues: Url (copy)
		return p1(string.format("%s/v1/avatar/thumbnail-customizations", Url.AVATAR_URL), "GET")
	end,
	WritePPEConfig = function(p2, p3, p4, p5, p6, p7) -- line: 26
		-- upvalues: ArgCheck (copy), Url (copy), Utils (copy), HttpService (copy)
		ArgCheck.isType(p3, "userdata", "WebApi.WritePPEConfig expects thumbnailType to be a userdata")
		ArgCheck.isTypeOrNil(p4, "string", "WebApi.WritePPEConfig expects emoteAssetId to be a string or nil")
		ArgCheck.isType(p5, "number", "WebApi.WritePPEConfig expects cameraDistanceScale to be a number")
		ArgCheck.isType(p6, "number", "WebApi.WritePPEConfig expects cameraYRotDeg to be a number")
		ArgCheck.isType(p7, "number", "WebApi.WritePPEConfig expects fieldOfViewDeg to be a number")

		local v15 = string.format("%s/v1/avatar/thumbnail-customization", Url.AVATAR_URL)
		local v16 = not p4 and 0 or tonumber(p4)
		local v17 = Utils.ConvertThumbnailTypeToInt(p3)

		return p2(v15, "POST", {
			postBody = HttpService:JSONEncode({
				thumbnailType = v17,
				emoteAssetId = v16,
				camera = {
					fieldOfViewDeg = p7,
					yRotDeg = p6,
					distanceScale = p5
				}
			})
		})
	end
}
