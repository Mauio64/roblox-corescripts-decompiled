local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local EditDisplayName = require(script.Parent.EditDisplayName)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UserProfiles = require(parent.UserProfiles)
local v = UserProfiles.Stores.UserProfileStore.get()
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local updateUserDisplayName = require(EditProfile.Stores.Requests.updateUserDisplayName)
local validateUserDisplayName = require(EditProfile.Stores.Requests.validateUserDisplayName)
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)

return function(props)
	local v2 = useLocalUserId()
	local v3 = useSignalState((React.useMemo(function()
		return v.fetchNamesByUserIds({ (tostring(v2)) })
	end, { v2 })))

	local initialDisplayName = React.useMemo(function()
		if v3 and v3.status == "success" and v3.data and #v3.data > 0 then
			return v3.data[1].names.getDisplayName(false) or ""
		end

		return ""
	end, { v3 })

	local state, setState = React.useState(initialDisplayName)
	local onDataChange = React.useCallback(function(p)
		setState(p)
	end, {})

	React.useEffect(function()
		AnalyticsServiceV2.sendDisplayNameModalLoaded()
	end, {})

	React.useEffect(function()
		props.registerSaveHandler(function()
			return updateUserDisplayName(tostring(v2), state):andThen(function(p)
				AnalyticsServiceV2.sendDisplayNameSaved(state)

				if v3 and v3.data and #v3.data > 0 then
					local v4 = v3.data[1]

					if v4.names.setDisplayName then
						v4.names.setDisplayName(p)
					end
				end
			end)
		end)
	end, { props.registerSaveHandler, v2, state, v3 })

	local function validateDisplayName(p: string)
		return validateUserDisplayName(tostring(v2), p)
	end

	return React.createElement(EditDisplayName, {
		initialDisplayName = initialDisplayName,
		onDataChange = onDataChange,
		validateDisplayName = validateDisplayName,
		updateErrorState = props.updateErrorState,
		textBoxRef = props.textBoxRef
	})
end
