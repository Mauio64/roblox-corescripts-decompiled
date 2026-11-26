local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/fdc")
require("@luauforge/deferred/ekr")
local module4 = require("@luauforge/deferred/fdi")

local view = Foundation.View
local button = Foundation.Button
local scrollView = Foundation.ScrollView
local optionSelectorGroup = Foundation.OptionSelectorGroup
local viewportVisibilityImpressionsDetector = module3.ViewportVisibilityImpressionsDetector

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local visibility = Foundation.Enums.Visibility

local function formatLocation(p2)
	if p2.city and p2.state then
		return `{p2.city} • {p2.state}`
	end

	return p2.city or p2.state
end

local function SchoolItemWithImpression(props)
	local ref = module.useRef(nil)
	local school = props.school
	local index = props.index
	local onImpression = props.onImpression

	local v5 = module.useCallback(function()
		if onImpression then
			onImpression(school.id, index)
		end
	end, { onImpression, school.id, index })

	local createElement = module.createElement

	local createElement2 = module.createElement
	local item = optionSelectorGroup.Item
	local v9 = { value = school.id, label = school.name, description = 0 }
	local v10 = if school.city and school.state then `{school.city} • {school.state}` else school.city or school.state

	v9.description = v10
	local v8 = { Item = createElement2(item, v9), Detector = 0 }

	local v11 = if onImpression then module.createElement(viewportVisibilityImpressionsDetector, {
		targetRef = ref,
		onImpression = v5
	}) else nil
	v8.Detector = v11
	return createElement(view, {
		ref = ref,
		tag = "size-full-0 auto-y",
		LayoutOrder = index
	}, v8)
end

local function SchoolList(props)
	local children = {}

	for k, school in props.schools do
		if module4 then
			children[school.id] = module.createElement(SchoolItemWithImpression, {
				school = school,
				index = k,
				onImpression = props.onSchoolImpression
			})
		else
			local id = school.id
			local createElement = module.createElement
			local item = optionSelectorGroup.Item
			local v5 = {
				value = school.id,
				label = school.name,
				description = 0,
				LayoutOrder = 0
			}
			local v6 = if school.city and school.state then `{school.city} • {school.state}` else school.city or school.state

			v5.description = v6
			v5.LayoutOrder = k
			children[id] = createElement(item, v5)
		end
	end

	local ref = if module4 then module.useRef(false) else nil
	local onScrollStarted = if module4 then props.onScrollStarted else nil
	local v5 = module.useCallback(function(p2)
		if module4 and onScrollStarted and ref and not ref.current then
			ref.current = true
			onScrollStarted()
		end
	end, { onScrollStarted })

	local createElement = module.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "fill size-full-0",
		onCanvasPositionChanged = 0,
		scroll = 0
	}

	if not onScrollStarted then
		v5 = nil
	end

	v7.onCanvasPositionChanged = v5
	v7.scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(1, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		scrollBarVisibility = visibility.None
	}
	return createElement(scrollView, v7, {
		Content = module.createElement(
			view,
			{
				tag = "col gap-large size-full-0 auto-y padding-bottom-large padding-left-xxsmall padding-right-xxsmall padding-top-xxsmall"
			},
			{
				ListBody = module.createElement(
					optionSelectorGroup.Root,
					{
						LayoutOrder = 1,
						value = props.selectedSchoolId,
						onValueChanged = props.onSchoolSelected
					},
					{
						Items = module.createElement(
							view,
							{ tag = "col gap-medium size-full-0 auto-y" },
							children
						)
					}
				),
				CantFind = module.createElement(button, {
					LayoutOrder = 2,
					text = props.cantFindAction,
					size = inputSize.Medium,
					variant = buttonVariant.Utility,
					width = UDim.new(1, 0),
					onActivated = props.onCantFindSchool
				})
			}
		)
	})
end

return SchoolList
