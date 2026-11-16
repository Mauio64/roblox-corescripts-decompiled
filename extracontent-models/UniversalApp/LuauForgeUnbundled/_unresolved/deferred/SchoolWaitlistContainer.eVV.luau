local module = require("@luauforge/deferred/egU")
local module2 = require("@luauforge/deferred/eUP")
local module3 = require("@luauforge/deferred/eVf")
local module4 = require("@luauforge/deferred/eVH")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization
local dataStatus = require("@luauforge/deferred/egZ").DataStatus

local module5 = require("@luauforge/deferred/eha")
local module6 = require("@luauforge/deferred/egW")
local useExperienceIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/InExperienceSideSheet/Hooks/useExperienceIcon")
local searchFilterPredicate = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Utils/searchFilterPredicate")
require("@luauforge/deferred/egX")
local module9 = require("@luauforge/deferred/ehb")
local module10 = require("@luauforge/deferred/ehO")
local module11 = require("@luauforge/deferred/eUx")
local module12 = require("@luauforge/deferred/eUX")
local module13 = require("@luauforge/deferred/eVd")
local module14 = require("@luauforge/deferred/eVo")
local module15 = require("@luauforge/deferred/ehd")
local module16 = require("@luauforge/deferred/ehP")
local module17 = require("@luauforge/deferred/eVI")
local module18 = require("@luauforge/deferred/eVG")
local module19 = require("@luauforge/deferred/eVW")
local module20 = require("@luauforge/deferred/eWb")
local module21 = require("@luauforge/deferred/eUy")
local module22 = require("@luauforge/deferred/eUL")
local module23 = require("@luauforge/deferred/eUF")
local module24 = require("@luauforge/deferred/ehV")
local module25 = require("@luauforge/deferred/ehr")
local module26 = require("@luauforge/deferred/eVn")
local module27 = require("@luauforge/deferred/eVm")
local module28 = require("@luauforge/deferred/ehq")

local useDispatch = module2.Hooks.RoactRodux.useDispatch

local eventNames = module21.EventNames

local function getRewardMediaImage(list)
	local v5 = if list then list[1] else nil

	if v5 then
		return (useExperienceIcon(v5.assetId))
	end

	return nil
end

local function SchoolWaitlistContainer(p2)
	local navigation = p2.navigation

	local v5 = module21.useSchoolsAnalytics()

	local v6 = useLocalization({
		headerTitle = module9.WaitlistHeaderTitle,
		linkCopied = module9.LinkCopied,
		somethingWentWrong = module9.SomethingWentWrong
	})

	local v7 = module15()
	local status = v7.status
	local school = v7.school
	local isLocked = v7.isLocked

	local v8 = navigation.getParam("justVerifiedSchoolName")

	if module28 and school ~= nil and school.name ~= nil and school.name ~= "" then
		v8 = school.name
	end

	local v9 = school == nil and 0 or school.membersNeededForNextTier
	local v10

	if school == nil or not searchFilterPredicate(school.subtype) then
		v10 = module6.SchoolWaitlistVariant.School
	else
		v10 = module6.SchoolWaitlistVariant.Alumni
	end

	local ref = module.useRef(false)
	module.useEffect(function(): nil
		if module24 or not module23 then
			return nil
		end

		if not ref.current and status ~= dataStatus.NotReady and school ~= nil then
			ref.current = true
			v5(eventNames.WaitlistPageLoad, { variant = v10 })
		end

		return nil
	end, { status, school, v10, v5 })

	local v11 = useDispatch()
	local profileCopyLinkEnabled = module4.getAppFeaturePolicies().getProfileCopyLinkEnabled()
	local ref2 = module.useRef(false)
	module.useEffect(function()
		return function()
			ref2.current = true
		end
	end, {})

	local v12 = module16(navigation)
	local v13 = module.useCallback(function()
		if navigation.isFocused() then
			v12()
		end
	end, { navigation, v12 })
	local v14

	if module26 then
		local v15 = module18()
		v14 = module.useCallback(function()
			if module23 then
				v5(eventNames.WaitlistShareClick, { variant = v10 })
			end

			v15()
		end, { v10, v5, v15 })
	else
		v14 = module.useCallback(function()
			if module23 then
				v5(eventNames.WaitlistShareClick, { variant = v10 })
			end

			module17({
				onShared = profileCopyLinkEnabled and function()
					v11(module3.Actions.SetCurrentToastMessage({
						toastMessage = v6.linkCopied,
						isLocalized = true
					}))
				end or nil,
				onError = function()
					v11(module3.Actions.SetCurrentToastMessage({
						toastMessage = v6.somethingWentWrong,
						isLocalized = true
					}))
				end,
				isCancelledRef = ref2
			})
		end, {
			v10,
			v5,
			v11,
			v6.linkCopied,
			v6.somethingWentWrong,
			ref2,
			profileCopyLinkEnabled
		})
	end

	local v15 = module.useCallback(function()
		if school == nil then
			return
		end

		return module14(school.groupId)
	end, { school })

	local v16 = module.useCallback(function()
		return module.createElement(module13, { onLeaveSchool = v15 })
	end, { v15 })

	module.useEffect(function(): nil
		if module25 and isLocked then
			navigation.replace(module10.SchoolLocked)
		end

		return nil
	end, { isLocked, navigation })
	local v17

	if status == dataStatus.NotReady then
		v17 = module.createElement(module11)
	elseif not (school == nil or module25 and isLocked) then
		local createElement = module.createElement
		local v19 = {
			title = v6.headerTitle,
			onBack = v13,
			renderTrailing = v16,
			fillContent = true,
			maxContentWidth = module5.Waitlist.MAX_CONTENT_WIDTH,
			testId = "schools-waitlist-page"
		}

		local createElement2 = module.createElement

		local v22 = {
			variant = v10,
			schoolName = v8,
			remainingCount = v9,
			shareMedia = 0,
			onShare = 0,
			inviteList = 0
		}
		local v23

		if v10 == module6.SchoolWaitlistVariant.School then
			local rewards = school.rewards
			local v24 = if rewards then rewards[1] else nil

			if v24 then
				v23 = useExperienceIcon(v24.assetId)
			end
		end

		v22.shareMedia = v23

		v22.onShare = v14

		local v24 = if module27 then module.createElement(module20, { LayoutOrder = 4 }) else nil
		v22.inviteList = v24
		v17 = createElement(module12, v19, { Content = createElement2(module19, v22) })
	end

	if not (module24 and module23) then
		return v17
	end

	return module.createElement(module.Fragment, nil, {
		PageLoad = module.createElement(module22, {
			eventName = eventNames.WaitlistPageLoad,
			fields = { variant = v10 },
			isReady = school ~= nil and status ~= dataStatus.NotReady
		}),
		Content = v17
	})
end

return SchoolWaitlistContainer
