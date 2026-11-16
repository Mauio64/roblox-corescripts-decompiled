local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
require("@luauforge/deferred/ehC")
local dataStatus = require("@luauforge/deferred/egZ").DataStatus

local module3 = require("@luauforge/deferred/eha")
local module4 = require("@luauforge/deferred/ehO")
local module5 = require("@luauforge/deferred/ehs")
local module6 = require("@luauforge/deferred/eUx")
local module7 = require("@luauforge/deferred/ehd")
local module8 = require("@luauforge/deferred/ehM")
local module9 = require("@luauforge/deferred/ehB")
local module10 = require("@luauforge/deferred/ehP")
local module11 = require("@luauforge/deferred/eVG")
local module12 = require("@luauforge/deferred/eVL")
local module13 = require("@luauforge/deferred/eVR")
local module14 = require("@luauforge/deferred/eUy")
local module15 = require("@luauforge/deferred/eUL")
local module16 = require("@luauforge/deferred/eUF")
local module17 = require("@luauforge/deferred/ehV")
local fFlagUserListCtaAnalyticsEnabled = require("@luauforge/deferred/eUv").FFlagUserListCtaAnalyticsEnabled
local module18 = require("@luauforge/deferred/ehr")
local module19 = require("@luauforge/deferred/eVn")
local module20 = require("@luauforge/deferred/ehq")
local module21 = require("@luauforge/deferred/eVd")
local module22 = require("@luauforge/deferred/eVT")
local module23 = require("@luauforge/deferred/eVo")

local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local eventNames = module14.EventNames
local getMemberCtaEventName = module14.getMemberCtaEventName

local function SchoolMemberListPageContainer(p2)
	local navigation = p2.navigation

	local v5 = module7()
	local status = v5.status
	local school = v5.school
	local isLocked = v5.isLocked

	local v6 = navigation.getParam("justVerifiedSchoolName")

	if module20 and school ~= nil and school.name ~= nil and school.name ~= "" then
		v6 = school.name
	end

	local v7 = not school and "" or tostring(school.groupId)
	local v8 = module8(v7)

	local state, setState = module.useState(module3.MemberList.ALL_YEARS)

	local v10 = if school then school.memberCount else nil
	local v11 = module9(v7, state, v10)

	local v12 = module22()

	local v13 = module14.useSchoolsAnalytics()

	module.useEffect(function(): nil
		module5.markShown(module3.SchoolIsLive.APP_STORAGE_KEY)
		return nil
	end, {})

	local ref = module.useRef(false)
	module.useEffect(function(): nil
		if module17 or not module16 then
			return nil
		end

		if not ref.current and school ~= nil then
			ref.current = true
			v13(eventNames.MemberListPageLoad, { memberCount = school.memberCount })
		end

		return nil
	end, { school, v13 })
	local v14

	if fFlagUserListCtaAnalyticsEnabled then
		v14 = module.useCallback(function(p3)
			local memberCtaEventName = getMemberCtaEventName(p3.buttonType)

			if memberCtaEventName ~= nil then
				v13(memberCtaEventName, { targetUserId = p3.userId })
			end
		end, { v13 })
	end

	local v15 = module.useCallback(function(p3)
		setState(p3)
	end, {})

	local v16 = module10(navigation)
	local v17 = module.useCallback(function()
		if navigation.isFocused() then
			v16()
		end
	end, { navigation, v16 })

	local v18 = module.useCallback(function()
		if school == nil then
			return nil
		end

		return module23(school.groupId)
	end, { school })
	local v19

	if module19 then
		local v20 = module11("SchoolMemberList")

		local memberCount = if school ~= nil then school.memberCount else nil
		v19 = module.useCallback(function()
			if module16 then
				v13(eventNames.MemberListShareClick, { memberCount = memberCount })
			end

			v20()
		end, { memberCount, v20, v13 })
	else
		v19 = nil
	end

	local function fn()
		if module19 then
			return module.createElement(module.Fragment, nil, {
				ShareButton = module.createElement(iconButton, {
					icon = iconName.ArrowThickToRight,
					size = iconSize.Medium,
					variant = buttonVariant.Utility,
					onActivated = v19,
					LayoutOrder = 1
				}),
				OverflowMenu = module.createElement(module21, {
					onLeaveSchool = v18,
					LayoutOrder = 2
				})
			})
		end

		return module.createElement(module21, { onLeaveSchool = v18 })
	end

	local v22 = module.useCallback(fn, { v18, if module19 then v19 else nil })

	module.useEffect(function(): nil
		if module18 and isLocked then
			navigation.replace(module4.SchoolLocked)
		end

		return nil
	end, { isLocked, navigation })
	local v23

	if status == dataStatus.NotReady then
		v23 = module.createElement(module6)
	elseif not (school == nil or module18 and isLocked) then
		if v11.status == dataStatus.NotReady then
			v23 = module.createElement(module6)
		else
			local createElement = module.createElement
			local fragment = module.Fragment
			local v25 = {
				Page = module.createElement(module12, {
					schoolName = v6,
					memberCount = school.memberCount,
					classYears = v8.years,
					members = v11.entities,
					gradYear = state,
					onGradYearChanged = v15,
					onBack = v17,
					renderTrailing = v22,
					hasMore = v11.hasMore,
					isLoadingMore = v11.isLoadingMore,
					onLoadMore = v11.loadMore,
					onCtaActivated = v14
				}),
				RewardDialog = 0
			}

			local v26 = if v12.shouldShow then module.createElement(module13, {
				mediaImage = v12.mediaImage,
				onDismiss = v12.dismiss
			}) else nil
			v25.RewardDialog = v26
			v23 = createElement(fragment, nil, v25)
		end
	end

	if not (module17 and module16) then
		return v23
	end

	return module.createElement(module.Fragment, nil, {
		PageLoad = module.createElement(module15, {
			eventName = eventNames.MemberListPageLoad,
			fields = school ~= nil and { memberCount = school.memberCount } or nil,
			isReady = school ~= nil and status ~= dataStatus.NotReady
		}),
		Content = v23
	})
end

return SchoolMemberListPageContainer
