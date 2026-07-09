local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES
local useCallback = require(NotApprovedPageParent.React).useCallback
local useDispatch = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(NotApprovedPageParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(NotApprovedPageParent.RoactServiceTags).RoactNetworking
local AppGuiService = require(NotApprovedPageParent.RoactServiceTags).AppGuiService
local Responsive = require(NotApprovedPageParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local LogoutReasonNames = require(NotApprovedPageParent.AuthCommon).Enums.LogoutReasonNames
local ConsoleDisconnect = require(NotApprovedPageParent.AuthCommon).Thunks.ConsoleDisconnect

local function useLogout(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 30
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), AppGuiService (copy), usePreferredInput (copy), Responsive (copy), useCallback (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), ConsoleDisconnect (copy), LogoutReasonNames (copy)
	local v17 = useDispatch()
	local v18 = useRoactService(RoactNetworking)
	local v19 = useRoactService(AppGuiService)
	local v20 = usePreferredInput() == Responsive.Input.Directional

	return (useCallback(function() -- line: 36
		-- upvalues: p1 (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), v20 (copy), v17 (copy), ConsoleDisconnect (copy), v18 (copy), v19 (copy), p2 (copy), LogoutReasonNames (copy)
		p1(true)
		sendNotApprovedPageEvent({
			eventType = EVENT_TYPES.LogoutClicked
		})

		if v20 then
			v17(ConsoleDisconnect(v18, v19, p2))

			return
		end

		v17(p2(v18, v19, LogoutReasonNames.Moderation))
	end, {
		v17,
		v18,
		v19,
		p2,
		v20,
		p1
	}))
end

return useLogout
