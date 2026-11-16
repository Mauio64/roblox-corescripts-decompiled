local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local EditBio = require(script.Parent.EditBio)
local Promise = require(parent.Promise)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local EditProfileStore = require(EditProfile.Stores.EditProfileStore)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)

return function(p)
	local v = useLocalUserId()
	local v2 = useSignalState(EditProfileStore.getDescription(v).data) or ""

	local state, setState = React.useState(v2)
	local state2, setState2 = React.useState(nil)

	local onDataChange = React.useCallback(function(p2)
		setState(p2)
		setState2(nil)
	end, {})

	React.useEffect(function()
		setState(v2)
	end, { v2 })

	React.useEffect(function()
		p.registerSaveHandler(function()
			return EditProfileStore.updateDescription(v, state):catch(function(p2)
				if not p2 then
					return
				end

				local v3 = nil

				if p2.errors and p2.errors[1] then
					v3 = p2.errors[1].code
				elseif p2.statusCode then
					v3 = p2.statusCode
				end

				if v3 then
					setState2(v3)
					AnalyticsServiceV2.sendError(v3)
				end

				return Promise.reject(p2)
			end)
		end)
	end, { p.registerSaveHandler, v, state })

	return React.createElement(EditBio, {
		bioText = state,
		onDataChange = onDataChange,
		errorCode = state2,
		textBoxRef = p.textBoxRef
	})
end
