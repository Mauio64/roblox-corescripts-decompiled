local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local Foundation = require(SchoolsParent.Foundation)
local UserList = require(SchoolsParent.UserList)
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local TextKeys = require(Schools.Common.TextKeys)
local SchoolMembersMock = require(Schools.Common.SchoolMembersMock)
local SchoolsPage = require(Schools.Components.Common.SchoolsPage)
local FilterChip = require(script.Parent.FilterChip)
local View = Foundation.View
local FoundationText = Foundation.Text
local VerticalUserList = UserList.VerticalUserList.VerticalUserList
local t1 = {
	showSubtitle = true,
	showPresence = true
}

local function SchoolMemberListPage(t2: {[any]: any}) -- line: 39
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), SchoolMembersMock (copy), SchoolsPage (copy), FoundationText (copy), View (copy), FilterChip (copy), VerticalUserList (copy), t1 (copy)
	local classYears = t2.classYears
	local v18 = useLocalization({
		pageTitle = TextKeys.PageTitle,
		membersWithCount = {
			TextKeys.MembersWithCount,
			count = t2.memberCount
		},
		apply = TextKeys.FilterApply,
		gradYear = TextKeys.FilterGradYear,
		allYears = TextKeys.FilterAllYears
	})
	local v19 = React.useMemo(function() -- line: 50
		-- upvalues: SchoolMembersMock (copy), v18 (copy), classYears (copy)
		local t3 = {{
			id = SchoolMembersMock.ALL_YEARS,
			text = v18.allYears
		}}

		for _, v22 in classYears do
			table.insert(t3, {
				id = tostring(v22),
				text = tostring(v22)
			})
		end

		return t3
	end, {
		v18.allYears,
		classYears
	})

	return React.createElement(SchoolsPage, {
		maxContentWidth = 600,
		fillContent = true,
		title = v18.pageTitle,
		onBack = t2.onBack
	}, {
		Heading = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-heading-medium text-align-x-left content-default",
			LayoutOrder = 1,
			Text = t2.schoolName
		}),
		Body = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 2,
			Text = t2.location
		}),
		SectionTitle = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-title-large text-align-x-left content-emphasis",
			LayoutOrder = 3,
			Text = v18.membersWithCount
		}),
		Filters = React.createElement(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y",
			LayoutOrder = 4
		}, {
			GradYear = React.createElement(FilterChip, {
				layoutOrder = 1,
				label = v18.gradYear,
				sheetTitle = v18.gradYear,
				applyText = v18.apply,
				value = t2.gradYear,
				defaultValue = SchoolMembersMock.ALL_YEARS,
				options = v19,
				onChanged = t2.onGradYearChanged
			})
		}),
		List = React.createElement(VerticalUserList, {
			isScrollEnabled = true,
			layoutOrder = 5,
			entities = t2.members,
			configs = t1
		})
	})
end

return SchoolMemberListPage
