local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

local checkbox = Foundation.Checkbox
local image = Foundation.Image
local scaleType = Enum.ScaleType
local text = Foundation.Text
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/ComponentSubtext")
local getPlaceMediaAssetIds = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/getPlaceMediaAssetIds")
local useFormData = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useFormData")

local udim = UDim2.fromOffset(180, 101)

local v5 = { [AbuseVector.Place] = "THUMBNAIL_IDS" }

local function Selector(props)
	local state, setState = React.useState({})

	local state2, setState2 = React.useState({})

	local custom = useFormData().custom
	local updateForm = useFormData().updateForm
	local updateAdditionalReportTags = useFormData().updateAdditionalReportTags
	local v6 = useRoactService(roactNetworking)

	local ref = React.useRef(`selector-{DateTime.now()}`)

	React.useEffect(function()
		if props.abuseVector == AbuseVector.Place then
			getPlaceMediaAssetIds(v6, (tostring(custom and custom.universeId))):andThen(function(p2)
				setState(p2)
			end)
		end
	end, {
		props.abuseVector,
		getPlaceMediaAssetIds,
		v6,
		custom and custom.universeId
	})

	local v7 = React.useCallback(function(p2)
		setState2(function(p3)
			local clone = table.clone(p3)
			local index = table.find(clone, p2)

			if index then
				table.remove(clone, index)
			else
				table.insert(clone, p2)
			end

			if props.abuseVector == AbuseVector.Place then
				local joined = table.concat(clone, ",")

				if updateAdditionalReportTags then
					updateAdditionalReportTags(ref.current, {
						tagKey = v5[props.abuseVector],
						tagValue = joined
					})
				end
			end

			return clone
		end)
	end, { props.component, props.abuseVector, updateForm })

	local v8 = React.useMemo(function()
		local children = {}

		for i, v9 in ipairs(state) do
			table.insert(
				children,
				React.createElement(
					view,
					{
						tag = "size-0-0 auto-xy row gap-small self-center border-radius-medium padding-small",
						LayoutOrder = i
					},
					{
						Checkbox = React.createElement(checkbox, {
							label = "",
							isChecked = table.find(state2, v9) ~= nil,
							onActivated = function()
								v7(v9)
							end
						}),
						Image = React.createElement(image, {
							Image = `rbxthumb://type=Asset&id={v9}&w=768&h=432`,
							ScaleType = scaleType.Fit,
							Size = udim,
							onActivated = function()
								v7(v9)
							end
						})
					}
				)
			)
		end

		return children
	end, { state, state2 })

	if #state == 0 then
		return nil
	end

	return (React.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = props.layoutOrder },
		{
			Prompt = React.createElement(text, {
				Text = props.component.selector.prompt,
				tag = "auto-xy",
				LayoutOrder = 0
			}),
			CheckboxGroup = React.createElement(
				view,
				{ tag = "size-full-0 auto-y col", LayoutOrder = 1 },
				v8
			),
			ComponentSubtext = React.createElement(module4, {
				isErrorState = props.isErrorState,
				isOptional = props.component.isOptional,
				requirementMessage = props.component.requirementMessage,
				layoutOrder = 2
			})
		}
	))
end

return React.memo(Selector)
