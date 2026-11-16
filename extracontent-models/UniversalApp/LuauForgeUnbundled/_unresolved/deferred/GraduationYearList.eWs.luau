local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")

local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local scrollView = Foundation.ScrollView
local optionSelectorGroup = Foundation.OptionSelectorGroup

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local visibility = Foundation.Enums.Visibility

local function GraduationYearList(props)
	local children = {}

	for k, year in props.years do
		children[year.id] = module.createElement(optionSelectorGroup.Item, {
			value = year.id,
			label = year.text,
			LayoutOrder = k
		})
	end

	local createElement = module.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = "fill size-full-0",
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = visibility.None
		}
	}

	local createElement2 = module.createElement

	local v10 = {
		ListBody = module.createElement(optionSelectorGroup.Root, {
			LayoutOrder = 1,
			value = props.selectedYearId,
			onValueChanged = function(p2)
				if p2 ~= nil then
					props.onYearSelected(p2)
				end
			end
		}, {
			Items = module.createElement(view, {
				tag = "col gap-medium size-full-0 auto-y"
			}, children)
		}),
		AlreadyGraduated = 0,
		Error = 0
	}

	local v11 = if props.hasAlumniOption then module.createElement(button, {
		LayoutOrder = 2,
		text = props.alreadyGraduatedLabel,
		size = inputSize.Medium,
		variant = buttonVariant.Utility,
		width = UDim.new(1, 0),
		onActivated = props.onAlumniSelected
	}) else nil
	v10.AlreadyGraduated = v11

	local v12 = if props.errorMessage ~= nil then module.createElement(text, {
		LayoutOrder = 3,
		Text = props.errorMessage,
		tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-system-alert"
	}) else nil
	v10.Error = v12
	return createElement(scrollView, v6, {
		Content = createElement2(
			view,
			{
				tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-left-xxsmall padding-right-xxsmall padding-top-xxsmall"
			},
			v10
		)
	})
end

return GraduationYearList
