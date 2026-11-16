local module = require("@luauforge/deferred/fUX")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/Cryo")
local constants = require("@luauforge/deferred/fUP").Constants
require("@luauforge/deferred/fUY")
local module3 = require("@luauforge/deferred/fUZ")
require("@luauforge/deferred/fUR")
local usePageNavigation = require("@luauforge/deferred/fVa").usePageNavigation

local module4 = require("@luauforge/deferred/fUU")
local createContext = module4.createContext
local useCallback = module4.useCallback
local useContext = module4.useContext
local useEffect = module4.useEffect
local useMemo = module4.useMemo
local useRef = module4.useRef

local EVENT_TYPES = constants.EVENT_TYPES

local fFlagKidsNotApprovedPageTreatment = require("@luauforge/deferred/fVf").FFlagKidsNotApprovedPageTreatment

local context = createContext({})

return {
	PageAnalyticsProvider = function(p2)
		local v5 = usePageNavigation()
		local currentPage = v5.currentPage
		local currentPageName = v5.currentPageName
		local unmappedViolationKeys = v5.unmappedViolationKeys

		local v6 = useRef(DateTime.now().UnixTimestampMillis)
		local v7 = useRef(currentPage)
		local v8 = useRef(currentPageName)
		local v9 = useRef(true)

		local isKidsTreatment = p2.isKidsTreatment or false

		local function getTimeOnPageMs()
			return DateTime.now().UnixTimestampMillis - v6.current
		end

		useEffect(function()
			for k, unmappedViolationKey in unmappedViolationKeys do
				local v10 = {
					eventType = EVENT_TYPES.UnmappedViolationKey,
					unmappedViolationKey = unmappedViolationKey
				}

				if fFlagKidsNotApprovedPageTreatment then
					v10.isKidsTreatment = tostring(isKidsTreatment)
				end

				module3(v10)
			end
		end, {})

		useEffect(function()
			if v9.current then
				v9.current = false
				return
			end

			if currentPage == v7.current then
				return
			end

			local v10 = DateTime.now().UnixTimestampMillis - v6.current

			local v12 = {
				eventType = if currentPage > v7.current then EVENT_TYPES.ContinueClicked else EVENT_TYPES.BackClicked,
				pageName = v8.current,
				timeOnPageMs = v10
			}

			if fFlagKidsNotApprovedPageTreatment then
				v12.isKidsTreatment = tostring(isKidsTreatment)
			end

			module3(v12)

			v6.current = DateTime.now().UnixTimestampMillis
			v7.current = currentPage
			v8.current = currentPageName
		end, { currentPage, currentPageName, isKidsTreatment })

		local v10 = useCallback(function(p3, options)
			local v11 = DateTime.now().UnixTimestampMillis - v6.current

			local joined = Cryo.Dictionary.join(
				{ eventType = p3, pageName = currentPageName, timeOnPageMs = v11 },
				options or {}
			)

			if fFlagKidsNotApprovedPageTreatment then
				joined.isKidsTreatment = tostring(isKidsTreatment)
			end

			module3(joined)
		end, { currentPageName, isKidsTreatment })

		local v11 = useMemo(function()
			return { sendPageEvent = v10 }
		end, { v10 })

		return module4.createElement(context.Provider, { value = v11 }, p2.children)
	end,
	usePageAnalytics = function()
		local v5 = useContext(context)

		module.assert(
			v5 and v5.sendPageEvent ~= nil,
			"usePageAnalytics must be used within PageAnalyticsProvider (which must also be nested inside PageNavigationProvider)"
		)

		return v5
	end
}
