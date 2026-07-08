local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
local Checkbox = Foundation.Checkbox
local FoundationImage = Foundation.Image
local EnumScaleType = Enum.ScaleType
local FoundationText = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local ComponentSubtext = require(GenericAbuseReporting.Bedui.Components.ComponentSubtext)
local getPlaceMediaAssetIds = require(GenericAbuseReporting.Bedui.Utils.getPlaceMediaAssetIds)
local useFormData = require(GenericAbuseReporting.Bedui.Provider.useFormData)
local uDim2 = UDim2.fromOffset(180, 101)
local t1 = {
	[AbuseVector.Place] = "THUMBNAIL_IDS"
}

local function Selector(t2: {[any]: any}) -- line: 38
	-- upvalues: React (copy), useFormData (copy), useRoactService (copy), RoactNetworking (copy), AbuseVector (copy), getPlaceMediaAssetIds (copy), t1 (copy), View (copy), Checkbox (copy), FoundationImage (copy), EnumScaleType (copy), uDim2 (copy), FoundationText (copy), ComponentSubtext (copy)
	local v20, v21 = React.useState({})
	local v22, v23 = React.useState({})
	local custom = useFormData().custom
	local updateForm = useFormData().updateForm
	local updateAdditionalReportTags = useFormData().updateAdditionalReportTags
	local v27 = useRoactService(RoactNetworking)
	local v28 = React.useRef(`selector-{ DateTime.now() }`)

	React.useEffect(function() -- line: 52
		-- upvalues: t2 (copy), AbuseVector (copy), getPlaceMediaAssetIds (copy), v27 (copy), custom (copy), v21 (copy)
		if t2.abuseVector == AbuseVector.Place then
			getPlaceMediaAssetIds(v27, (tostring(custom and custom.universeId))):andThen(function(p1) -- line: 54
				-- upvalues: v21 (copy)
				v21(p1)
			end)
		end
	end, {
		t2.abuseVector,
		getPlaceMediaAssetIds,
		v27,
		custom and custom.universeId
	})

	local v29 = React.useCallback(function(s1: string) -- line: 61
		-- upvalues: v23 (copy), t2 (copy), AbuseVector (copy), updateAdditionalReportTags (copy), v28 (copy), t1 (copy)
		v23(function(p2) -- line: 62
			-- upvalues: s1 (copy), t2 (copy), AbuseVector (copy), updateAdditionalReportTags (copy), v28 (copy), t1 (copy)
			local v37 = table.clone(p2)
			local v38 = table.find(v37, s1)

			if v38 then
				table.remove(v37, v38)
			else
				table.insert(v37, s1)
			end

			if t2.abuseVector == AbuseVector.Place then
				local v39 = table.concat(v37, ",")

				if updateAdditionalReportTags then
					updateAdditionalReportTags(v28.current, {
						tagKey = t1[t2.abuseVector],
						tagValue = v39
					})
				end
			end

			return v37
		end)
	end, {
		t2.component,
		t2.abuseVector,
		updateForm
	})
	local v30 = React.useMemo(function() -- line: 85
		-- upvalues: v20 (copy), React (copy), View (copy), Checkbox (copy), v22 (copy), v29 (copy), FoundationImage (copy), EnumScaleType (copy), uDim2 (copy)
		local t3 = {}

		for i, v in ipairs(v20) do
			table.insert(t3, React.createElement(View, {
				tag = "size-0-0 auto-xy row gap-small self-center border-radius-medium padding-small",
				LayoutOrder = i
			}, {
				Checkbox = React.createElement(Checkbox, {
					label = "",
					isChecked = table.find(v22, v) ~= nil,
					onActivated = function() -- line: 97
						-- upvalues: v29 (copy), v (copy)
						v29(v)
					end
				}),
				Image = React.createElement(FoundationImage, {
					Image = `rbxthumb://type=Asset&id={ v }&w=768&h=432`,
					ScaleType = EnumScaleType.Fit,
					Size = uDim2,
					onActivated = function() -- line: 105
						-- upvalues: v29 (copy), v (copy)
						v29(v)
					end
				})
			}))
		end

		return t3
	end, {
		v20,
		v22
	})

	if #v20 ~= 0 then
		return (React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small",
			LayoutOrder = t2.layoutOrder
		}, {
			Prompt = React.createElement(FoundationText, {
				tag = "auto-xy",
				LayoutOrder = 0,
				Text = t2.component.selector.prompt
			}),
			CheckboxGroup = React.createElement(View, {
				tag = "size-full-0 auto-y col",
				LayoutOrder = 1
			}, v30),
			ComponentSubtext = React.createElement(ComponentSubtext, {
				layoutOrder = 2,
				isErrorState = t2.isErrorState,
				isOptional = t2.component.isOptional,
				requirementMessage = t2.component.requirementMessage
			})
		}))
	end

	return nil
end

return React.memo(Selector)
