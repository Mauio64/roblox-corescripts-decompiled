local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/eUT")
local module4 = require("@luauforge/deferred/eVa")
local module5 = require("@luauforge/deferred/ehC")

local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization
local module6 = require("@luauforge/deferred/ehb")
local module7 = require("@luauforge/deferred/eha")
local module8 = require("@luauforge/deferred/egW")
local fFlagUserListCtaAnalyticsEnabled = require("@luauforge/deferred/eUv").FFlagUserListCtaAnalyticsEnabled
local module9 = require("@luauforge/deferred/eVM")
local module10 = require("@luauforge/deferred/eVN")
local v5 = if module10 then require("@luauforge/deferred/eVO") else nil
local module11 = require("@luauforge/deferred/eUX")
local module12 = require("@luauforge/deferred/eVQ")

local view = Foundation.View
local text = Foundation.Text
local loading = Foundation.Loading
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local assets = module3.Assets
local preloadAsset = module3.preloadAsset
local emptyState = module7.MemberList.EmptyState
preloadAsset(emptyState.ASSET_KEY)
local v6 = assets[emptyState.ASSET_KEY] or {}

local verticalUserList = module5.VerticalUserList.VerticalUserList
local userListFooter = module5.UserListFooter

local v7 = { showSubtitle = true, showPresence = true }

local v8 = {
	friendshipOriginSourceType = module8.FriendshipOriginSourceType.SchoolMemberList,
	primaryCtaMinWidth = 64,
	primaryCtaMaxWidth = 90,
	showSelfProfileCta = true
}

if module9 then
	v8.chatEntryPoint = module4.Enums.ChatEntryPointNames.SchoolMemberList
end

local fn = v5 and function(p2, p3)
	return module.createElement(v5, { createRow = p2, entity = p3 })
end or nil

local function SchoolMemberListPage(props)
	local classYears = props.classYears
	local v9 = useTokens()
	local v10 = #props.members == 0

	local v11 = v8

	if fFlagUserListCtaAnalyticsEnabled then
		v11 = module.useMemo(function()
			local clone = table.clone(v8)
			clone.onCtaActivated = props.onCtaActivated
			return clone
		end, { props.onCtaActivated })
	end

	local v12 = useLocalization({
		pageTitle = module6.PageTitle,
		membersWithCount = {
			module6.MembersWithCount,
			count = props.memberCount
		},
		apply = module6.FilterApply,
		selectGraduationYear = module6.GraduationYearHeading,
		gradYear = module6.FilterGradYear,
		allYears = module6.FilterAllYears,
		noResults = module6.NoResults
	})

	local v13 = module.useMemo(function()
		local result = {
			{ id = module7.MemberList.ALL_YEARS, text = v12.allYears }
		}

		for k, classYear in classYears do
			table.insert(result, {
				id = tostring(classYear),
				text = tostring(classYear)
			})
		end

		return result
	end, { v12.allYears, classYears })

	module.useEffect(function(): nil
		if v10 and props.hasMore and not props.isLoadingMore and props.onLoadMore then
			props.onLoadMore()
		end

		return nil
	end, { v10, props.hasMore, props.isLoadingMore, props.onLoadMore })

	local v14 = not (props.schoolName == nil) and props.schoolName ~= ""

	local createElement = module.createElement

	local v18 = if v14 then module.createElement(
		view,
		{ tag = "col gap-xsmall size-full-0 auto-y", LayoutOrder = 1 },
		{
			Heading = module.createElement(text, {
				tag = "size-full-0 auto-y text-heading-medium text-align-x-left content-default",
				Text = props.schoolName,
				LayoutOrder = 1
			}),
			Body = module.createElement(text, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
				Text = v12.membersWithCount,
				LayoutOrder = 2
			})
		}
	) else nil
	local element = createElement(
		view,
		{
			tag = "col gap-xxlarge size-full-0 auto-y padding-bottom-small",
			LayoutOrder = 1
		},
		{
			SchoolInfo = v18,
			Filters = module.createElement(
				view,
				{
					tag = "row align-y-center gap-small size-full-0 auto-y",
					LayoutOrder = 2
				},
				{
					GradYear = module.createElement(module12, {
						label = v12.gradYear,
						sheetTitle = v12.selectGraduationYear,
						applyText = v12.apply,
						value = props.gradYear,
						defaultValue = module7.MemberList.ALL_YEARS,
						options = v13,
						layoutOrder = 1,
						onChanged = props.onGradYearChanged
					})
				}
			)
		}
	)

	local v19 = nil

	if props.isLoadingMore then
		v19 = module.createElement(view, {
			tag = {
				["align-x-center size-full-0"] = true,
				["align-y-center fill"] = v10,
				["auto-y padding-y-large"] = not v10
			},
			LayoutOrder = v10 and 2 or nil
		}, {
			Spinner = module.createElement(loading, { size = iconSize.Medium })
		})
	elseif props.hasMore then
		v19 = module.createElement(userListFooter, {
			hasMore = props.hasMore,
			onLoadMore = props.onLoadMore
		})
	end

	if v10 then
		local v20

		if not (props.isLoadingMore or props.hasMore) then
			local v21 = emptyState.IMAGE_HEIGHT * v9.Config.UI.Scale
			local v22 = emptyState.IMAGE_WIDTH * v9.Config.UI.Scale

			v20 = module.createElement(
				view,
				{
					tag = "col align-x-center size-full-0 auto-y padding-top-xxlarge",
					LayoutOrder = 2
				},
				{
					Icon = module.createElement(Foundation.Image, {
						LayoutOrder = 1,
						Image = v6.assetId,
						imageStyle = v9.Color.Content.Emphasis,
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.new(0, v22, 0, v21)
					}),
					Label = module.createElement(text, {
						LayoutOrder = 2,
						tag = "auto-xy text-heading-small content-emphasis",
						Text = v12.noResults
					})
				}
			)
		end

		return module.createElement(module11, {
			title = v12.pageTitle,
			onBack = props.onBack,
			renderTrailing = props.renderTrailing,
			maxContentWidth = 600,
			fillContent = true
		}, { Header = element, EmptyState = v20, Footer = v19 })
	end

	return module.createElement(module11, {
		title = v12.pageTitle,
		onBack = props.onBack,
		renderTrailing = props.renderTrailing,
		maxContentWidth = 600,
		fillContent = true
	}, {
		List = module.createElement(verticalUserList, {
			entities = props.members,
			isScrollEnabled = true,
			configs = v7,
			ctaConfig = v11,
			renderRow = if module10 then fn else nil,
			layoutOrder = 1,
			ListHeaderComponent = element,
			ListFooterComponent = v19
		})
	})
end

return SchoolMemberListPage
