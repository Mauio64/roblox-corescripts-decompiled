local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local Checkbox = Foundation.Checkbox
local Image = Foundation.Image
local ScaleType = Enum.ScaleType
local Text = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local ComponentSubtext = require(GenericAbuseReporting.Bedui.Components.ComponentSubtext)
local getPlaceMediaAssetIds = require(GenericAbuseReporting.Bedui.Utils.getPlaceMediaAssetIds)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)

local udim = UDim2.fromOffset(180, 101)

local v = { [AbuseVector.Place] = "THUMBNAIL_IDS" }

local function Selector(props)
	local state, setState = React.useState({})

	local state2, setState2 = React.useState({})

	local custom = useFormData().custom
	local updateForm = useFormData().updateForm
	local updateAdditionalReportTags = useFormData().updateAdditionalReportTags
	local v2 = useRoactService(RoactNetworking)

	local ref = React.useRef(`selector-{DateTime.now()}`)

	React.useEffect(function()
		if props.abuseVector == AbuseVector.Place then
			getPlaceMediaAssetIds(v2, (tostring(custom and custom.universeId))):andThen(function(p)
				setState(p)
			end)
		end
	end, {
		props.abuseVector,
		getPlaceMediaAssetIds,
		v2,
		custom and custom.universeId
	})

	local v3 = React.useCallback(function(p: string)
		setState2(function(p2)
			local clone = table.clone(p2)
			local index = table.find(clone, p)

			if index then
				table.remove(clone, index)
			else
				table.insert(clone, p)
			end

			if props.abuseVector == AbuseVector.Place then
				local joined = table.concat(clone, ",")

				if updateAdditionalReportTags then
					updateAdditionalReportTags(ref.current, {
						tagKey = v[props.abuseVector],
						tagValue = joined
					})
				end
			end

			return clone
		end)
	end, { props.component, props.abuseVector, updateForm })

	local v4 = React.useMemo(function()
		local children = {}

		for i, v4 in ipairs(state) do
			table.insert(
				children,
				React.createElement(
					View,
					{
						tag = "size-0-0 auto-xy row gap-small self-center border-radius-medium padding-small",
						LayoutOrder = i
					},
					{
						Checkbox = React.createElement(Checkbox, {
							label = "",
							isChecked = table.find(state2, v4) ~= nil,
							onActivated = function()
								v3(v4)
							end
						}),
						Image = React.createElement(Image, {
							Image = `rbxthumb://type=Asset&id={v4}&w=768&h=432`,
							ScaleType = ScaleType.Fit,
							Size = udim,
							onActivated = function()
								v3(v4)
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

	return (React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = props.layoutOrder
	}, {
		Prompt = React.createElement(Text, {
			Text = props.component.selector.prompt,
			tag = "auto-xy",
			LayoutOrder = 0
		}),
		CheckboxGroup = React.createElement(View, {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 1
		}, v4),
		ComponentSubtext = React.createElement(ComponentSubtext, {
			isErrorState = props.isErrorState,
			isOptional = props.component.isOptional,
			requirementMessage = props.component.requirementMessage,
			layoutOrder = 2
		})
	}))
end

return React.memo(Selector)
