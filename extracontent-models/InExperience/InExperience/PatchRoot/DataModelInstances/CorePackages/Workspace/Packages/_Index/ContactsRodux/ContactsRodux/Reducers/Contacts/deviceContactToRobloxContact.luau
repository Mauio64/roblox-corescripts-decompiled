local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Types = ParentParent.Types
local Rodux = require(ParentParentParent.Rodux)
local Dash = require(ParentParentParent.Dash)

require(Types.ActionTypes)
require(Types.ReducerTypes)

local getDeepValue = require(ParentParentParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local t1 = {}

return function(p1) -- line: 12
	-- upvalues: Rodux (copy), t1 (copy), getDeepValue (copy), Dash (copy)
	local networkingContacts = p1.networkingContacts

	return Rodux.createReducer(t1, {
		[networkingContacts.UploadContactsByUser.Succeeded.name] = function(_, p3) -- line: 16
			-- upvalues: getDeepValue (copy), Dash (copy)
			if not getDeepValue(p3, "responseBody.matchedContactFields") then
				return {}
			end

			local t2 = {}

			Dash.forEach(p3.responseBody.matchedContactFields, function(p4) -- line: 27
				-- upvalues: t2 (copy)
				if not t2[p4.idAssignedByFE] then
					t2[p4.idAssignedByFE] = {}
				end

				t2[p4.idAssignedByFE][p4.userContactId] = true
			end)

			return t2
		end
	})
end
