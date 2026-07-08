local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local EditDisplayName = require(script.Parent.EditDisplayName)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local v6 = require(EditProfileParent.UserProfiles).Stores.UserProfileStore.get()
local useSignalState = require(EditProfileParent.SignalsReact).useSignalState
local updateUserDisplayName = require(EditProfile.Stores.Requests.updateUserDisplayName)
local validateUserDisplayName = require(EditProfile.Stores.Requests.validateUserDisplayName)
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalUserId (copy), React (copy), v6 (copy), useSignalState (copy), AnalyticsServiceV2 (copy), updateUserDisplayName (copy), validateUserDisplayName (copy), EditDisplayName (copy)
	local v12 = useLocalUserId()
	local v13 = React.useMemo(function() -- line: 23
		-- upvalues: v6 (copy), v12 (copy)
		return v6.fetchNamesByUserIds({ (tostring(v12)) })
	end, { v12 })
	local v14 = useSignalState(v13)
	local v15 = React.useMemo(function() -- line: 28
		-- upvalues: v14 (copy)
		if v14 and (v14.status == "success" and v14.data and #v14.data > 0) then
			return v14.data[1].names.getDisplayName(false) or ""
		end

		return ""
	end, { v14 })
	local v16, v17 = React.useState(v15)
	local v18 = React.useCallback(function(p1) -- line: 36
		-- upvalues: v17 (copy)
		v17(p1)
	end, {})

	React.useEffect(function() -- line: 40
		-- upvalues: AnalyticsServiceV2 (copy)
		AnalyticsServiceV2.sendDisplayNameModalLoaded()
	end, {})
	React.useEffect(function() -- line: 44
		-- upvalues: t1 (copy), updateUserDisplayName (copy), v12 (copy), v16 (copy), AnalyticsServiceV2 (copy), v14 (copy)
		t1.registerSaveHandler(function() -- line: 45
			-- upvalues: updateUserDisplayName (copy), v12 (copy), v16 (copy), AnalyticsServiceV2 (copy), v14 (copy)
			return updateUserDisplayName(tostring(v12), v16):andThen(function(p2) -- line: 46
				-- upvalues: AnalyticsServiceV2 (copy), v16 (copy), v14 (copy)
				AnalyticsServiceV2.sendDisplayNameSaved(v16)

				if v14 and (v14.data and #v14.data > 0) then
					local v22 = v14.data[1]

					if v22.names.setDisplayName then
						v22.names.setDisplayName(p2)
					end
				end
			end)
		end)
	end, {
		t1.registerSaveHandler,
		v12,
		v16,
		v14
	})

	return React.createElement(EditDisplayName, {
		initialDisplayName = v15,
		onDataChange = v18,
		validateDisplayName = function(s1: string) -- line: 58
			-- upvalues: validateUserDisplayName (copy), v12 (copy)
			return validateUserDisplayName(tostring(v12), s1)
		end,
		updateErrorState = t1.updateErrorState,
		textBoxRef = t1.textBoxRef
	})
end
