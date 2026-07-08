local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local EditBio = require(script.Parent.EditBio)
local Promise = require(EditProfileParent.Promise)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local EditProfileStore = require(EditProfile.Stores.EditProfileStore)
local useSignalState = require(EditProfileParent.SignalsReact).useSignalState
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useLocalUserId (copy), EditProfileStore (copy), useSignalState (copy), React (copy), AnalyticsServiceV2 (copy), Promise (copy), EditBio (copy)
	local v11 = useLocalUserId()
	local v12 = EditProfileStore.getDescription(v11)
	local v13 = useSignalState(v12.data) or ""
	local v14, v15 = React.useState(v13)
	local v16, v17 = React.useState(nil)
	local v18 = React.useCallback(function(p1) -- line: 26
		-- upvalues: v15 (copy), v17 (copy)
		v15(p1)
		v17(nil)
	end, {})

	React.useEffect(function() -- line: 31
		-- upvalues: v15 (copy), v13 (copy)
		v15(v13)
	end, { v13 })
	React.useEffect(function() -- line: 35
		-- upvalues: t1 (copy), EditProfileStore (copy), v11 (copy), v14 (copy), v17 (copy), AnalyticsServiceV2 (copy), Promise (copy)
		t1.registerSaveHandler(function() -- line: 36
			-- upvalues: EditProfileStore (copy), v11 (copy), v14 (copy), v17 (copy), AnalyticsServiceV2 (copy), Promise (copy)
			return EditProfileStore.updateDescription(v11, v14):catch(function(p2) -- line: 37
				-- upvalues: v17 (copy), AnalyticsServiceV2 (copy), Promise (copy)
				if p2 then
					local code = nil

					if p2.errors and p2.errors[1] then
						code = p2.errors[1].code
					elseif p2.statusCode then
						code = p2.statusCode
					end

					if code then
						v17(code)
						AnalyticsServiceV2.sendError(code)
					end

					return Promise.reject(p2)
				end
			end)
		end)
	end, {
		t1.registerSaveHandler,
		v11,
		v14
	})

	return React.createElement(EditBio, {
		bioText = v14,
		onDataChange = v18,
		errorCode = v16,
		textBoxRef = t1.textBoxRef
	})
end
