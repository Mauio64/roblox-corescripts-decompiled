local parent = script.Parent.Parent
local parent2 = parent.Parent

local UserInputService = game:GetService("UserInputService")

local PermissionsProtocol = require(parent2.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default

local SaveCaptureToExternalStorage = require(parent.Thunks.SaveCaptureToExternalStorage)
local SaveCapturesToExternalStorage = require(parent.Thunks.SaveCapturesToExternalStorage)

require(parent.Types)

return function(list, callback, callback2): nil
	default:hasPermissions({ default.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p)
		local v = p.status == default.Status.AUTHORIZED or UserInputService:GetPlatform() == Enum.Platform.OSX

		if UserInputService:GetPlatform() == Enum.Platform.Android and not v then
			if not callback then
				return
			end

			assert(callback ~= nil, "openPermissionModal is not nil")
			callback()
		elseif not v then
			default:requestPermissions({ default.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p2)
				if p2.status == default.Status.AUTHORIZED or p2.status == default.Status.UNSUPPORTED then
					if #list > 0 then
						callback2(SaveCapturesToExternalStorage(list))
					else
						callback2(SaveCaptureToExternalStorage(list))
					end
				end
			end):catch(function() end)
		elseif #list > 0 then
			callback2(SaveCapturesToExternalStorage(list))
		else
			callback2(SaveCaptureToExternalStorage(list))
		end
	end):catch(function()
		if not (UserInputService:GetPlatform() == Enum.Platform.Android and callback) then
			return
		end

		assert(callback ~= nil, "openPermissionModal is not nil")
		callback()
	end)

	return nil
end
