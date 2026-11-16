local parent = script.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
require(parent.Types.ReducerTypes)

local v = { canUploadContacts = nil }

return function(p)
	local networkingUserSettings = p.networkingUserSettings

	return Rodux.createReducer(v, {
		[networkingUserSettings.GetUserSettings.Succeeded.name] = function(_, p2)
			return {
				canUploadContacts = p2.responseBody and p2.responseBody.canUploadContacts
			}
		end,
		[networkingUserSettings.UpdateUserSettings.Succeeded.name] = function(p2, p3)
			if p3.postBody and p3.postBody.canUploadContacts ~= nil then
				return { canUploadContacts = p3.postBody.canUploadContacts }
			end

			return p2
		end
	})
end
