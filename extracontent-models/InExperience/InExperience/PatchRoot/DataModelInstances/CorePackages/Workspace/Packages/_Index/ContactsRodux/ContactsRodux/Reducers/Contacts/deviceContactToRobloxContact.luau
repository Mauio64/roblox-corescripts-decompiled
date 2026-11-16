local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local types = parent.Types
local Rodux = require(parent2.Rodux)
local Dash = require(parent2.Dash)
require(types.ActionTypes)
require(types.ReducerTypes)
local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local v = {}

return function(p)
	local networkingContacts = p.networkingContacts

	return Rodux.createReducer(v, {
		[networkingContacts.UploadContactsByUser.Succeeded.name] = function(_, p2)
			if not getDeepValue(p2, "responseBody.matchedContactFields") then
				return {}
			end

			local v2 = {}

			Dash.forEach(p2.responseBody.matchedContactFields, function(p3)
				if not v2[p3.idAssignedByFE] then
					v2[p3.idAssignedByFE] = {}
				end

				v2[p3.idAssignedByFE][p3.userContactId] = true
			end)

			return v2
		end
	})
end
