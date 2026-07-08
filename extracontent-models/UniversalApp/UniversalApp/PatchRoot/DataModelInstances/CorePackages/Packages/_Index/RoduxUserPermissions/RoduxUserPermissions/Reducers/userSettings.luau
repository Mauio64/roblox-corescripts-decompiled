local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)

require(ParentParent.Types.ReducerTypes)

local t1 = {
	canUploadContacts = nil
}

return function(p1) -- line: 10
	-- upvalues: Rodux (copy), t1 (copy)
	local networkingUserSettings = p1.networkingUserSettings

	return Rodux.createReducer(t1, {
		[networkingUserSettings.GetUserSettings.Succeeded.name] = function(_, p3) -- line: 14
			return {
				canUploadContacts = p3.responseBody and p3.responseBody.canUploadContacts
			}
		end,
		[networkingUserSettings.UpdateUserSettings.Succeeded.name] = function(p4, p5) -- line: 22
			if p5.postBody and p5.postBody.canUploadContacts ~= nil then
				return {
					canUploadContacts = p5.postBody.canUploadContacts
				}
			end

			return p4
		end
	})
end
