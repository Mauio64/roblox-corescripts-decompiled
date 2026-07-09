local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local usePageNavigation = require(NotApprovedPage.Contexts.PageNavigationContext).usePageNavigation
local EVENT_TYPES = require(NotApprovedPageParent.NotApprovedPageShared).Constants.EVENT_TYPES

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local ArgCheck = require(NotApprovedPageParent.ArgCheck)
local Cryo = require(NotApprovedPageParent.Cryo)
local React = require(NotApprovedPageParent.React)
local createContext = React.createContext
local useCallback = React.useCallback
local useContext = React.useContext
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef

require(NotApprovedPage.Common.Types)

local v15 = createContext({})

return {
	PageAnalyticsProvider = function(t1: {[any]: any}) -- line: 52
		-- upvalues: usePageNavigation (copy), useRef (copy), useEffect (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), useCallback (copy), Cryo (copy), useMemo (copy), React (copy), v15 (copy)
		local v17 = usePageNavigation()
		local currentPage = v17.currentPage
		local currentPageName = v17.currentPageName
		local unmappedViolationKeys = v17.unmappedViolationKeys
		local v21 = useRef(DateTime.now().UnixTimestampMillis)
		local v22 = useRef(currentPage)
		local v23 = useRef(currentPageName)
		local v24 = useRef(true)

		local function getTimeOnPageMs() -- line: 63
			-- upvalues: v21 (copy)
			return DateTime.now().UnixTimestampMillis - v21.current
		end

		useEffect(function() -- line: 68
			-- upvalues: unmappedViolationKeys (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy)
			for _, v30 in unmappedViolationKeys do
				sendNotApprovedPageEvent({
					eventType = EVENT_TYPES.UnmappedViolationKey,
					unmappedViolationKey = v30
				})
			end
		end, {})
		useEffect(function() -- line: 78
			-- upvalues: v24 (copy), v21 (copy), currentPage (copy), v22 (copy), EVENT_TYPES (copy), sendNotApprovedPageEvent (copy), v23 (copy), currentPageName (copy)
			if v24.current then
				v24.current = false

				return
			end

			local v31 = DateTime.now().UnixTimestampMillis - v21.current
			local v32 = if not (currentPage > v22.current) then EVENT_TYPES.BackClicked else EVENT_TYPES.ContinueClicked

			sendNotApprovedPageEvent({
				eventType = v32,
				pageName = v23.current,
				timeOnPageMs = v31
			})
			v21.current = DateTime.now().UnixTimestampMillis
			v22.current = currentPage
			v23.current = currentPageName
		end, {
			currentPage,
			currentPageName
		})

		local v26 = useCallback(function(s1: string, p1) -- line: 106
			-- upvalues: v21 (copy), Cryo (copy), currentPageName (copy), sendNotApprovedPageEvent (copy)
			local v35 = DateTime.now().UnixTimestampMillis - v21.current
			local v36 = Cryo.Dictionary.join({
				eventType = s1,
				pageName = currentPageName,
				timeOnPageMs = v35
			}, p1 or {})

			sendNotApprovedPageEvent(v36)
		end, { currentPageName })
		local v27 = useMemo(function() -- line: 118
			-- upvalues: v26 (copy)
			return {
				sendPageEvent = v26
			}
		end, { v26 })

		return React.createElement(v15.Provider, {
			value = v27
		}, t1.children)
	end,
	usePageAnalytics = function() -- line: 129
		-- upvalues: useContext (copy), v15 (copy), ArgCheck (copy)
		local v28 = useContext(v15)

		ArgCheck.assert(v28 and v28.sendPageEvent ~= nil, "usePageAnalytics must be used within PageAnalyticsProvider (which must also be nested inside PageNavigationProvider)")

		return v28
	end
}
