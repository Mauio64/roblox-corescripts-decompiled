local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module3 = require("@luauforge/deferred/eUX")
local module4 = require("@luauforge/deferred/eWs")
local module5 = require("@luauforge/deferred/ehb")

local view = Foundation.View
local text = Foundation.Text

local function GraduationYearPage(props)
	local graduationYearAlumniCaption = module5.GraduationYearAlumniCaption

	local v5 = useLocalization({
		headerTitle = module5.AddSchoolHeading,
		heading = module5.GraduationYearHeading,
		body = {
			graduationYearAlumniCaption,
			school = props.schoolName
		},
		alreadyGraduated = module5.GraduationYearAlreadyGraduated
	})

	return module.createElement(
		module3,
		{
			title = v5.headerTitle,
			onBack = props.onBack,
			fillContent = true,
			testId = "schools-graduation-year-page"
		},
		{
			HeadingBody = module.createElement(
				view,
				{ LayoutOrder = 1, tag = "col align-x-left size-full-0 auto-y" },
				{
					Heading = module.createElement(text, {
						LayoutOrder = 1,
						Text = v5.heading,
						tag = "size-full-0 auto-y padding-bottom-xsmall text-heading-medium text-wrap text-align-x-left content-emphasis"
					}),
					Body = module.createElement(text, {
						LayoutOrder = 2,
						Text = v5.body,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
					})
				}
			),
			List = module.createElement(module4, {
				layoutOrder = 2,
				years = props.years,
				selectedYearId = props.selectedYearId,
				onYearSelected = props.onYearSelected,
				hasAlumniOption = props.hasAlumniOption,
				alreadyGraduatedLabel = v5.alreadyGraduated,
				onAlumniSelected = props.onAlumniSelected,
				errorMessage = props.errorMessage
			})
		}
	)
end

return GraduationYearPage
