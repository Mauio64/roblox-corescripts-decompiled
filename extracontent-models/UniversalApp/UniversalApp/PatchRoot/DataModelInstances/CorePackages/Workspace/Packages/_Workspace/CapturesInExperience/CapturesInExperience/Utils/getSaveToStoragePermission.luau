local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local default = require(ParentParentParent.PermissionsProtocol).PermissionsProtocol.default
local SaveCaptureToExternalStorage = require(ParentParent.Thunks.SaveCaptureToExternalStorage)
local SaveCapturesToExternalStorage = require(ParentParent.Thunks.SaveCapturesToExternalStorage)

require(ParentParent.Types)

return function(p1, p2, p3) -- line: 13
	-- upvalues: default (copy), UserInputService (copy), SaveCapturesToExternalStorage (copy), SaveCaptureToExternalStorage (copy)
	default:hasPermissions({ default.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p4) -- line: 15
		-- upvalues: default (copy), UserInputService (copy), p2 (copy), p1 (copy), p3 (copy), SaveCapturesToExternalStorage (copy), SaveCaptureToExternalStorage (copy)
		local v11 = p4.status == default.Status.AUTHORIZED or UserInputService:GetPlatform() == Enum.Platform.OSX

		if UserInputService:GetPlatform() == Enum.Platform.Android and not v11 then
			if not p2 then
				return
			end

			assert(p2 ~= nil, "openPermissionModal is not nil")
			p2()

			return
		end

		if not v11 then
			default:requestPermissions({ default.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p5) -- line: 26
				-- upvalues: default (copy), p1 (copy), p3 (copy), SaveCapturesToExternalStorage (copy), SaveCaptureToExternalStorage (copy)
				if p5.status == default.Status.AUTHORIZED or p5.status == default.Status.UNSUPPORTED then
					if #p1 > 0 then
						p3(SaveCapturesToExternalStorage(p1))

						return
					end

					p3(SaveCaptureToExternalStorage(p1))
				end
			end):catch(function() -- line: 38
			end)

			return
		end

		if #p1 > 0 then
			p3(SaveCapturesToExternalStorage(p1))

			return
		end

		p3(SaveCaptureToExternalStorage(p1))
	end):catch(function() -- line: 49
		-- upvalues: UserInputService (copy), p2 (copy)
		if UserInputService:GetPlatform() ~= Enum.Platform.Android then
			return
		end

		if not p2 then
			return
		end

		assert(p2 ~= nil, "openPermissionModal is not nil")
		p2()
	end)

	return nil
end
