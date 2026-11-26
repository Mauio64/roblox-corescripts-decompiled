local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Rodux")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/Dash")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ActionTypes")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsRodux/ContactsRodux/Types/ReducerTypes")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactsRodux/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local v5 = {}

return function(p2)
	local networkingContacts = p2.networkingContacts

	return Rodux.createReducer(v5, {
		[networkingContacts.UploadContactsByUser.Succeeded.name] = function(p3, p4)
			if not getDeepValue(p4, "responseBody.matchedContactFields") then
				return {}
			end

			local v8 = {}

			Dash.forEach(p4.responseBody.matchedContactFields, function(p5)
				if not v8[p5.idAssignedByFE] then
					v8[p5.idAssignedByFE] = {}
				end

				v8[p5.idAssignedByFE][p5.userContactId] = true
			end)

			return v8
		end
	})
end
